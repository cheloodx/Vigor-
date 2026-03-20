// ============================================================================
// POST /orders/esim - Create an eSIM order
// ============================================================================
// Requires auth. Flow:
// 1. Validate plan exists
// 2. Create order in DB (status: pending)
// 3. Call Airalo API to provision eSIM
// 4. Store eSIM details (ICCID, QR code, activation code) in user_esims
// 5. Update order status to completed
// 6. Return QR code + activation details to user
// ============================================================================

import { Router, Request, Response } from 'express';
import { supabase } from '../config/database';
import { requireAuth } from '../middleware/auth';
import { hasAiraloCredentials, createAiraloOrder } from '../services/airalo';
import { OrderEsimRequest, ApiResponse, Plan, Order, UserEsim } from '../types';

const router = Router();

router.post('/esim', requireAuth, async (req: Request, res: Response) => {
  try {
    const { plan_id, apple_transaction_id } = req.body as OrderEsimRequest;
    const userId = req.userId!;

    // 1. Validate request
    if (!plan_id) {
      const response: ApiResponse<null> = { success: false, error: 'plan_id is required' };
      res.status(400).json(response);
      return;
    }

    // 2. Fetch the plan
    const { data: plan, error: planError } = await supabase
      .from('plans')
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

    // 3. Create order (status: pending)
    const { data: order, error: orderError } = await supabase
      .from('orders')
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

    // 4. Provision eSIM via Airalo (or mock)
    let esimData: {
      iccid: string;
      activation_code: string;
      qr_code_url: string;
      qr_code_data: string;
      airalo_order_id: string;
      airalo_esim_id: string;
    };

    if (hasAiraloCredentials()) {
      // Real Airalo API call
      try {
        const airaloResult = await createAiraloOrder(planData.slug);
        const sim = airaloResult.data.sims[0];

        esimData = {
          iccid: sim.iccid,
          activation_code: sim.confirmation_code,
          qr_code_url: sim.qrcode_url,
          qr_code_data: sim.lpa,
          airalo_order_id: String(airaloResult.data.id),
          airalo_esim_id: String(sim.id),
        };
      } catch (airaloErr) {
        // If Airalo fails, mark order as failed
        await supabase
          .from('orders')
          .update({ status: 'failed', error_message: String(airaloErr) })
          .eq('id', orderData.id);

        const message = airaloErr instanceof Error ? airaloErr.message : 'Airalo API error';
        const response: ApiResponse<null> = { success: false, error: message };
        res.status(502).json(response);
        return;
      }
    } else {
      // Mock eSIM for development/demo
      const mockIccid = `8940${Date.now()}${Math.floor(Math.random() * 1000)}`;
      esimData = {
        iccid: mockIccid,
        activation_code: `SC-${planData.country_code}-${Date.now().toString(36).toUpperCase()}`,
        qr_code_url: `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=LPA:1$smdp.io$${mockIccid}`,
        qr_code_data: `LPA:1$smdp.io$${mockIccid}`,
        airalo_order_id: `mock-${Date.now()}`,
        airalo_esim_id: `mock-esim-${Date.now()}`,
      };
    }

    // 5. Create user_esim record
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
        airalo_esim_id: esimData.airalo_esim_id,
      })
      .select()
      .single();

    if (esimError || !userEsim) {
      // Mark order as failed and record the error
      await supabase
        .from('orders')
        .update({ status: 'failed', error_message: esimError?.message || 'Failed to create eSIM record', airalo_order_id: esimData.airalo_order_id })
        .eq('id', orderData.id);

      const response: ApiResponse<null> = { success: false, error: 'Failed to create eSIM record' };
      res.status(500).json(response);
      return;
    }

    // 6. Update order to completed
    await supabase
      .from('orders')
      .update({ status: 'completed', airalo_order_id: esimData.airalo_order_id })
      .eq('id', orderData.id);

    // 7. Return success with QR code
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

export default router;
