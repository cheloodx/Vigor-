// ============================================================================
// Airalo Partner API Service
// ============================================================================
// Single eSIM provider for MVP. Handles:
// - OAuth token management
// - Package listing (Europa + Americas)
// - Order creation (eSIM provisioning)
// - QR code retrieval
//
// Docs: https://developers.partners.airalo.com
// ============================================================================

import fetch from 'node-fetch';
import { AiraloTokenResponse, AiraloOrderResponse } from '../types';

const AIRALO_API_URL = process.env.AIRALO_API_URL || 'https://sandbox-partners-api.airalo.com/v2';
const AIRALO_CLIENT_ID = process.env.AIRALO_CLIENT_ID;
const AIRALO_CLIENT_SECRET = process.env.AIRALO_CLIENT_SECRET;

// Token cache
let cachedToken: string | null = null;
let tokenExpiresAt = 0;

/**
 * Check if Airalo credentials are configured
 */
export function hasAiraloCredentials(): boolean {
  return !!(AIRALO_CLIENT_ID && AIRALO_CLIENT_SECRET);
}

/**
 * Get a valid OAuth token (cached, auto-refreshes)
 */
async function getToken(): Promise<string> {
  if (cachedToken && Date.now() < tokenExpiresAt) {
    return cachedToken;
  }

  if (!AIRALO_CLIENT_ID || !AIRALO_CLIENT_SECRET) {
    throw new Error('Airalo credentials not configured');
  }

  const response = await fetch(`${AIRALO_API_URL}/token`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: AIRALO_CLIENT_ID,
      client_secret: AIRALO_CLIENT_SECRET,
      grant_type: 'client_credentials',
    }).toString(),
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`Airalo token error (${response.status}): ${text}`);
  }

  const json = (await response.json()) as AiraloTokenResponse;
  cachedToken = json.data.access_token;
  // Expire 5 min early to be safe
  tokenExpiresAt = Date.now() + (json.data.expires_in - 300) * 1000;

  return cachedToken;
}

/**
 * Authenticated fetch to Airalo API
 */
async function airaloFetch(path: string, options: { method?: string; body?: string } = {}): Promise<unknown> {
  const token = await getToken();

  const response = await fetch(`${AIRALO_API_URL}${path}`, {
    method: options.method || 'GET',
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json',
      ...(options.body ? { 'Content-Type': 'application/json' } : {}),
    },
    body: options.body,
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`Airalo API error (${response.status}): ${text}`);
  }

  return response.json();
}

/**
 * List available eSIM packages from Airalo for a specific country
 */
export async function getAiraloPackages(countryCode: string): Promise<unknown> {
  return airaloFetch(`/packages?filter[country]=${countryCode.toLowerCase()}`);
}

/**
 * Create an eSIM order on Airalo
 * Returns the order with QR code and activation details
 */
export async function createAiraloOrder(packageId: string, quantity: number = 1): Promise<AiraloOrderResponse> {
  const result = await airaloFetch('/orders', {
    method: 'POST',
    body: JSON.stringify({
      package_id: packageId,
      quantity,
      type: 'sim',
      description: 'SatConnect eSIM order',
    }),
  });

  return result as AiraloOrderResponse;
}

/**
 * Get eSIM usage/status from Airalo
 */
export async function getAiraloEsimStatus(iccid: string): Promise<unknown> {
  return airaloFetch(`/sims/${iccid}/usage`);
}
