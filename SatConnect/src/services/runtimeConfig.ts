// Expo inlines EXPO_PUBLIC_* at compile time via babel-preset-expo.
// We must access them as static member expressions for the transform to work.
const rawSupabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const rawSupabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;
// NOTE: Airalo credentials are intentionally NOT exposed to the client.
// All Airalo API calls go through the backend server.
const rawBackendUrl = process.env.EXPO_PUBLIC_BACKEND_URL;

function clean(value: string | undefined): string | undefined {
  if (!value) return undefined;
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : undefined;
}

export const runtimeConfig = {
  supabaseUrl: clean(rawSupabaseUrl),
  supabaseAnonKey: clean(rawSupabaseAnonKey),
  backendUrl: clean(rawBackendUrl),
};

export const hasSupabaseConfig = Boolean(
  runtimeConfig.supabaseUrl && runtimeConfig.supabaseAnonKey,
);

// Airalo config is backend-only; the frontend never has these credentials.
export const hasAiraloConfig = false;
