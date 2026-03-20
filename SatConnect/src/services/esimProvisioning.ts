/**
 * eSIM Provisioning Service
 *
 * Connects to the Airalo Partner API when credentials are configured.
 * Falls back to local mock data otherwise.
 *
 * Airalo docs: https://developers.partners.airalo.com
 */

import AsyncStorage from '@react-native-async-storage/async-storage';

import { hasAiraloConfig, runtimeConfig } from './runtimeConfig';

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface ESIMProfile {
  id: string;
  iccid: string;
  activationCode: string;
  carrier: string;
  region: string;
  countries: string[];
  dataLimitMB: number;
  dataUsedMB: number;
  validFrom: string;
  validUntil: string;
  status: 'pending' | 'active' | 'expired' | 'cancelled';
  qrCodeUrl?: string;
  directAppleInstallUrl?: string;
}

export interface ESIMPlan {
  id: string;
  name: string;
  region: string;
  countries: number;
  dataLimitMB: number;
  validDays: number;
  price: number;
  currency: string;
  provider: string;
}

export interface ProvisioningResult {
  success: boolean;
  profile?: ESIMProfile;
  error?: string;
}

// ---------------------------------------------------------------------------
// Airalo API helpers
// ---------------------------------------------------------------------------

const AIRALO_TOKEN_KEY = '@satconnect_airalo_token';
const AIRALO_TOKEN_EXPIRES_KEY = '@satconnect_airalo_token_exp';
const PROFILES_KEY = '@satconnect_esim_profiles';

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function parseDataToMB(dataStr: string): number {
  if (!dataStr) return 0;
  const lower = dataStr.toLowerCase().replace(/\s/g, '');
  const num = parseFloat(lower);
  if (isNaN(num)) return 0;
  if (lower.includes('gb')) return num * 1024;
  if (lower.includes('mb')) return num;
  return num;
}

async function getAiraloToken(): Promise<string | null> {
  if (!hasAiraloConfig) return null;

  const cached = await AsyncStorage.getItem(AIRALO_TOKEN_KEY);
  const expiresStr = await AsyncStorage.getItem(AIRALO_TOKEN_EXPIRES_KEY);
  if (cached && expiresStr && Date.now() < Number(expiresStr)) {
    return cached;
  }

  try {
    const form = new FormData();
    form.append('client_id', runtimeConfig.airaloClientId!);
    form.append('client_secret', runtimeConfig.airaloClientSecret!);
    form.append('grant_type', 'client_credentials');

    const res = await fetch(`${runtimeConfig.airaloBaseUrl}/v2/token`, {
      method: 'POST',
      headers: { Accept: 'application/json' },
      body: form,
    });

    if (!res.ok) return null;

    const json = (await res.json()) as {
      data: { access_token: string; expires_in: number; token_type: string };
    };

    const token = json.data.access_token;
    const expiresAt = Date.now() + json.data.expires_in * 1000 - 60_000;
    await AsyncStorage.setItem(AIRALO_TOKEN_KEY, token);
    await AsyncStorage.setItem(AIRALO_TOKEN_EXPIRES_KEY, String(expiresAt));
    return token;
  } catch {
    return null;
  }
}

async function airaloFetch<T>(path: string, options: RequestInit = {}): Promise<T | null> {
  const token = await getAiraloToken();
  if (!token) return null;

  try {
    const res = await fetch(`${runtimeConfig.airaloBaseUrl}${path}`, {
      ...options,
      headers: {
        Accept: 'application/json',
        Authorization: `Bearer ${token}`,
        ...(options.headers ?? {}),
      },
    });

    if (!res.ok) return null;
    return (await res.json()) as T;
  } catch {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Mock plans (used when Airalo credentials are not configured)
// ---------------------------------------------------------------------------

const MOCK_PLANS: ESIMPlan[] = [
  {
    id: 'plan-eu-5gb',
    name: 'Europa 5GB',
    region: 'Europa',
    countries: 30,
    dataLimitMB: 5120,
    validDays: 30,
    price: 2.99,
    currency: 'EUR',
    provider: 'SatConnect EU',
  },
  {
    id: 'plan-eu-50gb',
    name: 'Europa 50GB',
    region: 'Europa',
    countries: 30,
    dataLimitMB: 51200,
    validDays: 30,
    price: 4.99,
    currency: 'EUR',
    provider: 'SatConnect EU',
  },
  {
    id: 'plan-global-10gb',
    name: 'Global 10GB',
    region: 'Global',
    countries: 175,
    dataLimitMB: 10240,
    validDays: 30,
    price: 7.99,
    currency: 'EUR',
    provider: 'SatConnect Global',
  },
  {
    id: 'plan-global-100gb',
    name: 'Global 100GB',
    region: 'Global',
    countries: 175,
    dataLimitMB: 102400,
    validDays: 30,
    price: 12.99,
    currency: 'EUR',
    provider: 'SatConnect Global',
  },
  {
    id: 'plan-americas-30gb',
    name: 'Americas & Asia 30GB',
    region: 'Americas & Asia',
    countries: 100,
    dataLimitMB: 30720,
    validDays: 30,
    price: 7.99,
    currency: 'EUR',
    provider: 'SatConnect World',
  },
];

// ---------------------------------------------------------------------------
// Airalo response types
// ---------------------------------------------------------------------------

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
      coverages: Array<{ name: string; code: string }>;
    }>;
  }>;
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
    sims: Array<{
      id: number;
      iccid: string;
      lpa: string;
      matching_id: string;
      qrcode: string;
      qrcode_url: string;
      direct_apple_installation_url: string;
    }>;
  };
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

