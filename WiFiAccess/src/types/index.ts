export type RootStackParamList = {
  Onboarding: undefined;
  Auth: undefined;
  Login: undefined;
  Register: undefined;
  MainTabs: undefined;
};

export type MainTabParamList = {
  Home: undefined;
  Map: undefined;
  Plans: undefined;
  Profile: undefined;
};

export type Plan = {
  id: string;
  name: string;
  price: number;
  currency: string;
  period: string;
  features: string[];
  popular: boolean;
};

export type Hotspot = {
  id: string;
  name: string;
  latitude: number;
  longitude: number;
  signal: 'strong' | 'medium' | 'weak';
  type: 'premium' | 'basic';
};

export type User = {
  id: string;
  email: string;
  name: string;
  plan: string | null;
  devicesConnected: number;
  dataUsed: string;
};
