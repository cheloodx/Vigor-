// ============================================================================
// Airalo Partner API Service
// ============================================================================
// Single eSIM provider for MVP. Handles:
// - OAuth token management
// - Package listing (Europa + Americas)
// - Order creation (eSIM provisioning)
// - QR code retrieval
// - Package search by country/data
//
// Docs: https://developers.partners.airalo.com
// ============================================================================

import fetch from 'node-fetch';
import { AiraloTokenResponse, AiraloOrderResponse } from '../types';

// ---------------------------------------------------------------------------
// Types (for package search and Stripe provisioning pipeline)
// ---------------------------------------------------------------------------

export interface AiraloSim {
  id: number;
  iccid: string;
  lpa: string;
  matching_id: string;
  qrcode: string;
  qrcode_url: string;
  direct_apple_installation_url: string;
}

export interface AiraloOrderResult {
  orderId: number;
  orderCode: string;
  packageId: string;
  quantity: number;
  price: number;
  currency: string;
  data: string;
  validity: number;
  sims: AiraloSim[];
}

interface AiraloPackagesResponse {
  data: Array<{
    slug: string;
    country_code: string;
    title: string;
    operators: Array<{
      id: number;
      title: string;
      type: string;
      packages: Array<{
        id: string;
        slug: string;
        data: string;
        validity: number;
        price: number;
        net_price: number;
        currency: string;
        title: string;
      }>;
    }>;
  }>;
}

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

/** Alias for provisioning service compatibility */
export const isAiraloConfigured = hasAiraloCredentials;

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
  tokenExpiresAt = Date.now() + Math.max(json.data.expires_in - 300, 0) * 1000;

  return cachedToken;
}

/**
 * Authenticated fetch to Airalo API (retries once on 401 with a fresh token)
 */
async function airaloFetch(path: string, options: { method?: string; body?: string; headers?: Record<string, string> } = {}, _isRetry = false): Promise<unknown> {
  const token = await getToken();

  const response = await fetch(`${AIRALO_API_URL}${path}`, {
    method: options.method || 'GET',
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json',
      ...(options.headers ?? {}),
      ...(options.body && !options.headers?.['Content-Type'] ? { 'Content-Type': 'application/json' } : {}),
    },
    body: options.body,
  });

  if (!response.ok) {
    if (response.status === 401) {
      cachedToken = null;
      tokenExpiresAt = 0;
      // Retry once with a fresh token
      if (!_isRetry) {
        return airaloFetch(path, options, true);
      }
    }
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
 * Create an eSIM order on Airalo (used by auth-based orders route)
 */
export async function createAiraloOrder(packageId: string, quantity: number = 1): Promise<AiraloOrderResponse> {
  const form = new URLSearchParams();
  form.append('package_id', packageId);
  form.append('quantity', String(quantity));
  form.append('type', 'sim');
  form.append('description', 'SatConnect eSIM order');

  const result = await airaloFetch('/orders', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: form.toString(),
  });

  return result as AiraloOrderResponse;
}

/**
 * Get eSIM usage/status from Airalo
 */
export async function getAiraloEsimStatus(iccid: string): Promise<unknown> {
  return airaloFetch(`/sims/${iccid}/usage`);
}

// ---------------------------------------------------------------------------
// Stripe provisioning pipeline functions
// ---------------------------------------------------------------------------

/**
 * Find the best matching Airalo package for a given country and data amount.
 */
export async function findPackage(countryCode: string, dataLabel: string): Promise<{ packageId: string; netPrice: number } | null> {
  const json = await airaloFetch(`/packages?filter[country]=${encodeURIComponent(countryCode)}&limit=20`) as AiraloPackagesResponse;

  if (!json?.data) return null;

  const targetMB = parseDataLabel(dataLabel);
  let bestMatch: { packageId: string; netPrice: number } | null = null;
  let bestDiff = Infinity;

  for (const country of json.data) {
    for (const op of country.operators) {
      for (const pkg of op.packages ?? []) {
        const pkgMB = parseDataLabel(pkg.data);
        const diff = Math.abs(pkgMB - targetMB);
        if (diff < bestDiff) {
          bestDiff = diff;
          bestMatch = { packageId: pkg.id, netPrice: pkg.net_price };
        }
      }
    }
  }

  return bestMatch;
}

/**
 * Order an eSIM from Airalo (used by Stripe provisioning pipeline).
 */
export async function orderESIM(packageId: string, quantity: number = 1): Promise<AiraloOrderResult> {
  const form = new URLSearchParams();
  form.append('package_id', packageId);
  form.append('quantity', String(quantity));

  const json = await airaloFetch('/orders', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: form.toString(),
  }) as { data: { id: number; code: string; package_id: string; quantity: string; price: number; currency: string; data: string; validity: number; sims: AiraloSim[] } };

  return {
    orderId: json.data.id,
    orderCode: json.data.code,
    packageId: json.data.package_id,
    quantity: Number(json.data.quantity),
    price: json.data.price,
    currency: json.data.currency,
    data: json.data.data,
    validity: json.data.validity,
    sims: json.data.sims,
  };
}

function parseDataLabel(label: string): number {
  const num = parseFloat(label.replace(/[^0-9.]/g, ''));
  if (isNaN(num)) return 0;
  const lower = label.toLowerCase();
  if (lower.includes('gb')) return num * 1024;
  if (lower.includes('mb')) return num;
  return num;
}
