// ============================================================================
// GET /plans - List available eSIM plans
// ============================================================================
// Fetches packages from eSIM Access API (cached 1 hour) and transforms
// them into plan entries with retail pricing.
// Falls back to Supabase esim_plans table if API is unavailable.
//
// Query params:
//   ?country_code=JP  - Filter by country
//   ?region=Europa    - Filter by region
//
// Public endpoint (no auth required) - users browse plans before purchasing.
// ============================================================================

import { Router, Request, Response } from 'express';
import { supabase } from '../config/database';
import { Plan, ApiResponse } from '../types';
import { hasEsimAccessCredentials, getPackages, EsimAccessPackage } from '../services/esimAccess';

const router = Router();

// ---------------------------------------------------------------------------
// Cache for eSIM Access packages (1 hour TTL)
// ---------------------------------------------------------------------------
interface CachedPlans {
  data: Record<string, GroupedCountry>;
  timestamp: number;
}

interface GroupedCountry {
  country_code: string;
  country_name: string;
  region: string;
  plans: PlanLike[];
}

interface PlanLike {
  id: string;
  country_code: string;
  country_name: string;
  data_limit_mb: number;
  data_label: string;
  valid_days: number;
  price: number;
  currency: string;
  region: string;
  is_active: boolean;
  esim_access_package?: string;
}

let cachedPlans: CachedPlans | null = null;
const CACHE_TTL_MS = 60 * 60 * 1000; // 1 hour

