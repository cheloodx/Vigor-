/**
 * Supabase Service
 *
 * Handles database operations for orders and eSIM provisioning.
 * Uses the orders table to track payment → provisioning flow.
 */

import { createClient, SupabaseClient } from '@supabase/supabase-js';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface Order {
  id?: string;
  stripe_session_id: string;
  plan_id: string;
  country_code: string;
  country_name: string;
  data_label: string;
  valid_days: number;
  price: number;
  currency: string;
  status: 'pending' | 'paid' | 'provisioning' | 'provisioned' | 'failed';
  airalo_order_id?: number;
  airalo_order_code?: string;
  iccid?: string;
  qrcode_url?: string;
  lpa?: string;
  matching_id?: string;
  direct_apple_install_url?: string;
  error_message?: string;
  created_at?: string;
  updated_at?: string;
}

// ---------------------------------------------------------------------------
// Client
// ---------------------------------------------------------------------------

let client: SupabaseClient | null = null;

function getClient(): SupabaseClient {
  if (client) return client;

  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_KEY;

  if (!url || !key) {
    throw new Error('SUPABASE_URL and SUPABASE_SERVICE_KEY must be set');
  }

  client = createClient(url, key);
  return client;
}

export function isSupabaseConfigured(): boolean {
  return Boolean(process.env.SUPABASE_URL && process.env.SUPABASE_SERVICE_KEY);
}

// ---------------------------------------------------------------------------
// Order operations
// ---------------------------------------------------------------------------

/**
 * Create a new order when a Stripe checkout session is created.
 */
export async function createOrder(order: Omit<Order, 'id' | 'created_at' | 'updated_at'>): Promise<Order> {
  const db = getClient();
  const { data, error } = await db
    .from('orders')
    .insert({
      ...order,
      updated_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (error) {
    console.error('Failed to create order:', error);
    throw new Error(`Failed to create order: ${error.message}`);
  }

  return data as Order;
}

/**
 * Update order status after payment confirmation.
 */
export async function updateOrderStatus(
  stripeSessionId: string,
  status: Order['status'],
  extra?: Partial<Order>,
): Promise<Order | null> {
  const db = getClient();
  const { data, error } = await db
    .from('orders')
    .update({
      ...extra,
      status,
      updated_at: new Date().toISOString(),
    })
    .eq('stripe_session_id', stripeSessionId)
    .select()
    .single();

  if (error) {
    console.error('Failed to update order:', error);
    return null;
  }

  return data as Order;
}

/**
 * Get order by Stripe session ID.
 */
export async function getOrderBySessionId(stripeSessionId: string): Promise<Order | null> {
  const db = getClient();
  const { data, error } = await db
    .from('orders')
    .select()
    .eq('stripe_session_id', stripeSessionId)
    .single();

  if (error) {
    if (error.code === 'PGRST116') return null; // not found
    console.error('Failed to get order:', error);
    return null;
  }

  return data as Order;
}

/**
 * Get order by ID.
 */
export async function getOrderById(id: string): Promise<Order | null> {
  const db = getClient();
  const { data, error } = await db
    .from('orders')
    .select()
    .eq('id', id)
    .single();

  if (error) {
    if (error.code === 'PGRST116') return null;
    console.error('Failed to get order:', error);
    return null;
  }

  return data as Order;
}
