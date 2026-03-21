// Expo inlines EXPO_PUBLIC_* at compile time via babel-preset-expo.
// We must access them as static member expressions for the transform to work.
const rawSupabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const rawSupabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;
const rawAiraloBaseUrl = process.env.EXPO_PUBLIC_AIRALO_BASE_URL;
const rawAiraloClientId = process.env.EXPO_PUBLIC_AIRALO_CLIENT_ID;
const rawAiraloClientSecret = process.env.EXPO_PUBLIC_AIRALO_CLIENT_SECRET;
const rawAiraloMode = process.env.EXPO_PUBLIC_AIRALO_MODE;
const rawBackendUrl = process.env.EXPO_PUBLIC_BACKEND_URL;

function clean(value: string | undefined): string | undefined {
  if (!value) return undefined;
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : undefined;
}

export const runtimeConfig = {
  supabaseUrl: clean(rawSupabaseUrl),
  supabaseAnonKey: clean(rawSupabaseAnonKey),
  airaloBaseUrl: clean(rawAiraloBaseUrl) ?? 'https://sandbox-partners-api.airalo.com',
  airaloClientId: clean(rawAiraloClientId),
  airaloClientSecret: clean(rawAiraloClientSecret),
  airaloMode: clean(rawAiraloMode) ?? 'sandbox',
  backendUrl: clean(rawBackendUrl),
};

export const hasSupabaseConfig = Boolean(
  runtimeConfig.supabaseUrl && runtimeConfig.supabaseAnonKey,
);

export const hasAiraloConfig = Boolean(
  runtimeConfig.airaloClientId && runtimeConfig.airaloClientSecret,
);