// ---------------------------------------------------------------------------
// Country name mapping (Romanian-friendly names for popular countries)
// ---------------------------------------------------------------------------
const COUNTRY_NAMES: Record<string, string> = {
  AD: 'Andorra', AE: 'Emiratele Arabe', AF: 'Afganistan', AG: 'Antigua', AI: 'Anguilla',
  AL: 'Albania', AM: 'Armenia', AO: 'Angola', AR: 'Argentina', AT: 'Austria',
  AU: 'Australia', AW: 'Aruba', AX: 'Insulele Aland', AZ: 'Azerbaidjan', BA: 'Bosnia', BB: 'Barbados',
  BD: 'Bangladesh', BE: 'Belgia', BF: 'Burkina Faso', BG: 'Bulgaria', BH: 'Bahrain',
  BJ: 'Benin', BM: 'Bermuda', BN: 'Brunei', BO: 'Bolivia', BR: 'Brazilia',
  BS: 'Bahamas', BT: 'Bhutan', BW: 'Botswana', BY: 'Belarus', BZ: 'Belize',
  CA: 'Canada', CD: 'Congo (RDC)', CF: 'Republica Centrafricana', CG: 'Congo',
  CH: 'Elvetia', CI: 'Coasta de Fildes', CL: 'Chile', CM: 'Camerun', CN: 'China',
  CO: 'Columbia', CR: 'Costa Rica', CU: 'Cuba', CV: 'Capul Verde', CW: 'Curacao',
  CY: 'Cipru', CZ: 'Cehia', DE: 'Germania', DJ: 'Djibouti', DK: 'Danemarca',
  DM: 'Dominica', DO: 'Republica Dominicana', DZ: 'Algeria', EC: 'Ecuador',
  EE: 'Estonia', EG: 'Egipt', ES: 'Spania', ET: 'Etiopia', FI: 'Finlanda',
  FJ: 'Fiji', FK: 'Insulele Falkland', FO: 'Insulele Feroe', FR: 'Franta',
  GA: 'Gabon', GB: 'Marea Britanie', GD: 'Grenada', GE: 'Georgia', GF: 'Guyana Franceza',
  GG: 'Guernsey', GH: 'Ghana', GI: 'Gibraltar', GL: 'Groenlanda', GM: 'Gambia',
  GN: 'Guineea', GP: 'Guadeloupe', GQ: 'Guineea Ecuatoriala', GR: 'Grecia',
  GT: 'Guatemala', GU: 'Guam', GW: 'Guineea-Bissau', GY: 'Guyana', HK: 'Hong Kong',
  HN: 'Honduras', HR: 'Croatia', HT: 'Haiti', HU: 'Ungaria', ID: 'Indonezia',
  IE: 'Irlanda', IL: 'Israel', IM: 'Insula Man', IN: 'India', IQ: 'Irak',
  IR: 'Iran', IS: 'Islanda', IT: 'Italia', JE: 'Jersey', JM: 'Jamaica',
  JO: 'Iordania', JP: 'Japonia', KE: 'Kenya', KG: 'Kirgistan', KH: 'Cambodgia',
  KN: 'Saint Kitts', KR: 'Coreea de Sud', KW: 'Kuwait', KY: 'Insulele Cayman',
  KZ: 'Kazahstan', LA: 'Laos', LB: 'Liban', LC: 'Saint Lucia', LI: 'Liechtenstein',
  LK: 'Sri Lanka', LR: 'Liberia', LS: 'Lesotho', LT: 'Lituania', LU: 'Luxemburg',
  LV: 'Letonia', MA: 'Maroc', MC: 'Monaco', MD: 'Moldova', ME: 'Muntenegru',
  MG: 'Madagascar', MK: 'Macedonia de Nord', ML: 'Mali', MM: 'Myanmar', MN: 'Mongolia',
  MO: 'Macao', MQ: 'Martinica', MR: 'Mauritania', MS: 'Montserrat', MT: 'Malta',
  MU: 'Mauritius', MV: 'Maldive', MW: 'Malawi', MX: 'Mexic', MY: 'Malaezia',
  MZ: 'Mozambic', NA: 'Namibia', NC: 'Noua Caledonie', NE: 'Niger', NG: 'Nigeria',
  NI: 'Nicaragua', NL: 'Olanda', NO: 'Norvegia', NP: 'Nepal', NZ: 'Noua Zeelanda',
  OM: 'Oman', PA: 'Panama', PE: 'Peru', PF: 'Polinezia Franceza', PG: 'Papua Noua Guinee',
  PH: 'Filipine', PK: 'Pakistan', PL: 'Polonia', PR: 'Puerto Rico', PS: 'Palestina',
  PT: 'Portugalia', PY: 'Paraguay', QA: 'Qatar', RE: 'Reunion', RO: 'Romania',
  RS: 'Serbia', RU: 'Rusia', RW: 'Rwanda', SA: 'Arabia Saudita', SC: 'Seychelles',
  SD: 'Sudan', SE: 'Suedia', SG: 'Singapore', SI: 'Slovenia', SK: 'Slovacia',
  SL: 'Sierra Leone', SN: 'Senegal', SO: 'Somalia', SR: 'Surinam', SS: 'Sudanul de Sud',
  SV: 'El Salvador', SX: 'Sint Maarten', SZ: 'Eswatini', TC: 'Insulele Turks',
  TD: 'Ciad', TG: 'Togo', TH: 'Thailanda', TJ: 'Tadjikistan', TM: 'Turkmenistan',
  TN: 'Tunisia', TO: 'Tonga', TR: 'Turcia', TT: 'Trinidad si Tobago', TW: 'Taiwan',
  TZ: 'Tanzania', UA: 'Ucraina', UG: 'Uganda', US: 'SUA', UY: 'Uruguay',
  UZ: 'Uzbekistan', VC: 'Saint Vincent', VE: 'Venezuela', VG: 'Insulele Virgine Britanice',
  VN: 'Vietnam', VU: 'Vanuatu', WS: 'Samoa', ZA: 'Africa de Sud', ZM: 'Zambia',
  ZW: 'Zimbabwe',
};

