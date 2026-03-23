// ============================================================================
// GET /subscription/status - Check subscription status
// ============================================================================
// Requires auth. Returns the user's active subscription (if any).
// Used by the app to determine premium access.
// ============================================================================

import { Router, Request, Response } from 'express';
import { supabase } from '../config/database';
import { requireAuth } from '../middleware/auth';
import { ApiResponse, Subscription } from '../types';

const router = Router();

router.get('/status', requireAuth, async (req: Request, res: Response) => {
  try {
    const userId = req.userId!;

    // Find the most recent active/trial subscription
    const { data, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('user_id', userId)
      .in('status', ['active', 'trial'])
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle();

    if (error) {
      const response: ApiResponse<null> = { success: false, error: error.message };
      res.status(500).json(response);
      return;
    }

    const subscription = data as Subscription | null;

    // Check if expired
    if (subscription && subscription.expires_at) {
      const expiresAt = new Date(subscription.expires_at);
      if (expiresAt < new Date()) {
        // Mark as expired in DB
        await supabase
          .from('subscriptions')
          .update({ status: 'expired' })
          .eq('id', subscription.id);

        const response: ApiResponse<{ has_subscription: boolean; subscription: null }> = {
          success: true,
          data: { has_subscription: false, subscription: null },
        };
        res.json(response);
        return;
      }
    }

    const response: ApiResponse<{ has_subscription: boolean; subscription: Subscription | null }> = {
      success: true,
      data: {
        has_subscription: !!subscription,
        subscription,
      },
    };

    res.json(response);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    const response: ApiResponse<null> = { success: false, error: message };
    res.status(500).json(response);
  }
});

export default router;
