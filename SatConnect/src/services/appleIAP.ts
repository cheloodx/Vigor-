/**
 * Apple In-App Purchase Service Scaffold
 * 
 * This scaffold provides the UI flow and data structures for Apple IAP.
 * To activate with real purchases:
 * 1. npm install react-native-iap
 * 2. Configure products in App Store Connect
 * 3. Replace mock implementations with react-native-iap calls
 * 
 * Product IDs should match App Store Connect configuration.
 */

import AsyncStorage from '@react-native-async-storage/async-storage';

export interface IAPProduct {
  productId: string;
  title: string;
  description: string;
  price: string;
  currency: string;
  localizedPrice: string;
}

export interface IAPSubscription {
  productId: string;
  transactionId: string;
  purchaseDate: string;
  expiresDate: string;
  isActive: boolean;
  autoRenewing: boolean;
}

// Product IDs matching App Store Connect
export const PRODUCT_IDS = {
  FREE: 'com.satconnect.plan.free',
  EXPLORER: 'com.satconnect.plan.explorer',
  PRO: 'com.satconnect.plan.pro',
  UNLIMITED: 'com.satconnect.plan.unlimited',
} as const;

const IAP_STORAGE_KEY = '@satconnect_iap_subscription';

class AppleIAPService {
  private subscription: IAPSubscription | null = null;
  private products: IAPProduct[] = [];
  private initialized = false;

  /**
   * Initialize IAP connection.
   * In production: calls react-native-iap initConnection()
   */
  async initialize(): Promise<boolean> {
    if (this.initialized) return true;

    // Load cached subscription
    const stored = await AsyncStorage.getItem(IAP_STORAGE_KEY);
    if (stored) {
      this.subscription = JSON.parse(stored);
    }

    // Mock products (in production, fetch from App Store)
    this.products = [
      {
        productId: PRODUCT_IDS.FREE,
        title: 'Free',
        description: '3 GB date, mesaje nelimitate',
        price: '0',
        currency: 'EUR',
        localizedPrice: '€0.00',
      },
      {
        productId: PRODUCT_IDS.EXPLORER,
        title: 'Explorer',
        description: '100 GB date, roaming global, eSIM',
        price: '1.99',
        currency: 'EUR',
        localizedPrice: '€1.99',
      },
      {
        productId: PRODUCT_IDS.PRO,
        title: 'Pro',
        description: '500 GB date, 5G prioritar, VPN',
        price: '3.99',
        currency: 'EUR',
        localizedPrice: '€3.99',
      },
      {
        productId: PRODUCT_IDS.UNLIMITED,
        title: 'Unlimited',
        description: 'Internet nelimitat, family sharing',
        price: '6.99',
        currency: 'EUR',
        localizedPrice: '€6.99',
      },
    ];

    this.initialized = true;
    return true;
  }

  /**
   * Get available products from App Store.
   * In production: calls react-native-iap getSubscriptions()
   */
  async getProducts(): Promise<IAPProduct[]> {
    if (!this.initialized) await this.initialize();
    return this.products;
  }

  /**
   * Purchase a subscription.
   * In production: calls react-native-iap requestSubscription()
   */
  async purchaseSubscription(productId: string): Promise<{
    success: boolean;
    subscription?: IAPSubscription;
    error?: string;
  }> {
    if (!this.initialized) await this.initialize();

    // Simulate purchase flow (2 second delay for Apple payment sheet)
    await new Promise((resolve) => setTimeout(resolve, 2000));

    const product = this.products.find((p) => p.productId === productId);
    if (!product) {
      return { success: false, error: 'Produsul nu a fost găsit' };
    }

    // Mock successful purchase
    const subscription: IAPSubscription = {
      productId,
      transactionId: `txn_${Date.now()}`,
      purchaseDate: new Date().toISOString(),
      expiresDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
      isActive: true,
      autoRenewing: true,
    };

    this.subscription = subscription;
    await AsyncStorage.setItem(IAP_STORAGE_KEY, JSON.stringify(subscription));

    return { success: true, subscription };
  }

  /**
   * Restore previous purchases.
   * In production: calls react-native-iap getAvailablePurchases()
   */
  async restorePurchases(): Promise<{
    success: boolean;
    subscription?: IAPSubscription;
    error?: string;
  }> {
    if (!this.initialized) await this.initialize();

    await new Promise((resolve) => setTimeout(resolve, 1500));

    if (this.subscription && this.subscription.isActive) {
      return { success: true, subscription: this.subscription };
    }

    return { success: false, error: 'Nu au fost găsite achiziții anterioare' };
  }

  /**
   * Get current active subscription.
   */
  getActiveSubscription(): IAPSubscription | null {
    if (!this.subscription) return null;
    if (new Date(this.subscription.expiresDate) < new Date()) {
      this.subscription.isActive = false;
    }
    return this.subscription;
  }

  /**
   * Check if user has active subscription.
   */
  hasActiveSubscription(): boolean {
    const sub = this.getActiveSubscription();
    return sub !== null && sub.isActive;
  }

  /**
   * Get the product ID to plan type mapping.
   */
  getPlanTypeForProduct(productId: string): string {
    switch (productId) {
      case PRODUCT_IDS.FREE: return 'free';
      case PRODUCT_IDS.EXPLORER: return 'basic';
      case PRODUCT_IDS.PRO: return 'standard';
      case PRODUCT_IDS.UNLIMITED: return 'premium';
      default: return 'free';
    }
  }

  /**
   * Cleanup IAP connection.
   * In production: calls react-native-iap endConnection()
   */
  async cleanup(): Promise<void> {
    this.initialized = false;
  }
}

export const appleIAP = new AppleIAPService();