// ---------------------------------------------------------------------------
// Region classification
// ---------------------------------------------------------------------------
const REGION_MAP: Record<string, string[]> = {
  'Europa': ['AD','AL','AT','BA','BE','BG','BY','CH','CY','CZ','DE','DK','EE','ES','FI','FO','FR','GB','GG','GI','GR','HR','HU','IE','IM','IS','IT','JE','LI','LT','LU','LV','MC','MD','ME','MK','MT','NL','NO','PL','PT','RO','RS','RU','SE','SI','SK','TR','UA'],
  'Asia': ['AF','AM','AZ','BD','BH','BN','BT','CN','GE','HK','ID','IL','IN','IQ','IR','JO','JP','KG','KH','KR','KW','KZ','LA','LB','LK','MM','MN','MO','MV','MY','NP','OM','PH','PK','PS','QA','SA','SG','TH','TJ','TM','TW','UZ','VN'],
  'Americas': ['AG','AI','AR','AW','BB','BM','BO','BR','BS','BZ','CA','CL','CO','CR','CU','CW','DM','DO','EC','FK','GD','GF','GP','GT','GU','GY','HN','HT','JM','KN','KY','LC','MQ','MX','MS','NI','PA','PE','PR','PY','SR','SV','SX','TC','TT','US','UY','VC','VE','VG'],
  'Africa & ME': ['AE','AO','BF','BJ','BW','CD','CF','CG','CI','CM','CV','DJ','DZ','EG','ET','GA','GH','GM','GN','GQ','GW','KE','LR','LS','MA','MG','ML','MR','MU','MW','MZ','NA','NE','NG','RE','RW','SC','SD','SL','SN','SO','SR','SS','SZ','TD','TG','TN','TZ','UG','ZA','ZM','ZW'],
  'Oceania': ['AU','FJ','NC','NZ','PF','PG','TO','VU','WS'],
};

function getRegionForCountry(code: string): string {
  for (const [region, codes] of Object.entries(REGION_MAP)) {
    if (codes.includes(code)) return region;
  }
  return 'Other';
}

// ---------------------------------------------------------------------------
// Pricing: convert eSIM Access cost (in thousandths of USD) to retail EUR price
// e.g. 7000 = $7.00
// ---------------------------------------------------------------------------
const USD_TO_EUR = 0.92;
const MARKUP = 1.4; // 40% margin over wholesale

function calculateRetailPrice(costInThousandths: number): number {
  const costUsd = costInThousandths / 1000;
  const retailEur = costUsd * MARKUP * USD_TO_EUR;
  if (retailEur < 1) return 0.99;
  if (retailEur < 3) return Math.ceil(retailEur * 2) / 2;
  return Math.round(retailEur * 2) / 2;
}

function formatDataLabel(volumeBytes: number): string {
  const gb = volumeBytes / (1024 * 1024 * 1024);
  if (gb >= 1) {
    const rounded = Math.round(gb * 10) / 10;
    return rounded % 1 === 0 ? `${Math.round(rounded)} GB` : `${rounded} GB`;
  }
  const mb = Math.round(volumeBytes / (1024 * 1024));
  return `${mb} MB`;
}

// ---------------------------------------------------------------------------
// Transform eSIM Access packages into plan format
// ---------------------------------------------------------------------------
function transformPackagesToPlans(packages: EsimAccessPackage[]): Record<string, GroupedCountry> {
  const grouped: Record<string, GroupedCountry> = {};

  for (const pkg of packages) {
    const cc = pkg.locationCode;

    // Skip regional/multi-country packages (only want 2-letter country codes)
    if (cc.length !== 2) continue;

    const volumeBytes = pkg.volume;
    const volumeMB = Math.round(volumeBytes / (1024 * 1024));

    // Skip very small packages (< 500MB)
    if (volumeMB < 500) continue;

    // Skip daily packages (duration <= 1 day)
    if (pkg.duration <= 1) continue;

    // Skip FUP throttled and variant packages
    if (pkg.name.includes('FUP') || pkg.name.includes('nonhkip')) continue;

    const countryName = COUNTRY_NAMES[cc] || getCountryNameFromPackage(pkg) || cc;
    const region = getRegionForCountry(cc);
    const dataLabel = formatDataLabel(volumeBytes);
    const planId = `${cc.toLowerCase()}-${dataLabel.toLowerCase().replace(/\s+/g, '')}`;

    if (!grouped[cc]) {
      grouped[cc] = {
        country_code: cc,
        country_name: countryName,
        region,
        plans: [],
      };
    }

    // Avoid duplicate data labels for same country
    const existingLabels = grouped[cc].plans.map(p => p.data_label);
    if (existingLabels.includes(dataLabel)) continue;

    grouped[cc].plans.push({
      id: planId,
      country_code: cc,
      country_name: countryName,
      data_limit_mb: volumeMB,
      data_label: dataLabel,
      valid_days: pkg.duration,
      price: calculateRetailPrice(pkg.price),
      currency: 'EUR',
      region,
      is_active: true,
      esim_access_package: pkg.packageCode,
    });
  }

  // Sort plans within each country by data volume, limit to 6
  for (const country of Object.values(grouped)) {
    country.plans.sort((a, b) => a.data_limit_mb - b.data_limit_mb);
    if (country.plans.length > 6) {
      country.plans = country.plans.slice(0, 6);
    }
  }

  return grouped;
}

