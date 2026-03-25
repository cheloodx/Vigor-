export const PLANS = [
  {
    id: 'basic',
    name: 'Basic',
    price: 29,
    currency: 'RON',
    period: 'lună',
    features: [
      '500 MB/zi',
      'Acces în 175 de țări',
      'Suport standard',
      '1 dispozitiv',
    ],
    popular: false,
  },
  {
    id: 'premium',
    name: 'Premium',
    price: 59,
    currency: 'RON',
    period: 'lună',
    features: [
      'Date nelimitate',
      'Acces în 175 de țări',
      'Suport prioritar 24/7',
      '3 dispozitive',
      'Viteză maximă',
    ],
    popular: true,
  },
  {
    id: 'family',
    name: 'Family',
    price: 99,
    currency: 'RON',
    period: 'lună',
    features: [
      'Date nelimitate',
      'Acces în 175 de țări',
      'Suport VIP',
      '5 dispozitive',
      'Viteză maximă',
      'Parental control',
    ],
    popular: false,
  },
];

export const STATS = [
  { label: 'Țări', value: '175' },
  { label: 'Utilizatori', value: '50K+' },
  { label: 'Hotspot-uri', value: '10K+' },
  { label: 'Uptime', value: '99.9%' },
];

export const FEATURES = [
  {
    icon: 'globe-outline' as const,
    title: 'Acoperire Globală',
    description: 'Conectează-te în 175 de țări din întreaga lume',
  },
  {
    icon: 'wifi-outline' as const,
    title: 'Conexiune Instant',
    description: 'Conectare automată la cel mai bun hotspot disponibil',
  },
  {
    icon: 'shield-checkmark-outline' as const,
    title: 'Securitate Maximă',
    description: 'Conexiune criptată și protejată în orice rețea',
  },
  {
    icon: 'flash-outline' as const,
    title: 'Viteză Maximă',
    description: 'Viteze de internet optime pentru orice activitate',
  },
];

export const COUNTRIES = [
  { name: 'România', flag: '🇷🇴' },
  { name: 'SUA', flag: '🇺🇸' },
  { name: 'UK', flag: '🇬🇧' },
  { name: 'Franța', flag: '🇫🇷' },
  { name: 'Germania', flag: '🇩🇪' },
  { name: 'Italia', flag: '🇮🇹' },
  { name: 'Spania', flag: '🇪🇸' },
  { name: 'Japonia', flag: '🇯🇵' },
];

export const HOTSPOTS = [
  { id: '1', name: 'Bucharest Central WiFi', latitude: 44.4268, longitude: 26.1025, signal: 'strong' as const, type: 'premium' as const },
  { id: '2', name: 'Cluj Innovation Hub', latitude: 46.7712, longitude: 23.6236, signal: 'strong' as const, type: 'premium' as const },
  { id: '3', name: 'Timișoara Tech Park', latitude: 45.7489, longitude: 21.2087, signal: 'medium' as const, type: 'basic' as const },
  { id: '4', name: 'Iași University WiFi', latitude: 47.1585, longitude: 27.6014, signal: 'strong' as const, type: 'premium' as const },
  { id: '5', name: 'Constanța Beach WiFi', latitude: 44.1598, longitude: 28.6348, signal: 'medium' as const, type: 'basic' as const },
  { id: '6', name: 'Brașov Mountain WiFi', latitude: 45.6427, longitude: 25.5887, signal: 'weak' as const, type: 'basic' as const },
  { id: '7', name: 'Paris Centre WiFi', latitude: 48.8566, longitude: 2.3522, signal: 'strong' as const, type: 'premium' as const },
  { id: '8', name: 'London City WiFi', latitude: 51.5074, longitude: -0.1278, signal: 'strong' as const, type: 'premium' as const },
  { id: '9', name: 'Berlin Hub WiFi', latitude: 52.5200, longitude: 13.4050, signal: 'medium' as const, type: 'basic' as const },
  { id: '10', name: 'New York Downtown', latitude: 40.7128, longitude: -74.0060, signal: 'strong' as const, type: 'premium' as const },
];

export const ONBOARDING_SLIDES = [
  {
    id: '1',
    title: 'Internet peste tot în lume',
    description: 'Conectează-te instant la mii de rețele Wi-Fi premium în 175 de țări.',
    icon: 'wifi',
  },
  {
    id: '2',
    title: 'Securitate Maximă',
    description: 'Conexiune criptată și protejată. Datele tale sunt în siguranță oriunde te-ai afla.',
    icon: 'shield-checkmark',
  },
  {
    id: '3',
    title: 'Simplu și Rapid',
    description: 'Plătește și conectează-te în câteva secunde, oriunde te-ai afla.',
    icon: 'flash',
  },
];
