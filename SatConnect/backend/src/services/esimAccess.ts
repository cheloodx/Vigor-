// ============================================================================
// eSIM Access Partner API Service
// ============================================================================
// Replaces Airalo. Uses eSIM Access (https://docs.esimaccess.com) for:
// - Package listing by country/region
// - eSIM profile ordering
// - Profile status queries
// - Balance checks
//
// Auth: RT-AccessCode header (simple key auth)
// Base URL: https://api.esimaccess.com/api/v1/open
// ============================================================================

import fetch from 'node-fetch';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface EsimAccessPackage {
  packageCode: string;
  slug: string;
  name: string;
  price: number;        // in thousandths of USD (e.g. 7000 = $7.00)
  currencyCode: string;
  volume: number;       // bytes
  duration: number;
  durationUnit: string;
  location: string;     // comma-separated country codes
  locationCode: string;
  description: string;
  activeType: number;   // 1=auto-activate on install, 2=activate on first data
  retailPrice: number;
  speed: string;
  supportTopUpType: number;
}

export interface EsimAccessProfile {
  esimTranNo: string;
  orderNo: string;
  transactionId: string;
  iccid: string;
  ac: string;            // activation code / SM-DP+ address
  packageCode: string;
  packageName: string;
  esimStatus: string;
  smdpStatus: string;
  orderUsage: number;
  expired: string;
  totalVolume: number;
  totalDuration: number;
  durationUnit: string;
  qrCodeUrl: string;
  appleInstallUrl: string;
}

export interface EsimAccessOrderResult {
  orderNo: string;
  transactionId: string;
}

interface PackageListResponse {
  success: boolean;
  errorCode: string | null;
  errorMsg: string | null;
  obj: {
    packageList: EsimAccessPackage[];
  } | null;
}

interface OrderResponse {
  success: boolean;
  errorCode: string | null;
  errorMsg: string | null;
  obj: {
    orderNo: string;
    transactionId: string;
  } | null;
}

interface QueryResponse {
  success: boolean;
  errorCode: string | null;
  errorMsg: string | null;
  obj: {
    esimList: EsimAccessProfile[];
  } | null;
}

interface BalanceResponse {
  success: boolean;
  errorCode: string | null;
  errorMsg: string | null;
  obj: {
    balance: number;
  } | null;
}

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------

const ESIM_ACCESS_API_URL = 'https://api.esimaccess.com/api/v1/open';

function getAccessCode(): string {
  const code = process.env.ESIM_ACCESS_CODE;
  if (!code) throw new Error('ESIM_ACCESS_CODE not configured');
  return code;
}

// ---------------------------------------------------------------------------
// Public helpers
// ---------------------------------------------------------------------------

export function hasEsimAccessCredentials(): boolean {
  return Boolean(process.env.ESIM_ACCESS_CODE);
}

/** Alias for compatibility with provisioning service */
export const isEsimAccessConfigured = hasEsimAccessCredentials;

// ---------------------------------------------------------------------------
// Core API call
// ---------------------------------------------------------------------------