function getCountryNameFromPackage(pkg: EsimAccessPackage): string {
  const match = pkg.name.match(/^([A-Za-z\s-]+?)\s+\d/);
  return match ? match[1].trim() : pkg.locationCode;
}

// ---------------------------------------------------------------------------
// Fetch and cache plans from eSIM Access API
// ---------------------------------------------------------------------------
async function getApiPlans(): Promise<Record<string, GroupedCountry>> {
  if (cachedPlans && (Date.now() - cachedPlans.timestamp) < CACHE_TTL_MS) {
    return cachedPlans.data;
  }

  try {
    const packages = await getPackages();
    const grouped = transformPackagesToPlans(packages);
    cachedPlans = { data: grouped, timestamp: Date.now() };
    console.log(`Cached ${Object.keys(grouped).length} countries from eSIM Access API`);
    return grouped;
  } catch (err) {
    console.error('Failed to fetch eSIM Access packages:', err);
    if (cachedPlans) return cachedPlans.data;
    return {};
  }
}

// ---------------------------------------------------------------------------
// GET /plans
// ---------------------------------------------------------------------------
router.get('/', async (req: Request, res: Response) => {
  try {
    const { country_code, region } = req.query;

    let grouped: Record<string, GroupedCountry>;

    // Try eSIM Access API first (has all 200+ countries)
    if (hasEsimAccessCredentials()) {
      grouped = await getApiPlans();
    } else {
      // Fallback to Supabase plans
      const { data, error } = await supabase
        .from('esim_plans')
        .select('*')
        .eq('is_active', true)
        .order('country_name', { ascending: true })
        .order('data_limit_mb', { ascending: true });

      if (error) {
        const response: ApiResponse<null> = { success: false, error: error.message };
        res.status(500).json(response);
        return;
      }

      grouped = {};
      for (const plan of (data as Plan[])) {
        if (!grouped[plan.country_code]) {
          grouped[plan.country_code] = {
            country_code: plan.country_code,
            country_name: plan.country_name,
            region: plan.region,
            plans: [],
          };
        }
        grouped[plan.country_code].plans.push(plan as unknown as PlanLike);
      }
    }

    // Apply filters
    if (country_code && typeof country_code === 'string') {
      const cc = country_code.toUpperCase();
      grouped = cc in grouped ? { [cc]: grouped[cc] } : {};
    }

    if (region && typeof region === 'string') {
      const filtered: Record<string, GroupedCountry> = {};
      for (const [code, data] of Object.entries(grouped)) {
        if (data.region === region) {
          filtered[code] = data;
        }
      }
      grouped = filtered;
    }

    // Sort by country name
    const sorted: Record<string, GroupedCountry> = {};
    const sortedKeys = Object.keys(grouped).sort((a, b) =>
      grouped[a].country_name.localeCompare(grouped[b].country_name)
    );
    for (const key of sortedKeys) {
      sorted[key] = grouped[key];
    }

    const response: ApiResponse<typeof sorted> = {
      success: true,
      data: sorted,
    };

    res.json(response);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error';
    const response: ApiResponse<null> = { success: false, error: message };
    res.status(500).json(response);
  }
});

export default router;
