/**
 * Stripe Payment Service
 *
 * Handles eSIM plan payments via Stripe Checkout.
 * Flow: User selects plan → Create checkout session → Redirect to Stripe → Payment confirmed → Provision eSIM
 */

import { Platform, Linking } from 'react-native';
import { runtimeConfig } from './runtimeConfig';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface CheckoutRequest {
  planId: string;
  planName: string;
  countryName: string;
  countryFlag: string;
  dataLabel: string;
  price: number;
  currency: string;
  validDays: number;
}

export interface CheckoutResponse {
  sessionId: string;
  url: string;
}

export interface PaymentStatus {
  id: string;
  status: 'paid' | 'unpaid' | 'no_payment_required';
  planId: string;
  countryName: string;
  dataLabel: string;
  amountTotal: number;
  currency: string;
}

// ---------------------------------------------------------------------------
// Configuration
// ---------------------------------------------------------------------------

function getBackendUrl(): string {
  // Use runtime config or fallback to localhost
  return runtimeConfig.backendUrl || 'http://localhost:3001';
}

// ---------------------------------------------------------------------------
// API calls
// ---------------------------------------------------------------------------

/**
 * Create a Stripe Checkout Session for an eSIM plan purchase.
 * Returns the checkout URL to redirect the user to.
 */
export async function createCheckoutSession(plan: CheckoutRequest): Promise<CheckoutResponse> {
  const backendUrl = getBackendUrl();
  // Only send planId — backend does server-side price lookup to prevent manipulation
  const response = await fetch(`${backendUrl}/api/stripe/create-checkout`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ planId: plan.planId }),
  });

  if (!response.ok) {
    const error = await response.json().catch(() => ({ error: 'Network error' }));
    throw new Error(error.error || 'Failed to create checkout session');
  }

  return response.json();
}

/**
 * Open Stripe Checkout in the browser.
 * On web: redirects current window.
 * On native: opens in system browser via Linking.
 */
export async function openCheckout(url: string): Promise<void> {
  if (Platform.OS === 'web') {
    // Open in new tab so the app state (sessionId, paymentSent) is preserved
    // for the "Am platit - Verifica" verification step when user returns.
    window.open(url, '_blank');
  } else {
    const supported = await Linking.canOpenURL(url);
    if (supported) {
      await Linking.openURL(url);
    } else {
      throw new Error('Cannot open payment URL');
    }
  }
}

/**
 * Check payment status for a completed checkout session.
 */
export async function getPaymentStatus(sessionId: string): Promise<PaymentStatus> {
  const backendUrl = getBackendUrl();
  const response = await fetch(`${backendUrl}/api/stripe/session/${sessionId}`);

  if (!response.ok) {
    const error = await response.json().catch(() => ({ error: 'Network error' }));
    throw new Error(error.error || 'Failed to check payment status');
  }

  return response.json();
}

// ---------------------------------------------------------------------------
// Provisioning
// ---------------------------------------------------------------------------

export interface ProvisionedOrder {
  id: string;
  status: string;
  planId: string;
  countryName: string;
  dataLabel: string;
  iccid: string;
  qrcodeUrl: string;
  lpa: string;
  matchingId: string;
  directAppleInstallUrl: string;
}

/**
 * Provision an eSIM after payment is confirmed.
 * Calls the backend which orchestrates Airalo ordering + DB storage.
 */
export async function provisionAfterPayment(sessionId: string): Promise<ProvisionedOrder> {
  const backendUrl = getBackendUrl();
  const response = await fetch(`${backendUrl}/api/orders/provision`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ sessionId }),
  });

  if (!response.ok) {
    const error = await response.json().catch(() => ({ error: 'Network error' }));
    throw new Error(error.error || 'Failed to provision eSIM');
  }

  const data = await response.json();
  return data.order as ProvisionedOrder;
}
