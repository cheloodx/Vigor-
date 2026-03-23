// ============================================================================
// GET /plans - List available eSIM plans
// ============================================================================
// Query params:
//   ?country_code=JP  - Filter by country
//   ?region=Europa    - Filter by region (Europa, Americas)
//
// Public endpoint (no auth required) - users browse plans before purchasing.
// ============================================================================

import { Router, Request, Response } from 'express';
import { supabase } from '../config/database';
import { Plan, ApiResponse } from '../types';

const router = Router();

router.get('/', async (req: Request, res: Response) => {
  try {
    const { country_code, region } = req.query;

    let query = supabase
      .from('esim_plans')
      .select('*')
      .eq('is_active', true)
      .order('country_name', { ascending: true })
      .order('data_limit_mb', { ascending: true });

    if (country_code && typeof country_code === 'string') {
      query = query.eq('country_code', country_code.toUpperCase());
    }

    if (region && typeof region === 'string') {
      query = query.eq('region', region);
    }

    const { data, error } = await query;

    if (error) {
      const response: ApiResponse<null> = { success: false, error: error.message };
      res.status(500).json(response);
      return;
    }

    // Group plans by country for easier frontend consumption
    const plans = data as Plan[];
    const grouped: Record<string, { country_code: string; country_name: string; region: string; plans: Plan[] }> = {};

    for (const plan of plans) {
      if (!grouped[plan.country_code]) {
        grouped[plan.country_code] = {
          country_code: plan.country_code,
          country_name: plan.country_name,
          region: plan.region,
          plans: [],
        };
      }
      grouped[plan.country_code].plans.push(plan);
    }

    const response: ApiResponse<typeof grouped> = {
      success: true,
      data: grouped,
    };

    res.json(response);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    const response: ApiResponse<null> = { success: false, error: message };
    res.status(500).json(response);
  }
});

export default router;
