/**
 * eSIM Provisioning Service Scaffold
 * 
 * This scaffold provides the integration structure for real eSIM providers.
 * To activate with a real provider:
 * 1. Choose an eSIM provider API (e.g., Airalo, DENT, Truphone)
 * 2. Obtain API credentials
 * 3. Replace mock implementations with real API calls
 * 
 * Supported providers (scaffold):
 * - Airalo (airalo.com) - 200+ countries
 * - DENT (dentwireless.com) - eSIM data plans
 * - Truphone (truphone.com) - Global eSIM
 */

import AsyncStorage from '@react-native-async-storage/async-storage';

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

const PROFILES_KEY = '@satconnect_esim_profiles';

class ESIMProvisioningService {
  private profiles: ESIMProfile[] = [];
  private initialized = false;

  /**
   * Initialize the eSIM provisioning service.
   */
  async initialize(): Promise<void> {
    if (this.initialized) return;

    const stored = await AsyncStorage.getItem(PROFILES_KEY);
    if (stored) {
      this.profiles = JSON.parse(stored);
    }

    this.initialized = true;
  }

  /**
   * Get available eSIM plans from provider.
   * In production: calls provider API to get available plans.
   */
  async getAvailablePlans(region?: string): Promise<ESIMPlan[]> {
    // Mock delay simulating API call
    await new Promise((resolve) => setTimeout(resolve, 800));

    const plans: ESIMPlan[] = [
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

    if (region) {
      return plans.filter((p) => p.region.toLowerCase().includes(region.toLowerCase()));
    }

    return plans;
  }

  /**
   * Provision a new eSIM profile.
   * In production: calls provider API to create and provision eSIM.
   */
  async provisionESIM(planId: string): Promise<ProvisioningResult> {
    await new Promise((resolve) => setTimeout(resolve, 3000));

    const plans = await this.getAvailablePlans();
    const plan = plans.find((p) => p.id === planId);

    if (!plan) {
      return { success: false, error: 'Planul selectat nu a fost găsit' };
    }

    const profile: ESIMProfile = {
      id: `esim_${Date.now()}`,
      iccid: `894010${Date.now()}`,
      activationCode: `LPA:1$smdp.satconnect.app$${Math.random().toString(36).substring(2, 12).toUpperCase()}`,
      carrier: plan.provider,
      region: plan.region,
      countries: Array.from({ length: plan.countries }, (_, i) => `Country ${i + 1}`),
      dataLimitMB: plan.dataLimitMB,
      dataUsedMB: 0,
      validFrom: new Date().toISOString(),
      validUntil: new Date(Date.now() + plan.validDays * 24 * 60 * 60 * 1000).toISOString(),
      status: 'pending',
      qrCodeUrl: `https://api.satconnect.app/esim/qr/${Date.now()}`,
    };

    this.profiles.push(profile);
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));

    return { success: true, profile };
  }

  /**
   * Activate a provisioned eSIM.
   * In production: instructs the device to install the eSIM profile.
   */
  async activateESIM(profileId: string): Promise<ProvisioningResult> {
    await new Promise((resolve) => setTimeout(resolve, 2000));

    const profile = this.profiles.find((p) => p.id === profileId);
    if (!profile) {
      return { success: false, error: 'Profilul eSIM nu a fost găsit' };
    }

    if (profile.status === 'active') {
      return { success: false, error: 'eSIM-ul este deja activ' };
    }

    profile.status = 'active';
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));

    return { success: true, profile };
  }

  /**
   * Get all provisioned eSIM profiles.
   */
  getProfiles(): ESIMProfile[] {
    return [...this.profiles];
  }

  /**
   * Get active profile.
   */
  getActiveProfile(): ESIMProfile | null {
    return this.profiles.find((p) => p.status === 'active') ?? null;
  }

  /**
   * Check eSIM compatibility.
   * In production: checks if device supports eSIM.
   */
  async checkCompatibility(): Promise<{
    compatible: boolean;
    reason?: string;
  }> {
    // Mock - always compatible in scaffold
    return { compatible: true };
  }

  /**
   * Deactivate an eSIM profile.
   */
  async deactivateESIM(profileId: string): Promise<ProvisioningResult> {
    const profile = this.profiles.find((p) => p.id === profileId);
    if (!profile) {
      return { success: false, error: 'Profilul eSIM nu a fost găsit' };
    }

    profile.status = 'cancelled';
    await AsyncStorage.setItem(PROFILES_KEY, JSON.stringify(this.profiles));

    return { success: true, profile };
  }
}

export const esimProvisioning = new ESIMProvisioningService();
