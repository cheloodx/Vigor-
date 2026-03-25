/**
 * eSIM Provisioning Service
 *
 * Orchestrates the full flow: payment confirmed → find eSIM Access package → order eSIM → store in DB.
 * Called from both webhook (auto) and manual verification endpoint.
 */

import Stripe from 'stripe';
import { isEsimAccessConfigured, findPackage, orderEsim, queryProfiles } from './esimAccess';
import {
  isSupabaseConfigured,
  createOrder,
  updateOrderStatus,
  getOrderBySessionId,
  Order,
} from './supabase';
import { getPlanById, PlanEntry } from '../data/planCatalog';
import { getCachedApiPlan } from '../routes/plans';

// ---------------------------------------------------------------------------
// In-memory lock to prevent concurrent provisioning for the same session
// ---------------------------------------------------------------------------
const provisionLocks = new Map<string, Promise<ProvisionResult>>();

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface ProvisionResult {
  success: boolean;
  order?: Order;
  error?: string;
}

// ---------------------------------------------------------------------------
// Create order record when checkout session is created
// ---------------------------------------------------------------------------

export async function createOrderForSession(
  stripeSessionId: string,
  planId: string,
): Promise<Order | null> {
  // Check cached API plans first (same prices as storefront), then static catalog
  const apiPlan = getCachedApiPlan(planId);
  let plan: PlanEntry;
  if (apiPlan) {
    plan = {
      id: apiPlan.id,
      countryCode: apiPlan.country_code,
      countryName: apiPlan.country_name,
      countryFlag: '',
      dataLimitMB: apiPlan.data_limit_mb,
      dataLabel: apiPlan.data_label,
      validDays: apiPlan.valid_days,
      price: apiPlan.price,
      currency: apiPlan.currency,
    };
  } else {
    const catalogPlan = getPlanById(planId);
    if (!catalogPlan) return null;
    plan = catalogPlan;
  }

  if (!isSupabaseConfigured()) {
    console.warn('Supabase not configured — skipping order creation');
    return null;
  }

  try {
    return await createOrder({
      stripe_session_id: stripeSessionId,
      plan_id: planId,
      country_code: plan.countryCode,
      country_name: plan.countryName,
      data_label: plan.dataLabel,
      valid_days: plan.validDays,
      price: plan.price,
      currency: plan.currency,
      status: 'pending',
    });
  } catch (err) {
    console.error('Failed to create order record:', err);
    return null;
  }
}

// ---------------------------------------------------------------------------
// Provision eSIM after payment is confirmed
// ---------------------------------------------------------------------------

/**
 * Provision an eSIM for a given Stripe session.
 * 1. Look up the order in Supabase
 * 2. Find the matching eSIM Access package
 * 3. Order the eSIM from eSIM Access
 * 4. Poll for profile allocation
 * 5. Store the eSIM details in Supabase
 *
 * Idempotent: if already provisioned, returns the existing order.
 */
export async function provisionForSession(stripeSessionId: string): Promise<ProvisionResult> {
  // Concurrency guard: if another call is already provisioning this session, wait for it
  const existing = provisionLocks.get(stripeSessionId);
  if (existing) {
    return existing;
  }

  const promise = doProvision(stripeSessionId);
  provisionLocks.set(stripeSessionId, promise);

  try {
    return await promise;
  } finally {
    provisionLocks.delete(stripeSessionId);
  }
}

