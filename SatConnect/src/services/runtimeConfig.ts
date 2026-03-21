type EnvMap = Record<string, string | undefined>;

type GlobalWithProcess = typeof globalThis & {
  process?: {
    env?: EnvMap;
  };
};

const env = ((globalThis as GlobalWithProcess).process?.env ?? {}) as EnvMap;

function readEnv(name: string): string | undefined {
  const value = env[name];
  if (!value) {
    return undefined;
  }

  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : undefined;
}

export const runtimeConfig = {
  supabaseUrl: readEnv('EXPO_PUBLIC_SUPABASE_URL'),
  supabaseAnonKey: readEnv('EXPO_PUBLIC_SUPABASE_ANON_KEY'),
  airaloBaseUrl: readEnv('EXPO_PUBLIC_AIRALO_BASE_URL') ?? 'https://partners-api.airalo.com',
  airaloClientId: readEnv('EXPO_PUBLIC_AIRALO_CLIENT_ID'),
  airaloClientSecret: readEnv('EXPO_PUBLIC_AIRALO_CLIENT_SECRET'),
  airaloMode: readEnv('EXPO_PUBLIC_AIRALO_MODE') ?? 'sandbox',
  backendUrl: readEnv('EXPO_PUBLIC_BACKEND_URL'),
};

export const hasSupabaseConfig = Boolean(
  runtimeConfig.supabaseUrl && runtimeConfig.supabaseAnonKey,
);

export const hasAiraloConfig = Boolean(
  runtimeConfig.airaloClientId && runtimeConfig.airaloClientSecret,
);
