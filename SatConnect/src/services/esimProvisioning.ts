/**
 * eSIM Provisioning Service
 *
 * Country-based eSIM provisioning: each country gets its own eSIM plan.
 * Connects to the Airalo Partner API when credentials are configured.
 * Falls back to local mock data otherwise.
 *
 * UX: User sees only "Internet pentru [Tara] - activ in 2 minute"
 * Provider details are hidden from the user.
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

export interface ESIMCountry {
  code: string;
  name: string;
  flag: string;
  region: string;
  popular: boolean;
}

export interface ESIMCountryPlan {
  id: string;
  countryCode: string;
  countryName: string;
  countryFlag: string;
  dataLimitMB: number;
  dataLabel: string;
  validDays: number;
  price: number;
  currency: string;
  popular: boolean;
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
  activationTime?: string;
}

// ---------------------------------------------------------------------------
// Country database (50+ countries)
// ---------------------------------------------------------------------------

export const ESIM_COUNTRIES: ESIMCountry[] = [
  { code: 'RO', name: 'România', flag: '🇷🇴', region: 'Europa', popular: true },
  { code: 'FR', name: 'Franța', flag: '🇫🇷', region: 'Europa', popular: true },
  { code: 'DE', name: 'Germania', flag: '🇩🇪', region: 'Europa', popular: true },
  { code: 'IT', name: 'Italia', flag: '🇮🇹', region: 'Europa', popular: true },
  { code: 'ES', name: 'Spania', flag: '🇪🇸', region: 'Europa', popular: true },
  { code: 'GB', name: 'Marea Britanie', flag: '🇬🇧', region: 'Europa', popular: true },
  { code: 'NL', name: 'Olanda', flag: '🇳🇱', region: 'Europa', popular: false },
  { code: 'BE', name: 'Belgia', flag: '🇧🇪', region: 'Europa', popular: false },
  { code: 'AT', name: 'Austria', flag: '🇦🇹', region: 'Europa', popular: false },
  { code: 'CH', name: 'Elveția', flag: '🇨🇭', region: 'Europa', popular: false },
  { code: 'PT', name: 'Portugalia', flag: '🇵🇹', region: 'Europa', popular: false },
  { code: 'GR', name: 'Grecia', flag: '🇬🇷', region: 'Europa', popular: true },
  { code: 'PL', name: 'Polonia', flag: '🇵🇱', region: 'Europa', popular: false },
  { code: 'CZ', name: 'Cehia', flag: '🇨🇿', region: 'Europa', popular: false },
  { code: 'HU', name: 'Ungaria', flag: '🇭🇺', region: 'Europa', popular: false },
  { code: 'SE', name: 'Suedia', flag: '🇸🇪', region: 'Europa', popular: false },
  { code: 'NO', name: 'Norvegia', flag: '🇳🇴', region: 'Europa', popular: false },
  { code: 'DK', name: 'Danemarca', flag: '🇩🇰', region: 'Europa', popular: false },
  { code: 'FI', name: 'Finlanda', flag: '🇫🇮', region: 'Europa', popular: false },
  { code: 'IE', name: 'Irlanda', flag: '🇮🇪', region: 'Europa', popular: false },
  { code: 'HR', name: 'Croația', flag: '🇭🇷', region: 'Europa', popular: false },
  { code: 'BG', name: 'Bulgaria', flag: '🇧🇬', region: 'Europa', popular: false },
  { code: 'TR', name: 'Turcia', flag: '🇹🇷', region: 'Europa', popular: true },
  { code: 'JP', name: 'Japonia', flag: '🇯🇵', region: 'Asia', popular: true },
  { code: 'KR', name: 'Coreea de Sud', flag: '🇰🇷', region: 'Asia', popular: true },
  { code: 'TH', name: 'Thailanda', flag: '🇹🇭', region: 'Asia', popular: true },
  { code: 'VN', name: 'Vietnam', flag: '🇻🇳', region: 'Asia', popular: false },
  { code: 'ID', name: 'Indonezia', flag: '🇮🇩', region: 'Asia', popular: false },
  { code: 'MY', name: 'Malaezia', flag: '🇲🇾', region: 'Asia', popular: false },
  { code: 'SG', name: 'Singapore', flag: '🇸🇬', region: 'Asia', popular: false },
  { code: 'IN', name: 'India', flag: '🇮🇳', region: 'Asia', popular: true },
  { code: 'CN', name: 'China', flag: '🇨🇳', region: 'Asia', popular: true },
  { code: 'TW', name: 'Taiwan', flag: '🇹🇼', region: 'Asia', popular: false },
  { code: 'PH', name: 'Filipine', flag: '🇵🇭', region: 'Asia', popular: false },
  { code: 'HK', name: 'Hong Kong', flag: '🇭🇰', region: 'Asia', popular: false },
  { code: 'US', name: 'SUA', flag: '🇺🇸', region: 'Americas', popular: true },
  { code: 'CA', name: 'Canada', flag: '🇨🇦', region: 'Americas', popular: true },
  { code: 'MX', name: 'Mexic', flag: '🇲🇽', region: 'Americas', popular: true },
  { code: 'BR', name: 'Brazilia', flag: '🇧🇷', region: 'Americas', popular: true },
  { code: 'AR', name: 'Argentina', flag: '🇦🇷', region: 'Americas', popular: false },
  { code: 'CO', name: 'Columbia', flag: '🇨🇴', region: 'Americas', popular: false },
  { code: 'CL', name: 'Chile', flag: '🇨🇱', region: 'Americas', popular: false },
  { code: 'PE', name: 'Peru', flag: '🇵🇪', region: 'Americas', popular: false },
  { code: 'ZA', name: 'Africa de Sud', flag: '🇿🇦', region: 'Africa', popular: false },
  { code: 'EG', name: 'Egipt', flag: '🇪🇬', region: 'Africa', popular: true },
  { code: 'MA', name: 'Maroc', flag: '🇲🇦', region: 'Africa', popular: false },
  { code: 'AE', name: 'Emiratele Arabe', flag: '🇦🇪', region: 'Orientul Mijlociu', popular: true },
  { code: 'IL', name: 'Israel', flag: '🇮🇱', region: 'Orientul Mijlociu', popular: false },
  { code: 'AU', name: 'Australia', flag: '🇦🇺', region: 'Oceania', popular: true },
  { code: 'NZ', name: 'Noua Zeelandă', flag: '🇳🇿', region: 'Oceania', popular: false },
  { code: 'EU', name: 'Europa (30+ țări)', flag: '🇪🇺', region: 'Regional', popular: true },
  { code: 'ASIA', name: 'Asia Pacific', flag: '🌏', region: 'Regional', popular: true },
  { code: 'GLOBAL', name: 'Global (175 țări)', flag: '🌍', region: 'Regional', popular: true },
];

// ---------------------------------------------------------------------------
// Per-country plans with correct market pricing
// ---------------------------------------------------------------------------

function makePlan(id: string, cc: string, cn: string, cf: string, mb: number, dl: string, vd: number, pr: number, pop: boolean): ESIMCountryPlan {
  return { id, countryCode: cc, countryName: cn, countryFlag: cf, dataLimitMB: mb, dataLabel: dl, validDays: vd, price: pr, currency: 'EUR', popular: pop };
}

const COUNTRY_PLANS: Record<string, ESIMCountryPlan[]> = {
  JP: [
    makePlan('jp-1gb', 'JP', 'Japonia', '🇯🇵', 1024, '1 GB', 7, 2.99, false),
    makePlan('jp-3gb', 'JP', 'Japonia', '🇯🇵', 3072, '3 GB', 15, 5.99, false),
    makePlan('jp-5gb', 'JP', 'Japonia', '🇯🇵', 5120, '5 GB', 30, 8.99, true),
    makePlan('jp-10gb', 'JP', 'Japonia', '🇯🇵', 10240, '10 GB', 30, 14.99, false),
    makePlan('jp-20gb', 'JP', 'Japonia', '🇯🇵', 20480, '20 GB', 30, 24.99, false),
  ],
  US: [
    makePlan('us-1gb', 'US', 'SUA', '🇺🇸', 1024, '1 GB', 7, 3.99, false),
    makePlan('us-3gb', 'US', 'SUA', '🇺🇸', 3072, '3 GB', 15, 7.99, false),
    makePlan('us-5gb', 'US', 'SUA', '🇺🇸', 5120, '5 GB', 30, 12.99, true),
    makePlan('us-10gb', 'US', 'SUA', '🇺🇸', 10240, '10 GB', 30, 19.99, false),
    makePlan('us-20gb', 'US', 'SUA', '🇺🇸', 20480, '20 GB', 30, 29.99, false),
  ],
  FR: [
    makePlan('fr-1gb', 'FR', 'Franța', '🇫🇷', 1024, '1 GB', 7, 2.49, false),
    makePlan('fr-3gb', 'FR', 'Franța', '🇫🇷', 3072, '3 GB', 15, 4.99, false),
    makePlan('fr-5gb', 'FR', 'Franța', '🇫🇷', 5120, '5 GB', 30, 7.99, true),
    makePlan('fr-10gb', 'FR', 'Franța', '🇫🇷', 10240, '10 GB', 30, 12.99, false),
  ],
  RO: [
    makePlan('ro-1gb', 'RO', 'România', '🇷🇴', 1024, '1 GB', 7, 1.99, false),
    makePlan('ro-5gb', 'RO', 'România', '🇷🇴', 5120, '5 GB', 30, 4.99, true),
    makePlan('ro-10gb', 'RO', 'România', '🇷🇴', 10240, '10 GB', 30, 7.99, false),
    makePlan('ro-20gb', 'RO', 'România', '🇷🇴', 20480, '20 GB', 30, 12.99, false),
  ],
  DE: [
    makePlan('de-1gb', 'DE', 'Germania', '🇩🇪', 1024, '1 GB', 7, 2.99, false),
    makePlan('de-5gb', 'DE', 'Germania', '🇩🇪', 5120, '5 GB', 30, 8.99, true),
    makePlan('de-10gb', 'DE', 'Germania', '🇩🇪', 10240, '10 GB', 30, 14.99, false),
  ],
  IT: [
    makePlan('it-1gb', 'IT', 'Italia', '🇮🇹', 1024, '1 GB', 7, 2.49, false),
    makePlan('it-5gb', 'IT', 'Italia', '🇮🇹', 5120, '5 GB', 30, 7.99, true),
    makePlan('it-10gb', 'IT', 'Italia', '🇮🇹', 10240, '10 GB', 30, 12.99, false),
  ],
  ES: [
    makePlan('es-1gb', 'ES', 'Spania', '🇪🇸', 1024, '1 GB', 7, 2.49, false),
    makePlan('es-5gb', 'ES', 'Spania', '🇪🇸', 5120, '5 GB', 30, 7.99, true),
    makePlan('es-10gb', 'ES', 'Spania', '🇪🇸', 10240, '10 GB', 30, 12.99, false),
  ],
  GB: [
    makePlan('gb-1gb', 'GB', 'Marea Britanie', '🇬🇧', 1024, '1 GB', 7, 2.99, false),
    makePlan('gb-5gb', 'GB', 'Marea Britanie', '🇬🇧', 5120, '5 GB', 30, 9.99, true),
    makePlan('gb-10gb', 'GB', 'Marea Britanie', '🇬🇧', 10240, '10 GB', 30, 16.99, false),
  ],
  GR: [
    makePlan('gr-1gb', 'GR', 'Grecia', '🇬🇷', 1024, '1 GB', 7, 2.49, false),
    makePlan('gr-5gb', 'GR', 'Grecia', '🇬🇷', 5120, '5 GB', 30, 7.99, true),
    makePlan('gr-10gb', 'GR', 'Grecia', '🇬🇷', 10240, '10 GB', 30, 12.99, false),
  ],
  TR: [
    makePlan('tr-1gb', 'TR', 'Turcia', '🇹🇷', 1024, '1 GB', 7, 1.99, false),
    makePlan('tr-5gb', 'TR', 'Turcia', '🇹🇷', 5120, '5 GB', 30, 5.99, true),
    makePlan('tr-10gb', 'TR', 'Turcia', '🇹🇷', 10240, '10 GB', 30, 9.99, false),
  ],
  KR: [
    makePlan('kr-1gb', 'KR', 'Coreea de Sud', '🇰🇷', 1024, '1 GB', 7, 2.99, false),
    makePlan('kr-5gb', 'KR', 'Coreea de Sud', '🇰🇷', 5120, '5 GB', 30, 8.99, true),
    makePlan('kr-10gb', 'KR', 'Coreea de Sud', '🇰🇷', 10240, '10 GB', 30, 14.99, false),
  ],
  TH: [
    makePlan('th-1gb', 'TH', 'Thailanda', '🇹🇭', 1024, '1 GB', 7, 1.99, false),
    makePlan('th-5gb', 'TH', 'Thailanda', '🇹🇭', 5120, '5 GB', 30, 5.99, true),
    makePlan('th-10gb', 'TH', 'Thailanda', '🇹🇭', 10240, '10 GB', 30, 9.99, false),
  ],
  IN: [
    makePlan('in-1gb', 'IN', 'India', '🇮🇳', 1024, '1 GB', 7, 1.49, false),
    makePlan('in-5gb', 'IN', 'India', '🇮🇳', 5120, '5 GB', 30, 3.99, true),
    makePlan('in-10gb', 'IN', 'India', '🇮🇳', 10240, '10 GB', 30, 6.99, false),
  ],
  CN: [
    makePlan('cn-1gb', 'CN', 'China', '🇨🇳', 1024, '1 GB', 7, 3.49, false),
    makePlan('cn-5gb', 'CN', 'China', '🇨🇳', 5120, '5 GB', 30, 9.99, true),
    makePlan('cn-10gb', 'CN', 'China', '🇨🇳', 10240, '10 GB', 30, 16.99, false),
  ],
  CA: [
    makePlan('ca-1gb', 'CA', 'Canada', '🇨🇦', 1024, '1 GB', 7, 3.99, false),
    makePlan('ca-5gb', 'CA', 'Canada', '🇨🇦', 5120, '5 GB', 30, 12.99, true),
    makePlan('ca-10gb', 'CA', 'Canada', '🇨🇦', 10240, '10 GB', 30, 19.99, false),
  ],
  MX: [
    makePlan('mx-1gb', 'MX', 'Mexic', '🇲🇽', 1024, '1 GB', 7, 2.49, false),
    makePlan('mx-5gb', 'MX', 'Mexic', '🇲🇽', 5120, '5 GB', 30, 7.99, true),
    makePlan('mx-10gb', 'MX', 'Mexic', '🇲🇽', 10240, '10 GB', 30, 12.99, false),
  ],
  BR: [
    makePlan('br-1gb', 'BR', 'Brazilia', '🇧🇷', 1024, '1 GB', 7, 2.49, false),
    makePlan('br-5gb', 'BR', 'Brazilia', '🇧🇷', 5120, '5 GB', 30, 7.99, true),
    makePlan('br-10gb', 'BR', 'Brazilia', '🇧🇷', 10240, '10 GB', 30, 12.99, false),
  ],
  EG: [
    makePlan('eg-1gb', 'EG', 'Egipt', '🇪🇬', 1024, '1 GB', 7, 2.99, false),
    makePlan('eg-5gb', 'EG', 'Egipt', '🇪🇬', 5120, '5 GB', 30, 8.99, true),
    makePlan('eg-10gb', 'EG', 'Egipt', '🇪🇬', 10240, '10 GB', 30, 14.99, false),
  ],
  AE: [
    makePlan('ae-1gb', 'AE', 'Emiratele Arabe', '🇦🇪', 1024, '1 GB', 7, 3.49, false),
    makePlan('ae-5gb', 'AE', 'Emiratele Arabe', '🇦🇪', 5120, '5 GB', 30, 9.99, true),
    makePlan('ae-10gb', 'AE', 'Emiratele Arabe', '🇦🇪', 10240, '10 GB', 30, 16.99, false),
  ],
  AU: [
    makePlan('au-1gb', 'AU', 'Australia', '🇦🇺', 1024, '1 GB', 7, 3.49, false),
    makePlan('au-5gb', 'AU', 'Australia', '🇦🇺', 5120, '5 GB', 30, 9.99, true),
    makePlan('au-10gb', 'AU', 'Australia', '🇦🇺', 10240, '10 GB', 30, 16.99, false),
  ],
  EU: [
    makePlan('eu-1gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 1024, '1 GB', 7, 2.99, false),
    makePlan('eu-5gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 5120, '5 GB', 30, 7.99, false),
    makePlan('eu-10gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 10240, '10 GB', 30, 9.99, true),
    makePlan('eu-20gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 20480, '20 GB', 30, 16.99, false),
  ],
  ASIA: [
    makePlan('asia-1gb', 'ASIA', 'Asia Pacific', '🌏', 1024, '1 GB', 7, 2.99, false),
    makePlan('asia-5gb', 'ASIA', 'Asia Pacific', '🌏', 5120, '5 GB', 30, 8.99, true),
    makePlan('asia-10gb', 'ASIA', 'Asia Pacific', '🌏', 10240, '10 GB', 30, 14.99, false),
  ],
  GLOBAL: [
    makePlan('global-1gb', 'GLOBAL', 'Global (175 țări)', '🌍', 1024, '1 GB', 7, 4.99, false),
    makePlan('global-5gb', 'GLOBAL', 'Global (175 țări)', '🌍', 5120, '5 GB', 30, 12.99, true),
    makePlan('global-10gb', 'GLOBAL', 'Global (175 țări)', '🌍', 10240, '10 GB', 30, 19.99, false),
    makePlan('global-20gb', 'GLOBAL', 'Global (175 țări)', '🌍', 20480, '20 GB', 30, 29.99, false),
  ],
};

function generateDefaultPlans(country: ESIMCountry): ESIMCountryPlan[] {
  return [
    makePlan(`${country.code.toLowerCase()}-1gb`, country.code, country.name, country.flag, 1024, '1 GB', 7, 2.99, false),
    makePlan(`${country.code.toLowerCase()}-5gb`, country.code, country.name, country.flag, 5120, '5 GB', 30, 8.99, true),
    makePlan(`${country.code.toLowerCase()}-10gb`, country.code, country.name, country.flag, 10240, '10 GB', 30, 14.99, false),
  ];
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

  getCountries(): ESIMCountry[] {
    return ESIM_COUNTRIES;
  }

  getPopularCountries(): ESIMCountry[] {
    return ESIM_COUNTRIES.filter((c) => c.popular);
  }

  searchCountries(query: string): ESIMCountry[] {
    const lower = query.toLowerCase();
    return ESIM_COUNTRIES.filter(
      (c) => c.name.toLowerCase().includes(lower) || c.code.toLowerCase().includes(lower),
    );
  }

  async getPlansForCountry(countryCode: string): Promise<ESIMCountryPlan[]> {
    if (hasAiraloConfig) {
      const json = await airaloFetch<AiraloPackagesResponse>(
        `/v2/packages?filter[country]=${encodeURIComponent(countryCode)}&limit=20`,
      );
      if (json?.data) {
        const plans: ESIMCountryPlan[] = [];
        for (const country of json.data) {
          for (const op of country.operators) {
            for (const pkg of op.packages ?? []) {
              const dataMB = parseDataToMB(pkg.data);
              plans.push({
                id: pkg.slug ?? pkg.id,
                countryCode,
                countryName: country.title,
                countryFlag: ESIM_COUNTRIES.find((c) => c.code === countryCode)?.flag ?? '',
                dataLimitMB: dataMB,
                dataLabel: pkg.data,
                validDays: pkg.validity,
                price: pkg.price,
                currency: pkg.currency ?? 'USD',
                popular: false,
              });
            }
          }
        }
        if (plans.length > 0) return plans;
      }
    }
    await delay(600);
    const localPlans = COUNTRY_PLANS[countryCode];
    if (localPlans) return localPlans;
    const country = ESIM_COUNTRIES.find((c) => c.code === countryCode);
    if (country) return generateDefaultPlans(country);
    return [];
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
    await delay(800);
    const allPlans: ESIMPlan[] = [];
    for (const [code, plans] of Object.entries(COUNTRY_PLANS)) {
      const country = ESIM_COUNTRIES.find((c) => c.code === code);
      for (const plan of plans) {
        allPlans.push({
          id: plan.id,
          name: `${plan.countryName} ${plan.dataLabel}`,
          region: country?.region ?? '',
          countries: 1,
          dataLimitMB: plan.dataLimitMB,
          validDays: plan.validDays,
          price: plan.price,
          currency: plan.currency,
          provider: 'SatConnect',
        });
      }
    }
    if (region) {
      return allPlans.filter((p) =>
        p.region.toLowerCase().includes(region.toLowerCase()),
      );
    }
    return allPlans;
  }

  async provisionESIM(planId: string): Promise<ProvisioningResult> {
    if (!this.initialized) await this.initialize();
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
    await delay(2000);
    let foundPlan: ESIMCountryPlan | undefined;
    for (const plans of Object.values(COUNTRY_PLANS)) {
      foundPlan = plans.find((p) => p.id === planId);
      if (foundPlan) break;
    }
    if (!foundPlan) {
      // Check dynamically generated plans for countries without explicit entries
      for (const country of ESIM_COUNTRIES) {
        if (!COUNTRY_PLANS[country.code]) {
          const defaultPlans = generateDefaultPlans(country);
          foundPlan = defaultPlans.find((p) => p.id === planId);
          if (foundPlan) break;
        }
      }
    }
    if (!foundPlan) {
      return { success: false, error: 'Planul selectat nu a fost g\u0103sit' };
    }
    const mockId = Date.now();
    const mockRandom = Math.random().toString(36).substring(2, 12).toUpperCase();
    const profile: ESIMProfile = {
      id: `esim_${mockId}`,
      iccid: `894010${mockId}`,
      activationCode: 'LPA:1$smdp.satconnect.app$' + mockRandom,
      carrier: 'SatConnect',
      region: foundPlan.countryName,
      countries: [foundPlan.countryName],
      dataLimitMB: foundPlan.dataLimitMB,
      dataUsedMB: 0,
      validFrom: new Date().toISOString(),
      validUntil: new Date(Date.now() + foundPlan.validDays * 24 * 60 * 60 * 1000).toISOString(),
      status: 'pending',
      qrCodeUrl: `https://api.satconnect.app/esim/qr/${mockId}`,
    };
    this.profiles.push(profile);
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));
    return {
      success: true,
      profile,
      activationTime: '2 minute',
    };
  }

  async activateESIM(profileId: string): Promise<ProvisioningResult> {
    if (!this.initialized) await this.initialize();
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

  async getProfiles(): Promise<ESIMProfile[]> {
    if (!this.initialized) await this.initialize();
    return [...this.profiles];
  }

  async getActiveProfile(): Promise<ESIMProfile | null> {
    if (!this.initialized) await this.initialize();
    return this.profiles.find((p) => p.status === 'active') ?? null;
  }

  async checkCompatibility(): Promise<{ compatible: boolean; reason?: string }> {
    return { compatible: true };
  }

  async deactivateESIM(profileId: string): Promise<ProvisioningResult> {
    if (!this.initialized) await this.initialize();
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