async function doProvision(stripeSessionId: string): Promise<ProvisionResult> {
  // Check if we have Supabase configured
  if (!isSupabaseConfigured()) {
    return { success: false, error: 'Database not configured' };
  }

  // 1. Verify Stripe payment before provisioning (mandatory — never provision without payment)
  const stripeSecretKey = process.env.STRIPE_SECRET_KEY;
  if (!stripeSecretKey) {
    return { success: false, error: 'Stripe is not configured — cannot verify payment' };
  }

  try {
    const stripe = new Stripe(stripeSecretKey, { apiVersion: '2023-10-16' });
    const session = await stripe.checkout.sessions.retrieve(stripeSessionId);
    if (session.payment_status !== 'paid') {
      return { success: false, error: 'Payment not confirmed — cannot provision eSIM' };
    }
  } catch (err) {
    console.error('Failed to verify Stripe payment:', err);
    return { success: false, error: 'Failed to verify payment status' };
  }

  // 2. Get the order
  let order = await getOrderBySessionId(stripeSessionId);
  if (!order) {
    return { success: false, error: 'Order not found for this session' };
  }

  // Already provisioned? Return existing result (idempotent)
  if (order.status === 'provisioned' && order.iccid) {
    return { success: true, order };
  }

  // Already failed? Allow retry
  if (order.status === 'failed') {
    console.log(`Retrying provisioning for order ${order.id}`);
  }

  // Already being provisioned by another call? Check for stale status
  if (order.status === 'provisioning') {
    const updatedAt = order.updated_at ? new Date(order.updated_at).getTime() : 0;
    const staleThresholdMs = 5 * 60 * 1000; // 5 minutes
    if (Date.now() - updatedAt < staleThresholdMs) {
      return { success: false, error: 'Provisioning already in progress' };
    }
    console.log(`Order ${order.id} stuck in provisioning for > 5 min, retrying`);
  }

  // 3. Mark as provisioning
  await updateOrderStatus(stripeSessionId, 'provisioning');

  // 4. Check if eSIM Access is configured
  if (!isEsimAccessConfigured()) {
    // Demo mode: create a mock eSIM
    const mockOrder = await updateOrderStatus(stripeSessionId, 'provisioned', {
      iccid: `DEMO-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      qrcode_url: 'https://via.placeholder.com/300x300.png?text=Demo+eSIM+QR',
      lpa: 'demo.lpa.example.com',
      matching_id: 'DEMO-MATCH-' + Math.random().toString(36).slice(2, 8).toUpperCase(),
      direct_apple_install_url: '',
    });
    console.log('Demo provisioning complete (eSIM Access not configured)');
    return { success: true, order: mockOrder ?? order };
  }

  try {
    // 5. Find the best matching eSIM Access package
    const pkg = await findPackage(order.country_code, order.data_label);
    if (!pkg) {
      await updateOrderStatus(stripeSessionId, 'failed', {
        error_message: `No eSIM Access package found for ${order.country_code} ${order.data_label}`,
      });
      return { success: false, error: 'No matching eSIM package available' };
    }

    // 6. Order the eSIM
    const esimOrder = await orderEsim(pkg.packageCode, pkg.price, `stripe-${stripeSessionId.slice(0, 40)}`);

    // 7. Poll for profile allocation (up to 60 seconds)
    const profiles = await queryProfiles(esimOrder.orderNo, 60000);

    if (!profiles || profiles.length === 0) {
      await updateOrderStatus(stripeSessionId, 'failed', {
        error_message: 'eSIM Access order succeeded but no profiles allocated',
      });
      return { success: false, error: 'eSIM order failed — no profiles returned' };
    }

    const profile = profiles[0];

    // 8. Store eSIM details
    // Extract matching ID from the LPA activation code (format: LPA:1$smdpAddress$matchingId)
    const acParts = (profile.ac || '').split('$');
    const matchingId = acParts.length >= 3 ? acParts[2] : profile.esimTranNo;

    const esimDetails = {
      iccid: profile.iccid,
      qrcode_url: profile.qrCodeUrl || '',
      lpa: profile.ac || '',
      matching_id: matchingId,
      direct_apple_install_url: profile.appleInstallUrl || '',
    };
    const updatedOrder = await updateOrderStatus(stripeSessionId, 'provisioned', esimDetails);

    console.log(`eSIM provisioned: ICCID=${profile.iccid}, Order=${esimOrder.orderNo}`);

    if (!updatedOrder) {
      console.error(
        `CRITICAL: eSIM Access eSIM ordered but DB update failed. Session=${stripeSessionId}, ICCID=${profile.iccid}, Order=${esimOrder.orderNo}`,
      );
      const fallbackOrder: Order = {
        ...order,
        status: 'provisioned',
        ...esimDetails,
      };
      return { success: true, order: fallbackOrder };
    }

    return { success: true, order: updatedOrder };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown provisioning error';
    console.error('Provisioning failed:', message);
    await updateOrderStatus(stripeSessionId, 'failed', { error_message: message });
    return { success: false, error: message };
  }
}
