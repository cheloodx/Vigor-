// ============================================================================
// GET /my-esims - List user's eSIM profiles
// ============================================================================
// Requires auth. Returns all eSIM profiles for the authenticated user,
// ordered by most recent first. Includes QR code URLs for activation.
// ============================================================================

import { Router, Request, Response } from 'express';
import { supabase } from '../config/database';
import { requireAuth } from '../middleware/auth';
import { ApiResponse, UserEsim } from '../types';

const router = Router();

router.get('/', requireAuth, async (req: Request, res: Response) => {
  try {
    const userId = req.userId!;

    const { data, error } = await supabase
      .from('user_esims')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      const response: ApiResponse<null> = { success: false, error: error.message };
      res.status(500).json(response);
      return;
    }

    const esims = data as UserEsim[];

    const response: ApiResponse<UserEsim[]> = {
      success: true,
      data: esims,
    };

    res.json(response);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    const response: ApiResponse<null> = { success: false, error: message };
    res.status(500).json(response);
  }
});

export default router;
