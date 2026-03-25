// ============================================================================
// Orders Routes
// ============================================================================
// Two flows:
// 1. Auth-based: POST /orders/esim (requires auth, used by iOS app)
// 2. Stripe-based: POST /api/orders/provision + GET /api/orders/:sessionId
// ============================================================================

import { Router, Request, Response } from 'express';
import { supabase } from '../config/database';
import { requireAuth } from '../middleware/auth';
import { hasEsimAccessCredentials, orderEsim, queryProfiles, findPackage } from '../services/esimAccess';
import { OrderEsimRequest, ApiResponse, Plan, Order, UserEsim } from '../types';
import { provisionForSession } from '../services/provisioning';
import { getOrderBySessionId } from '../services/supabase';

// Auth-based router (mounted at /orders)
const authRouter = Router();
// Stripe-based router (mounted at /api/orders)
const stripeRouter = Router();

// ---------------------------------------------------------------------------
// POST /orders/esim — Auth-based eSIM order (iOS app flow)
// ---------------------------------------------------------------------------
authRouter.post('/esim', requireAuth, async (req: Request, res: Response) => {
  try {
    const { plan_id, apple_transaction_id } = req.body as OrderEsimRequest;
    const userId = req.userId!;

    if (!plan_id) {
      const response: ApiResponse<null> = { success: false, error: 'plan_id is required' };
      res.status(400).json(response);
      return;
    }

    const { data: plan, error: planError } = await supabase
      .from('esim_plans')
      .select('*')
      .eq('id', plan_id)
      .eq('is_active', true)
      .single();

    if (planError || !plan) {
      const response: ApiResponse<null> = { success: false, error: 'Plan not found or inactive' };
      res.status(404).json(response);
      return;
    }

    const planData = plan as Plan;

    const { data: order, error: orderError } = await supabase
      .from('esim_orders')
      .insert({
        user_id: userId,
        plan_id: planData.id,
        status: 'processing',
        apple_transaction_id: apple_transaction_id || null,
        price_paid: planData.price,
        currency: planData.currency,
      })
      .select()
      .single();

    if (orderError || !order) {
      const response: ApiResponse<null> = { success: false, error: 'Failed to create order' };
      res.status(500).json(response);
      return;
    }

    const orderData = order as Order;

    let esimData: {
      iccid: string;
      activation_code: string;
      qr_code_url: string;
      qr_code_data: string;
      esim_order_no: string;
      esim_tran_no: string;
    };

    if (hasEsimAccessCredentials()) {
      try {
        // Find the matching eSIM Access package
        const pkg = await findPackage(planData.country_code, planData.data_label);
        if (!pkg) {
          throw new Error(`No eSIM Access package found for ${planData.country_code} ${planData.data_label}`);
        }

        // Order the eSIM
        const esimOrder = await orderEsim(pkg.packageCode, pkg.price);

        // Poll for profile allocation (up to 60 seconds)
        const profiles = await queryProfiles(esimOrder.orderNo, 60000);
        if (!profiles || profiles.length === 0) {
          throw new Error('eSIM Access order succeeded but no profiles allocated');
        }
        const profile = profiles[0];

        esimData = {
          iccid: profile.iccid,
          activation_code: profile.ac || '',
          qr_code_url: profile.qrCodeUrl || '',
          qr_code_data: profile.ac || '',
          esim_order_no: esimOrder.orderNo,
          esim_tran_no: profile.esimTranNo,
        };
      } catch (esimErr) {
        await supabase
          .from('esim_orders')
          .update({ status: 'failed', error_message: String(esimErr) })
          .eq('id', orderData.id);

        const message = esimErr instanceof Error ? esimErr.message : 'eSIM Access API error';
        const response: ApiResponse<null> = { success: false, error: message };
        res.status(502).json(response);
        return;
      }
    } else {
      const mockIccid = `8940${Date.now()}${Math.floor(Math.random() * 1000)}`;
      esimData = {
        iccid: mockIccid,
        activation_code: `SC-${planData.country_code}-${Date.now().toString(36).toUpperCase()}`,
        qr_code_url: `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=LPA:1$smdp.io$${mockIccid}`,
        qr_code_data: `LPA:1$smdp.io$${mockIccid}`,
        esim_order_no: `mock-${Date.now()}`,
        esim_tran_no: `mock-esim-${Date.now()}`,
      };
    }

    const { data: userEsim, error: esimError } = await supabase
      .from('user_esims')
      .insert({
        user_id: userId,
        order_id: orderData.id,
        iccid: esimData.iccid,
        activation_code: esimData.activation_code,
        qr_code_url: esimData.qr_code_url,
        qr_code_data: esimData.qr_code_data,
        country_code: planData.country_code,
        country_name: planData.country_name,
        data_limit_mb: planData.data_limit_mb,
        data_label: planData.data_label,
        valid_days: planData.valid_days,
        status: 'pending',
        esim_tran_no: esimData.esim_tran_no,
      })
      .select()
      .single();

    if (esimError || !userEsim) {
      await supabase
        .from('esim_orders')
        .update({ status: 'failed', error_message: esimError?.message || 'Failed to create eSIM record', esim_order_no: esimData.esim_order_no })
        .eq('id', orderData.id);

      const response: ApiResponse<null> = { success: false, error: 'Failed to create eSIM record' };
      res.status(500).json(response);
      return;
    }

    const { error: updateError } = await supabase
      .from('esim_orders')
      .update({ status: 'completed', esim_order_no: esimData.esim_order_no })
      .eq('id', orderData.id);

    if (updateError) {
      console.error(`Failed to mark order ${orderData.id} as completed: ${updateError.message}`);
    }

    const response: ApiResponse<UserEsim> = {
      success: true,
      data: userEsim as UserEsim,
    };

    res.status(201).json(response);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    const response: ApiResponse<null> = { success: false, error: message };
    res.status(500).json(response);
  }
});

