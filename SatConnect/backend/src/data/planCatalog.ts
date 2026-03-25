// ---------------------------------------------------------------------------
// Server-side plan price catalog
// Single source of truth for pricing — prevents client-side price manipulation.
// Mirrors the frontend esimProvisioning.ts COUNTRY_PLANS data.
// ---------------------------------------------------------------------------

export interface PlanEntry {
  id: string;
  countryCode: string;
  countryName: string;
  countryFlag: string;
  dataLimitMB: number;
  dataLabel: string;
  validDays: number;
  price: number;
  currency: string;
}

function p(id: string, cc: string, cn: string, cf: string, mb: number, dl: string, vd: number, pr: number): PlanEntry {
  return { id, countryCode: cc, countryName: cn, countryFlag: cf, dataLimitMB: mb, dataLabel: dl, validDays: vd, price: pr, currency: 'EUR' };
}

const PLAN_LIST: PlanEntry[] = [
  // --- EUROPA ---
  p('ro-1gb', 'RO', 'România', '🇷🇴', 1024, '1 GB', 7, 1.29),
  p('ro-3gb', 'RO', 'România', '🇷🇴', 3072, '3 GB', 15, 2.99),
  p('ro-5gb', 'RO', 'România', '🇷🇴', 5120, '5 GB', 30, 3.99),
  p('ro-10gb', 'RO', 'România', '🇷🇴', 10240, '10 GB', 30, 5.49),
  p('ro-20gb', 'RO', 'România', '🇷🇴', 20480, '20 GB', 30, 8.99),
  p('ro-50gb', 'RO', 'România', '🇷🇴', 51200, '50 GB', 30, 16.99),
  p('fr-1gb', 'FR', 'Franța', '🇫🇷', 1024, '1 GB', 7, 1.99),
  p('fr-3gb', 'FR', 'Franța', '🇫🇷', 3072, '3 GB', 15, 3.99),
  p('fr-5gb', 'FR', 'Franța', '🇫🇷', 5120, '5 GB', 30, 5.49),
  p('fr-10gb', 'FR', 'Franța', '🇫🇷', 10240, '10 GB', 30, 7.49),
  p('fr-20gb', 'FR', 'Franța', '🇫🇷', 20480, '20 GB', 30, 11.99),
  p('fr-50gb', 'FR', 'Franța', '🇫🇷', 51200, '50 GB', 30, 22.99),
  p('de-1gb', 'DE', 'Germania', '🇩🇪', 1024, '1 GB', 7, 1.99),
  p('de-3gb', 'DE', 'Germania', '🇩🇪', 3072, '3 GB', 15, 3.99),
  p('de-5gb', 'DE', 'Germania', '🇩🇪', 5120, '5 GB', 30, 5.49),
  p('de-10gb', 'DE', 'Germania', '🇩🇪', 10240, '10 GB', 30, 7.49),
  p('de-20gb', 'DE', 'Germania', '🇩🇪', 20480, '20 GB', 30, 11.99),
  p('de-50gb', 'DE', 'Germania', '🇩🇪', 51200, '50 GB', 30, 22.99),
  p('it-1gb', 'IT', 'Italia', '🇮🇹', 1024, '1 GB', 7, 1.99),
  p('it-3gb', 'IT', 'Italia', '🇮🇹', 3072, '3 GB', 15, 3.49),
  p('it-5gb', 'IT', 'Italia', '🇮🇹', 5120, '5 GB', 30, 4.99),
  p('it-10gb', 'IT', 'Italia', '🇮🇹', 10240, '10 GB', 30, 7.49),
  p('it-20gb', 'IT', 'Italia', '🇮🇹', 20480, '20 GB', 30, 11.99),
  p('it-50gb', 'IT', 'Italia', '🇮🇹', 51200, '50 GB', 30, 22.99),
  p('es-1gb', 'ES', 'Spania', '🇪🇸', 1024, '1 GB', 7, 1.99),
  p('es-3gb', 'ES', 'Spania', '🇪🇸', 3072, '3 GB', 15, 3.49),
  p('es-5gb', 'ES', 'Spania', '🇪🇸', 5120, '5 GB', 30, 4.99),
  p('es-10gb', 'ES', 'Spania', '🇪🇸', 10240, '10 GB', 30, 7.49),
  p('es-20gb', 'ES', 'Spania', '🇪🇸', 20480, '20 GB', 30, 11.99),
  p('es-50gb', 'ES', 'Spania', '🇪🇸', 51200, '50 GB', 30, 22.99),
  p('gb-1gb', 'GB', 'Marea Britanie', '🇬🇧', 1024, '1 GB', 7, 2.49),
  p('gb-3gb', 'GB', 'Marea Britanie', '🇬🇧', 3072, '3 GB', 15, 4.49),
  p('gb-5gb', 'GB', 'Marea Britanie', '🇬🇧', 5120, '5 GB', 30, 5.99),
  p('gb-10gb', 'GB', 'Marea Britanie', '🇬🇧', 10240, '10 GB', 30, 8.49),
  p('gb-20gb', 'GB', 'Marea Britanie', '🇬🇧', 20480, '20 GB', 30, 13.99),
  p('gb-50gb', 'GB', 'Marea Britanie', '🇬🇧', 51200, '50 GB', 30, 25.99),
  p('gr-1gb', 'GR', 'Grecia', '🇬🇷', 1024, '1 GB', 7, 1.99),
  p('gr-3gb', 'GR', 'Grecia', '🇬🇷', 3072, '3 GB', 15, 3.49),
  p('gr-5gb', 'GR', 'Grecia', '🇬🇷', 5120, '5 GB', 30, 4.99),
  p('gr-10gb', 'GR', 'Grecia', '🇬🇷', 10240, '10 GB', 30, 7.49),
  p('gr-20gb', 'GR', 'Grecia', '🇬🇷', 20480, '20 GB', 30, 11.99),
  p('gr-50gb', 'GR', 'Grecia', '🇬🇷', 51200, '50 GB', 30, 22.99),
  p('tr-1gb', 'TR', 'Turcia', '🇹🇷', 1024, '1 GB', 7, 1.29),
  p('tr-3gb', 'TR', 'Turcia', '🇹🇷', 3072, '3 GB', 15, 2.99),
  p('tr-5gb', 'TR', 'Turcia', '🇹🇷', 5120, '5 GB', 30, 3.99),
  p('tr-10gb', 'TR', 'Turcia', '🇹🇷', 10240, '10 GB', 30, 5.49),
  p('tr-20gb', 'TR', 'Turcia', '🇹🇷', 20480, '20 GB', 30, 8.99),
  p('tr-50gb', 'TR', 'Turcia', '🇹🇷', 51200, '50 GB', 30, 16.99),
  // --- ASIA ---
  p('jp-1gb', 'JP', 'Japonia', '🇯🇵', 1024, '1 GB', 7, 2.49),
  p('jp-3gb', 'JP', 'Japonia', '🇯🇵', 3072, '3 GB', 15, 4.49),
  p('jp-5gb', 'JP', 'Japonia', '🇯🇵', 5120, '5 GB', 30, 5.99),
  p('jp-10gb', 'JP', 'Japonia', '🇯🇵', 10240, '10 GB', 30, 7.99),
  p('jp-20gb', 'JP', 'Japonia', '🇯🇵', 20480, '20 GB', 30, 13.49),
  p('jp-50gb', 'JP', 'Japonia', '🇯🇵', 51200, '50 GB', 30, 24.99),
  p('kr-1gb', 'KR', 'Coreea de Sud', '🇰🇷', 1024, '1 GB', 7, 2.49),
  p('kr-3gb', 'KR', 'Coreea de Sud', '🇰🇷', 3072, '3 GB', 15, 4.49),
  p('kr-5gb', 'KR', 'Coreea de Sud', '🇰🇷', 5120, '5 GB', 30, 5.99),
  p('kr-10gb', 'KR', 'Coreea de Sud', '🇰🇷', 10240, '10 GB', 30, 7.99),
  p('kr-20gb', 'KR', 'Coreea de Sud', '🇰🇷', 20480, '20 GB', 30, 13.49),
  p('kr-50gb', 'KR', 'Coreea de Sud', '🇰🇷', 51200, '50 GB', 30, 24.99),
  p('th-1gb', 'TH', 'Thailanda', '🇹🇭', 1024, '1 GB', 7, 1.29),
  p('th-3gb', 'TH', 'Thailanda', '🇹🇭', 3072, '3 GB', 15, 2.49),
  p('th-5gb', 'TH', 'Thailanda', '🇹🇭', 5120, '5 GB', 30, 3.49),
  p('th-10gb', 'TH', 'Thailanda', '🇹🇭', 10240, '10 GB', 30, 4.99),
  p('th-20gb', 'TH', 'Thailanda', '🇹🇭', 20480, '20 GB', 30, 7.99),
  p('th-50gb', 'TH', 'Thailanda', '🇹🇭', 51200, '50 GB', 30, 14.99),
  p('in-1gb', 'IN', 'India', '🇮🇳', 1024, '1 GB', 7, 0.99),
  p('in-3gb', 'IN', 'India', '🇮🇳', 3072, '3 GB', 15, 1.99),
  p('in-5gb', 'IN', 'India', '🇮🇳', 5120, '5 GB', 30, 2.99),
  p('in-10gb', 'IN', 'India', '🇮🇳', 10240, '10 GB', 30, 3.99),
  p('in-20gb', 'IN', 'India', '🇮🇳', 20480, '20 GB', 30, 5.99),
  p('in-50gb', 'IN', 'India', '🇮🇳', 51200, '50 GB', 30, 10.99),
  p('cn-1gb', 'CN', 'China', '🇨🇳', 1024, '1 GB', 7, 2.49),
  p('cn-3gb', 'CN', 'China', '🇨🇳', 3072, '3 GB', 15, 4.99),
  p('cn-5gb', 'CN', 'China', '🇨🇳', 5120, '5 GB', 30, 6.99),
  p('cn-10gb', 'CN', 'China', '🇨🇳', 10240, '10 GB', 30, 9.99),
  p('cn-20gb', 'CN', 'China', '🇨🇳', 20480, '20 GB', 30, 16.99),
  p('cn-50gb', 'CN', 'China', '🇨🇳', 51200, '50 GB', 30, 29.99),
  // --- AMERICAS ---
  p('us-1gb', 'US', 'SUA', '🇺🇸', 1024, '1 GB', 7, 2.49),
  p('us-3gb', 'US', 'SUA', '🇺🇸', 3072, '3 GB', 15, 4.99),
  p('us-5gb', 'US', 'SUA', '🇺🇸', 5120, '5 GB', 30, 6.49),
  p('us-10gb', 'US', 'SUA', '🇺🇸', 10240, '10 GB', 30, 8.99),
  p('us-20gb', 'US', 'SUA', '🇺🇸', 20480, '20 GB', 30, 14.99),
  p('us-50gb', 'US', 'SUA', '🇺🇸', 51200, '50 GB', 30, 27.99),
  p('ca-1gb', 'CA', 'Canada', '🇨🇦', 1024, '1 GB', 7, 2.49),
  p('ca-3gb', 'CA', 'Canada', '🇨🇦', 3072, '3 GB', 15, 4.99),
  p('ca-5gb', 'CA', 'Canada', '🇨🇦', 5120, '5 GB', 30, 6.49),
  p('ca-10gb', 'CA', 'Canada', '🇨🇦', 10240, '10 GB', 30, 8.99),
  p('ca-20gb', 'CA', 'Canada', '🇨🇦', 20480, '20 GB', 30, 14.99),
  p('ca-50gb', 'CA', 'Canada', '🇨🇦', 51200, '50 GB', 30, 27.99),
  p('mx-1gb', 'MX', 'Mexic', '🇲🇽', 1024, '1 GB', 7, 1.49),
  p('mx-3gb', 'MX', 'Mexic', '🇲🇽', 3072, '3 GB', 15, 2.99),
  p('mx-5gb', 'MX', 'Mexic', '🇲🇽', 5120, '5 GB', 30, 4.49),
  p('mx-10gb', 'MX', 'Mexic', '🇲🇽', 10240, '10 GB', 30, 5.99),
  p('mx-20gb', 'MX', 'Mexic', '🇲🇽', 20480, '20 GB', 30, 9.99),
  p('mx-50gb', 'MX', 'Mexic', '🇲🇽', 51200, '50 GB', 30, 17.99),
  p('br-1gb', 'BR', 'Brazilia', '🇧🇷', 1024, '1 GB', 7, 1.49),
  p('br-3gb', 'BR', 'Brazilia', '🇧🇷', 3072, '3 GB', 15, 2.99),
  p('br-5gb', 'BR', 'Brazilia', '🇧🇷', 5120, '5 GB', 30, 4.49),
  p('br-10gb', 'BR', 'Brazilia', '🇧🇷', 10240, '10 GB', 30, 5.99),
  p('br-20gb', 'BR', 'Brazilia', '🇧🇷', 20480, '20 GB', 30, 9.99),
  p('br-50gb', 'BR', 'Brazilia', '🇧🇷', 51200, '50 GB', 30, 17.99),
  // --- ORIENT MIJLOCIU & AFRICA ---
  p('eg-1gb', 'EG', 'Egipt', '🇪🇬', 1024, '1 GB', 7, 1.99),
  p('eg-3gb', 'EG', 'Egipt', '🇪🇬', 3072, '3 GB', 15, 3.49),
  p('eg-5gb', 'EG', 'Egipt', '🇪🇬', 5120, '5 GB', 30, 4.99),
  p('eg-10gb', 'EG', 'Egipt', '🇪🇬', 10240, '10 GB', 30, 7.49),
  p('eg-20gb', 'EG', 'Egipt', '🇪🇬', 20480, '20 GB', 30, 11.99),
  p('eg-50gb', 'EG', 'Egipt', '🇪🇬', 51200, '50 GB', 30, 22.99),
  p('ae-1gb', 'AE', 'Emiratele Arabe', '🇦🇪', 1024, '1 GB', 7, 2.49),
  p('ae-3gb', 'AE', 'Emiratele Arabe', '🇦🇪', 3072, '3 GB', 15, 4.49),
  p('ae-5gb', 'AE', 'Emiratele Arabe', '🇦🇪', 5120, '5 GB', 30, 5.99),
  p('ae-10gb', 'AE', 'Emiratele Arabe', '🇦🇪', 10240, '10 GB', 30, 8.49),
  p('ae-20gb', 'AE', 'Emiratele Arabe', '🇦🇪', 20480, '20 GB', 30, 13.99),
  p('ae-50gb', 'AE', 'Emiratele Arabe', '🇦🇪', 51200, '50 GB', 30, 25.99),
  // --- OCEANIA ---
  p('au-1gb', 'AU', 'Australia', '🇦🇺', 1024, '1 GB', 7, 2.49),
  p('au-3gb', 'AU', 'Australia', '🇦🇺', 3072, '3 GB', 15, 4.49),
  p('au-5gb', 'AU', 'Australia', '🇦🇺', 5120, '5 GB', 30, 5.99),
  p('au-10gb', 'AU', 'Australia', '🇦🇺', 10240, '10 GB', 30, 7.79),
  p('au-20gb', 'AU', 'Australia', '🇦🇺', 20480, '20 GB', 30, 12.99),
  p('au-50gb', 'AU', 'Australia', '🇦🇺', 51200, '50 GB', 30, 23.99),
  // --- PLANURI REGIONALE ---
  p('eu-1gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 1024, '1 GB', 7, 2.49),
  p('eu-3gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 3072, '3 GB', 15, 4.49),
  p('eu-5gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 5120, '5 GB', 30, 5.99),
  p('eu-10gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 10240, '10 GB', 30, 7.99),
  p('eu-20gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 20480, '20 GB', 30, 12.99),
  p('eu-50gb', 'EU', 'Europa (30+ țări)', '🇪🇺', 51200, '50 GB', 30, 23.99),
  p('asia-1gb', 'ASIA', 'Asia Pacific', '🌏', 1024, '1 GB', 7, 2.49),
  p('asia-3gb', 'ASIA', 'Asia Pacific', '🌏', 3072, '3 GB', 15, 4.49),
  p('asia-5gb', 'ASIA', 'Asia Pacific', '🌏', 5120, '5 GB', 30, 5.99),
  p('asia-10gb', 'ASIA', 'Asia Pacific', '🌏', 10240, '10 GB', 30, 7.99),
  p('asia-20gb', 'ASIA', 'Asia Pacific', '🌏', 20480, '20 GB', 30, 12.99),
  p('asia-50gb', 'ASIA', 'Asia Pacific', '🌏', 51200, '50 GB', 30, 23.99),
  p('global-1gb', 'GLOBAL', 'Global (175 țări)', '🌍', 1024, '1 GB', 7, 2.99),
  p('global-3gb', 'GLOBAL', 'Global (175 țări)', '🌍', 3072, '3 GB', 15, 5.99),
  p('global-5gb', 'GLOBAL', 'Global (175 țări)', '🌍', 5120, '5 GB', 30, 7.99),
  p('global-10gb', 'GLOBAL', 'Global (175 țări)', '🌍', 10240, '10 GB', 30, 11.99),
  p('global-20gb', 'GLOBAL', 'Global (175 țări)', '🌍', 20480, '20 GB', 30, 19.99),
  p('global-50gb', 'GLOBAL', 'Global (175 țări)', '🌍', 51200, '50 GB', 30, 34.99),
];

// Default pricing for dynamically-generated country plans
const DEFAULT_TIERS = [
  { suffix: '500mb', mb: 512, dl: '500 MB', vd: 7, pr: 1.49 },
  { suffix: '1gb', mb: 1024, dl: '1 GB', vd: 7, pr: 1.99 },
  { suffix: '3gb', mb: 3072, dl: '3 GB', vd: 15, pr: 3.99 },
  { suffix: '5gb', mb: 5120, dl: '5 GB', vd: 30, pr: 5.49 },
  { suffix: '10gb', mb: 10240, dl: '10 GB', vd: 30, pr: 7.49 },
  { suffix: '15gb', mb: 15360, dl: '15 GB', vd: 30, pr: 9.99 },
  { suffix: '20gb', mb: 20480, dl: '20 GB', vd: 30, pr: 11.99 },
  { suffix: '50gb', mb: 51200, dl: '50 GB', vd: 30, pr: 22.99 },
];

// Index by plan ID for O(1) lookups
const PLAN_INDEX = new Map<string, PlanEntry>();
for (const plan of PLAN_LIST) {
  PLAN_INDEX.set(plan.id, plan);
}

/**
 * Look up a plan by ID. Returns the server-side plan entry or undefined.
 * Also handles dynamically-generated plans (e.g. "nl-10gb") by matching
 * the data tier suffix against default pricing.
 */
export function getPlanById(planId: string): PlanEntry | undefined {
  // Check explicit catalog first
  const explicit = PLAN_INDEX.get(planId);
  if (explicit) return explicit;

  // Check if it matches a default-tier pattern: {cc}-{tier} (e.g. 'nl-10gb', 'jp-500mb')
  const match = planId.match(/^([a-z]{2})-(\d+(?:\.\d+)?(?:gb|mb))$/);
  if (!match) return undefined;

  const tier = DEFAULT_TIERS.find(t => t.suffix === match[2]);
  if (!tier) return undefined;

  // Return a generated plan entry with default pricing
  return {
    id: planId,
    countryCode: match[1].toUpperCase(),
    countryName: match[1].toUpperCase(),
    countryFlag: '',
    dataLimitMB: tier.mb,
    dataLabel: tier.dl,
    validDays: tier.vd,
    price: tier.pr,
    currency: 'EUR',
  };
}
