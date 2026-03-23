/**
 * Orders Route
 *
 * Handles order provisioning and status checking.
 * POST /api/orders/provision — Provision eSIM after payment verification
 * GET /api/orders/:sessionId — Get order status and eSIM details
 */

import { Router, Request, Response } from 'express';
import { provisionForSession } from '../services/provisioning';
import { getOrderBySessionId } from '../services/supabase';

const router = Router();

// ---------------------------------------------------------------------------
// POST /api/orders/provision
// Called by frontend after payment verification to provision the eSIM
// ---------------------------------------------------------------------------
router.post('/provision', async (req: Request, res: Response) => {
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
// GET /api/orders/:sessionId
// Get order status and eSIM details by Stripe session ID
// ---------------------------------------------------------------------------
router.get('/:sessionId', async (req: Request, res: Response) => {
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
      createdAt: order.created_at,
    });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to get order';
    res.status(500).json({ error: message });
  }
});

export { router as ordersRouter };