// ---------------------------------------------------------------------------
// POST /api/orders/provision — Stripe-based provisioning (web flow)
// ---------------------------------------------------------------------------
stripeRouter.post('/provision', async (req: Request, res: Response) => {
  try {
    const { sessionId } = req.body;

    if (!sessionId) {
      res.status(400).json({ error: 'Missing required field: sessionId' });
      return;
    }

    const result = await provisionForSession(sessionId);

    if (!result.success) {
      res.status(500).json({ error: result.error || 'Provisioning failed' });
      return;
    }

    res.json({
      success: true,
      order: {
        id: result.order?.id,
        status: result.order?.status,
        planId: result.order?.plan_id,
        countryName: result.order?.country_name,
        dataLabel: result.order?.data_label,
        iccid: result.order?.iccid,
        qrcodeUrl: result.order?.qrcode_url,
        lpa: result.order?.lpa,
        matchingId: result.order?.matching_id,
        directAppleInstallUrl: result.order?.direct_apple_install_url,
      },
    });
  } catch (err) {
    console.error('Provision error:', err);
    const message = err instanceof Error ? err.message : 'Failed to provision eSIM';
    res.status(500).json({ error: message });
  }
});

// ---------------------------------------------------------------------------
// GET /api/orders/:sessionId — Get order by Stripe session ID
// ---------------------------------------------------------------------------
stripeRouter.get('/:sessionId', async (req: Request, res: Response) => {
  try {
    const order = await getOrderBySessionId(req.params.sessionId);

    if (!order) {
      res.status(404).json({ error: 'Order not found' });
      return;
    }

    res.json({
      id: order.id,
      status: order.status,
      planId: order.plan_id,
      countryCode: order.country_code,
      countryName: order.country_name,
      dataLabel: order.data_label,
      validDays: order.valid_days,
      price: order.price,
      currency: order.currency,
      iccid: order.iccid,
      qrcodeUrl: order.qrcode_url,
      lpa: order.lpa,
      matchingId: order.matching_id,
      directAppleInstallUrl: order.direct_apple_install_url,
      error: order.error_message || undefined,
      createdAt: order.created_at,
    });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to get order';
    res.status(500).json({ error: message });
  }
});

export default authRouter;
export { stripeRouter as ordersRouter };