async function esimAccessFetch<T>(path: string, body: Record<string, unknown> = {}): Promise<T> {
  const accessCode = getAccessCode();

  const response = await fetch(`${ESIM_ACCESS_API_URL}${path}`, {
    method: 'POST',
    headers: {
      'RT-AccessCode': accessCode,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`eSIM Access API error (${response.status}): ${text}`);
  }

  const json = await response.json() as T & { success: boolean; errorCode: string | null; errorMsg: string | null };

  if (!json.success) {
    throw new Error(`eSIM Access API error [${json.errorCode || 'UNKNOWN'}]: ${json.errorMsg || 'Unknown error'}`);
  }

  return json;
}

// ---------------------------------------------------------------------------
// Package listing
// ---------------------------------------------------------------------------

/**
 * Get all available packages, optionally filtered by country code.
 */
export async function getPackages(locationCode?: string): Promise<EsimAccessPackage[]> {
  const body: Record<string, unknown> = { type: 'BASE' };
  if (locationCode) {
    body.locationCode = locationCode;
  }

  const json = await esimAccessFetch<PackageListResponse>('/package/list', body);
  return json.obj?.packageList ?? [];
}

/**
 * Find the best matching eSIM Access package for a country and data amount.
 * Matches by country code and closest data volume.
 */
export async function findPackage(
  countryCode: string,
  dataLabel: string,
): Promise<{ packageCode: string; price: number; name: string } | null> {
  const packages = await getPackages(countryCode);

  if (packages.length === 0) return null;

  const targetBytes = parseDataLabelToBytes(dataLabel);
  let bestMatch: { packageCode: string; price: number; name: string } | null = null;
  let bestDiff = Infinity;

  for (const pkg of packages) {
    // Only match country-specific packages (not regional/global)
    const isCountrySpecific = pkg.locationCode.length === 2;
    if (!isCountrySpecific && pkg.locationCode.toUpperCase() !== countryCode.toUpperCase()) {
      continue;
    }

    // Apply same quality filters as storefront (plans.ts transformPackagesToPlans)
    if (pkg.duration <= 1) continue; // Skip daily packages
    if (pkg.name.includes('FUP') || pkg.name.includes('nonhkip')) continue; // Skip throttled/variant
    const volumeMB = Math.round(pkg.volume / (1024 * 1024));
    if (volumeMB < 500) continue; // Skip very small packages

    const diff = Math.abs(pkg.volume - targetBytes);
    if (diff < bestDiff) {
      bestDiff = diff;
      bestMatch = {
        packageCode: pkg.packageCode,
        price: pkg.price,
        name: pkg.name,
      };
    }
  }

  // Fallback: if no country-specific match, try any package that includes this country
  if (!bestMatch) {
    for (const pkg of packages) {
      // Same quality filters in fallback loop
      if (pkg.duration <= 1) continue;
      if (pkg.name.includes('FUP') || pkg.name.includes('nonhkip')) continue;
      const volumeMB = Math.round(pkg.volume / (1024 * 1024));
      if (volumeMB < 500) continue;

      const diff = Math.abs(pkg.volume - targetBytes);
      if (diff < bestDiff) {
        bestDiff = diff;
        bestMatch = {
          packageCode: pkg.packageCode,
          price: pkg.price,
          name: pkg.name,
        };
      }
    }
  }

  return bestMatch;
}

// ---------------------------------------------------------------------------
// Ordering
// ---------------------------------------------------------------------------

/**
 * Order an eSIM profile from eSIM Access.
 * Returns the orderNo which is used to query the profile status.
 */
export async function orderEsim(
  packageCode: string,
  price: number,
  transactionId?: string,
): Promise<EsimAccessOrderResult> {
  const txnId = transactionId || `SC-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;

  const json = await esimAccessFetch<OrderResponse>('/esim/order', {
    transactionId: txnId,
    amount: price,
    packageInfoList: [{
      packageCode,
      count: 1,
      price,
    }],
  });

  if (!json.obj) {
    throw new Error('eSIM Access order returned no data');
  }

  return {
    orderNo: json.obj.orderNo,
    transactionId: json.obj.transactionId,
  };
}

// ---------------------------------------------------------------------------
// Profile queries
// ---------------------------------------------------------------------------

/**
 * Query allocated profiles by order number.
 * eSIM Access allocates profiles asynchronously (up to 30 seconds).
 * This polls until profiles are ready or timeout.
 */
export async function queryProfiles(
  orderNo: string,
  maxWaitMs: number = 60000,
): Promise<EsimAccessProfile[]> {
  const startTime = Date.now();
  const pollIntervalMs = 5000;

  while (Date.now() - startTime < maxWaitMs) {
    try {
      const json = await esimAccessFetch<QueryResponse>('/esim/query', {
        orderNo,
        iccid: '',
        pager: { pageNum: 1, pageSize: 20 },
      });

      const profiles = json.obj?.esimList ?? [];
      if (profiles.length > 0) {
        return profiles;
      }
    } catch (err) {
      // Error code 200010 means profiles not yet allocated — keep polling
      const msg = err instanceof Error ? err.message : '';
      if (msg.includes('200010') || msg.includes('not yet ready')) {
        // Expected — wait and retry
      } else {
        throw err;
      }
    }

    // Wait before next poll
    await new Promise(resolve => setTimeout(resolve, pollIntervalMs));
  }

  throw new Error(`eSIM profiles not allocated within ${maxWaitMs / 1000}s for order ${orderNo}`);
}

/**
 * Query profile by ICCID for status/usage checking.
 */
export async function queryProfileByIccid(iccid: string): Promise<EsimAccessProfile | null> {
  try {
    const json = await esimAccessFetch<QueryResponse>('/esim/query', {
      orderNo: '',
      iccid,
      pager: { pageNum: 1, pageSize: 1 },
    });

    const profiles = json.obj?.esimList ?? [];
    return profiles.length > 0 ? profiles[0] : null;
  } catch {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Balance
// ---------------------------------------------------------------------------

export async function getBalance(): Promise<number> {
  const json = await esimAccessFetch<BalanceResponse>('/balance/query', {});
  return json.obj?.balance ?? 0;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function parseDataLabelToBytes(label: string): number {
  const num = parseFloat(label.replace(/[^0-9.]/g, ''));
  if (isNaN(num)) return 0;
  const lower = label.toLowerCase();
  if (lower.includes('gb')) return num * 1024 * 1024 * 1024;
  if (lower.includes('mb')) return num * 1024 * 1024;
  return num;
}