class ESIMProvisioningService {
  private profiles: ESIMProfile[] = [];
  private initialized = false;

  async initialize(): Promise<void> {
    if (this.initialized) return;

    const stored = await AsyncStorage.getItem(PROFILES_KEY);
    if (stored) {
      this.profiles = JSON.parse(stored) as ESIMProfile[];
    }

    this.initialized = true;
  }

  async getAvailablePlans(region?: string): Promise<ESIMPlan[]> {
    if (hasAiraloConfig) {
      const countryFilter = region
        ? `&filter[country]=${encodeURIComponent(region)}`
        : '';
      const json = await airaloFetch<AiraloPackagesResponse>(
        `/v2/packages?limit=50${countryFilter}`,
      );

      if (json?.data) {
        const plans: ESIMPlan[] = [];
        for (const country of json.data) {
          for (const op of country.operators) {
            for (const pkg of op.packages ?? []) {
              const dataMB = parseDataToMB(pkg.data);
              plans.push({
                id: pkg.slug ?? pkg.id,
                name: `${country.title} ${pkg.data}`,
                region: country.title,
                countries: op.coverages?.length ?? 1,
                dataLimitMB: dataMB,
                validDays: pkg.validity,
                price: pkg.price,
                currency: pkg.currency ?? 'USD',
                provider: `Airalo \u2013 ${op.title}`,
              });
            }
          }
        }
        if (plans.length > 0) return plans;
      }
    }

    // Fallback to mock plans
    await delay(800);
    if (region) {
      return MOCK_PLANS.filter((p) =>
        p.region.toLowerCase().includes(region.toLowerCase()),
      );
    }
    return MOCK_PLANS;
  }

  async provisionESIM(planId: string): Promise<ProvisioningResult> {
    if (hasAiraloConfig) {
      const form = new FormData();
      form.append('package_id', planId);
      form.append('quantity', '1');
      form.append('type', 'sim');
      form.append('description', `SatConnect order ${Date.now()}`);

      const json = await airaloFetch<AiraloOrderResponse>('/v2/orders', {
        method: 'POST',
        body: form,
      });

      if (json?.data?.sims?.[0]) {
        const sim = json.data.sims[0];
        const profile: ESIMProfile = {
          id: `airalo_${sim.id}`,
          iccid: sim.iccid,
          activationCode: sim.lpa ?? sim.matching_id ?? '',
          carrier: `Airalo (${json.data.package_id})`,
          region: json.data.package_id,
          countries: [],
          dataLimitMB: parseDataToMB(json.data.data),
          dataUsedMB: 0,
          validFrom: new Date().toISOString(),
          validUntil: new Date(
            Date.now() + json.data.validity * 24 * 60 * 60 * 1000,
          ).toISOString(),
          status: 'pending',
          qrCodeUrl: sim.qrcode_url,
          directAppleInstallUrl: sim.direct_apple_installation_url,
        };

        this.profiles.push(profile);
        await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));
        return { success: true, profile };
      }
    }

    // Fallback mock provisioning
    await delay(3000);
    const plans = await this.getAvailablePlans();
    const plan = plans.find((p) => p.id === planId);
    if (!plan) {
      return { success: false, error: 'Planul selectat nu a fost g\u0103sit' };
    }

    const mockId = Date.now();
    const mockRandom = Math.random().toString(36).substring(2, 12).toUpperCase();
    const profile: ESIMProfile = {
      id: `esim_${mockId}`,
      iccid: `894010${mockId}`,
      activationCode: 'LPA:1$smdp.satconnect.app$' + mockRandom,
      carrier: plan.provider,
      region: plan.region,
      countries: Array.from({ length: plan.countries }, (_, i) => `Country ${i + 1}`),
      dataLimitMB: plan.dataLimitMB,
      dataUsedMB: 0,
      validFrom: new Date().toISOString(),
      validUntil: new Date(Date.now() + plan.validDays * 24 * 60 * 60 * 1000).toISOString(),
      status: 'pending',
      qrCodeUrl: `https://api.satconnect.app/esim/qr/${mockId}`,
    };

    this.profiles.push(profile);
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));
    return { success: true, profile };
  }

  async activateESIM(profileId: string): Promise<ProvisioningResult> {
    await delay(2000);

    const profile = this.profiles.find((p) => p.id === profileId);
    if (!profile) {
      return { success: false, error: 'Profilul eSIM nu a fost g\u0103sit' };
    }

    if (profile.status === 'active') {
      return { success: false, error: 'eSIM-ul este deja activ' };
    }

    profile.status = 'active';
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));
    return { success: true, profile };
  }

  getProfiles(): ESIMProfile[] {
    return [...this.profiles];
  }

  getActiveProfile(): ESIMProfile | null {
    return this.profiles.find((p) => p.status === 'active') ?? null;
  }

  async checkCompatibility(): Promise<{ compatible: boolean; reason?: string }> {
    return { compatible: true };
  }

  async deactivateESIM(profileId: string): Promise<ProvisioningResult> {
    const profile = this.profiles.find((p) => p.id === profileId);
    if (!profile) {
      return { success: false, error: 'Profilul eSIM nu a fost g\u0103sit' };
    }

    profile.status = 'cancelled';
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));
    return { success: true, profile };
  }

  isUsingRealProvider(): boolean {
    return hasAiraloConfig;
  }
}

export const esimProvisioning = new ESIMProvisioningService();
