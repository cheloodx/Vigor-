export const COLORS = {
  // Primary - Deep navy blue (Apple glassmorphism)
  primary: '#0A1628',
  primaryLight: '#1B2D4A',
  primaryDark: '#060E1A',

  // Accent - Satellite signal teal
  accent: '#00D4AA',
  accentLight: '#33DFBB',
  accentDark: '#00A888',

  // Status
  success: '#34D399',
  warning: '#FBBF24',
  error: '#F87171',
  info: '#60A5FA',

  // SOS
  sos: '#DC2626',
  sosLight: '#FEE2E2',

  // Signal strength
  signalStrong: '#34D399',
  signalMedium: '#FBBF24',
  signalWeak: '#F87171',
  signalNone: '#475569',

  // Connectivity
  online: '#34D399',
  offline: '#F87171',
  syncing: '#FBBF24',
  satellite: '#A78BFA',

  // Neutrals
  white: '#FFFFFF',
  black: '#000000',
  text: '#F1F5F9',
  textSecondary: '#94A3B8',
  textLight: '#64748B',
  surface: '#0A1628',
  border: 'rgba(255,255,255,0.08)',
  card: 'rgba(255,255,255,0.06)',

  // Glass
  glass: 'rgba(255,255,255,0.08)',
  glassBorder: 'rgba(255,255,255,0.12)',
  glassLight: 'rgba(255,255,255,0.04)',
  glassActive: 'rgba(255,255,255,0.15)',

  gray: {
    50: '#F8FAFC',
    100: '#F1F5F9',
    200: '#E2E8F0',
    300: '#CBD5E1',
    400: '#94A3B8',
    500: '#64748B',
    600: '#475569',
    700: '#334155',
    800: '#1E293B',
    900: '#0F172A',
  },
};

export const FONTS = {
  sizes: {
    xs: 11,
    sm: 13,
    md: 15,
    lg: 17,
    xl: 20,
    xxl: 28,
    xxxl: 36,
  },
};

export const SPACING = {
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  xxl: 32,
  xxxl: 48,
};

export const RADIUS = {
  sm: 8,
  md: 12,
  lg: 16,
  xl: 24,
  xxl: 32,
  full: 9999,
};

export const SHADOWS = {
  sm: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.15,
    shadowRadius: 3,
    elevation: 2,
  },
  md: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 4,
  },
  lg: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.25,
    shadowRadius: 16,
    elevation: 8,
  },
  glow: {
    shadowColor: '#00D4AA',
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.3,
    shadowRadius: 12,
    elevation: 6,
  },
};

export const GLASS = {
  panel: {
    backgroundColor: 'rgba(255,255,255,0.06)',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.10)',
  },
  card: {
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.12)',
  },
  cardActive: {
    backgroundColor: 'rgba(255,255,255,0.12)',
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.18)',
  },
  tabBar: {
    backgroundColor: 'rgba(10,22,40,0.92)',
    borderTopColor: 'rgba(255,255,255,0.08)',
    borderTopWidth: 0.5,
  },
};
