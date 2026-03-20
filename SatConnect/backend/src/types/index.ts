// ============================================================================
// SatConnect MVP - TypeScript Types
// ============================================================================

// --- Database row types (match SQL schema) ---

export interface User {
  id: string;
  email: string;
  full_name: string | null;
  apple_user_id: string | null;
  avatar_url: string | null;
  phone: string | null;
  country_code: string;
  created_at: string;
  updated_at: string;
}

export interface Plan {
  id: string;
  name: string;
  slug: string;
  country_code: string;
  country_name: string;
  region: string;
  data_limit_mb: number;
  data_label: string;
  valid_days: number;
  price: number;
  currency: string;
  is_popular: boolean;
  is_active: boolean;
  apple_product_id: string | null;
  created_at: string;
  updated_at: string;
}

export type SubscriptionStatus = 'active' | 'expired' | 'cancelled' | 'pending' | 'trial';

export interface Subscription {
  id: string;
  user_id: string;
  plan_type: string;
  status: SubscriptionStatus;
  apple_transaction_id: string | null;
  apple_product_id: string | null;
  apple_receipt_data: string | null;
  starts_at: string | null;
  expires_at: string | null;
  cancelled_at: string | null;
  created_at: string;
  updated_at: string;
}

export type OrderStatus = 'pending' | 'processing' | 'completed' | 'failed' | 'refunded';

export interface Order {
  id: string;
  user_id: string;
  plan_id: string;
  status: OrderStatus;
  airalo_order_id: string | null;
  apple_transaction_id: string | null;
  price_paid: number;
  currency: string;
  error_message: string | null;
  created_at: string;
  updated_at: string;
}

export type EsimStatus = 'pending' | 'active' | 'expired' | 'deactivated';

export interface UserEsim {
  id: string;
  user_id: string;
  order_id: string;
  iccid: string | null;
  activation_code: string | null;
  qr_code_url: string | null;
  qr_code_data: string | null;
  country_code: string;
  country_name: string;
  data_limit_mb: number;
  data_used_mb: number;
  data_label: string;
  valid_days: number;
  status: EsimStatus;
  activated_at: string | null;
  expires_at: string | null;
  airalo_esim_id: string | null;
  created_at: string;
  updated_at: string;
}

// --- API request/response types ---

export interface OrderEsimRequest {
  plan_id: string;
  apple_transaction_id?: string;
}

export interface PlansQuery {
  country_code?: string;
  region?: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

// --- Airalo API types ---

export interface AiraloTokenResponse {
  data: {
    access_token: string;
    token_type: string;
    expires_in: number;
  };
}

export interface AiraloPackage {
  id: number;
  slug: string;
  title: string;
  data: string;
  validity: number;
  price: number;
  net_price: number;
  amount: number;
  day: number;
  is_unlimited: boolean;
  operator: {
    id: number;
    title: string;
    countries: Array<{
      id: number;
      slug: string;
      title: string;
      country_code: string;
    }>;
  };
}

export interface AiraloOrderResponse {
  data: {
    id: number;
    code: string;
    package_id: string;
    quantity: number;
    type: string;
    description: string;
    esim_type: string;
    validity: number;
    package: string;
    data: string;
    price: number;
    created_at: string;
    sims: Array<{
      id: number;
      iccid: string;
      lpa: string;
      qrcode: string;
      qrcode_url: string;
      direct_apple_installation_url: string;
      confirmation_code: string;
      apn_type: string;
      apn_value: string;
    }>;
  };
}
