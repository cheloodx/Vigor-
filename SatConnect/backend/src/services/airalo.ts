/**
 * Airalo Partner API Service
 *
 * Handles authentication and eSIM ordering via Airalo's Partner API.
 * Docs: https://developers.partners.airalo.com
 */

// ---------------------------------------------------------------------------
// Types
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

interface AiraloTokenResponse {
  data: {
    access_token: string;
    expires_in: number;
    token_type: string;
  };
}

interface AiraloOrderResponse {
  data: {
    id: number;
    code: string;
    package_id: string;
    quantity: string;
    price: number;
    currency: string;
    data: string;
    validity: number;
    sims: AiraloSim[];
  };
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

// ---------------------------------------------------------------------------
// Token cache (in-memory)
// ---------------------------------------------------------------------------

let cachedToken: string | null = null;
let tokenExpiresAt = 0;

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

const getBaseUrl = () => process.env.AIRALO_API_URL || 'https://sandbox-partners-api.airalo.com/v2';
const getClientId = () => process.env.AIRALO_CLIENT_ID || '';
const getClientSecret = () => process.env.AIRALO_CLIENT_SECRET || '';

export function isAiraloConfigured(): boolean {
  return Boolean(getClientId() && getClientSecret());
}

/**
 * Get an OAuth2 access token from Airalo.
 * Caches the token in memory until it expires.
 */
async function getToken(): Promise<string> {
  if (cachedToken && Date.now() < tokenExpiresAt) {
    return cachedToken;
  }

  const clientId = getClientId();
  const clientSecret = getClientSecret();

  if (!clientId || !clientSecret) {
    throw new Error('Airalo credentials not configured (AIRALO_CLIENT_ID / AIRALO_CLIENT_SECRET)');
  }

  const form = new URLSearchParams();
  form.append('client_id', clientId);
  form.append('client_secret', clientSecret);
  form.append('grant_type', 'client_credentials');

  const res = await fetch(`${getBaseUrl()}/token`, {
    method: 'POST',
    headers: { Accept: 'application/json' },
    body: form,
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Airalo auth failed (${res.status}): ${text}`);
  }

  const json = (await res.json()) as AiraloTokenResponse;
  cachedToken = json.data.access_token;
  // Expire 60s early to avoid race conditions
  tokenExpiresAt = Date.now() + json.data.expires_in * 1000 - 60_000;
  return cachedToken;
}

/**
 * Make an authenticated request to the Airalo API.
 */
async function airaloFetch<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = await getToken();

  const res = await fetch(`${getBaseUrl()}${path}`, {
    ...options,
    headers: {
      Accept: 'application/json',
      Authorization: `Bearer ${token}`,
      ...(options.headers ?? {}),
    },
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Airalo API error (${res.status}): ${text}`);
  }

  return (await res.json()) as T;
}

/**
 * Find the best matching Airalo package for a given country and data amount.
 */
export async function findPackage(countryCode: string, dataLabel: string): Promise<{ packageId: string; netPrice: number } | null> {
  const json = await airaloFetch<AiraloPackagesResponse>(
    `/packages?filter[country]=${encodeURIComponent(countryCode)}&limit=20`,
  );

  if (!json?.data) return null;

  // Parse target data amount from label (e.g. "10 GB" -> 10240 MB)
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
 * Order an eSIM from Airalo.
 * Returns order details including SIM ICCID, QR code, and installation URLs.
 */
export async function orderESIM(packageId: string, quantity: number = 1): Promise<AiraloOrderResult> {
  const form = new URLSearchParams();
  form.append('package_id', packageId);
  form.append('quantity', String(quantity));

  const json = await airaloFetch<AiraloOrderResponse>('/orders', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: form,
  });

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

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function parseDataLabel(label: string): number {
  const num = parseFloat(label.replace(/[^0-9.]/g, ''));
  if (isNaN(num)) return 0;
  const lower = label.toLowerCase();
  if (lower.includes('gb')) return num * 1024;
  if (lower.includes('mb')) return num;
  return num;
}
