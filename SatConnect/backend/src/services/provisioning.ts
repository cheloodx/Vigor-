/**
 * eSIM Provisioning Service
 *
 * Orchestrates the full flow: payment confirmed → find Airalo package → order eSIM → store in DB.
 * Called from both webhook (auto) and manual verification endpoint.
 */

import Stripe from 'stripe';
import { isAiraloConfigured, findPackage, orderESIM } from './airalo';
import {
  isSupabaseConfigured,
  createOrder,
  updateOrderStatus,
  getOrderBySessionId,
  Order,
} from './supabase';
import { getPlanById } from '../data/planCatalog';

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
  const plan = getPlanById(planId);
  if (!plan) return null;

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
 * 2. Find the matching Airalo package
 * 3. Order the eSIM from Airalo
 * 4. Store the eSIM details in Supabase
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

  // Already being provisioned by another call? Wait and re-check
  if (order.status === 'provisioning') {
    return { success: false, error: 'Provisioning already in progress' };
  }

  // 3. Mark as provisioning
  await updateOrderStatus(stripeSessionId, 'provisioning');

  // 3. Check if Airalo is configured
  if (!isAiraloConfigured()) {
    // Demo mode: create a mock eSIM
    const mockOrder = await updateOrderStatus(stripeSessionId, 'provisioned', {
      iccid: `DEMO-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      qrcode_url: 'https://via.placeholder.com/300x300.png?text=Demo+eSIM+QR',
      lpa: 'demo.lpa.example.com',
      matching_id: 'DEMO-MATCH-' + Math.random().toString(36).slice(2, 8).toUpperCase(),
      direct_apple_install_url: '',
    });
    console.log('Demo provisioning complete (Airalo not configured)');
    return { success: true, order: mockOrder ?? order };
  }

  try {
    // 4. Find the best matching Airalo package
    const pkg = await findPackage(order.country_code, order.data_label);
    if (!pkg) {
      await updateOrderStatus(stripeSessionId, 'failed', {
        error_message: `No Airalo package found for ${order.country_code} ${order.data_label}`,
      });
      return { success: false, error: 'No matching eSIM package available' };
    }

    // 5. Order the eSIM
    const airaloOrder = await orderESIM(pkg.packageId);

    if (!airaloOrder.sims || airaloOrder.sims.length === 0) {
      await updateOrderStatus(stripeSessionId, 'failed', {
        airalo_order_id: airaloOrder.orderId,
        airalo_order_code: airaloOrder.orderCode,
        error_message: 'Airalo order succeeded but no SIMs returned',
      });
      return { success: false, error: 'eSIM order failed — no SIMs returned' };
    }

    const sim = airaloOrder.sims[0];

    // 6. Store eSIM details
    const updatedOrder = await updateOrderStatus(stripeSessionId, 'provisioned', {
      airalo_order_id: airaloOrder.orderId,
      airalo_order_code: airaloOrder.orderCode,
      iccid: sim.iccid,
      qrcode_url: sim.qrcode_url,
      lpa: sim.lpa,
      matching_id: sim.matching_id,
      direct_apple_install_url: sim.direct_apple_installation_url,
    });

    console.log(`eSIM provisioned: ICCID=${sim.iccid}, Order=${airaloOrder.orderCode}`);
    return { success: true, order: updatedOrder ?? order };
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown provisioning error';
    console.error('Provisioning failed:', message);
    await updateOrderStatus(stripeSessionId, 'failed', { error_message: message });
    return { success: false, error: message };
  }
}
