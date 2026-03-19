/**
 * Push Notifications Service Scaffold
 * 
 * This scaffold provides the setup for expo-notifications.
 * To activate:
 * 1. npx expo install expo-notifications expo-device expo-constants
 * 2. Configure push notification credentials in app.json
 * 3. Uncomment the real implementation sections
 */

import AsyncStorage from '@react-native-async-storage/async-storage';

export interface NotificationPreferences {
  pushEnabled: boolean;
  sosAlerts: boolean;
  messageAlerts: boolean;
  dataAlerts: boolean;
  dataAlertThreshold: number; // percentage (0-100)
  syncAlerts: boolean;
}

export interface PushNotification {
  id: string;
  title: string;
  body: string;
  data?: Record<string, unknown>;
  timestamp: string;
  read: boolean;
  type: 'message' | 'sos' | 'data_alert' | 'sync' | 'plan' | 'system';
}

const PREFS_KEY = '@satconnect_notification_prefs';
const NOTIFICATIONS_KEY = '@satconnect_notifications';
const PUSH_TOKEN_KEY = '@satconnect_push_token';

const DEFAULT_PREFS: NotificationPreferences = {
  pushEnabled: true,
  sosAlerts: true,
  messageAlerts: true,
  dataAlerts: true,
  dataAlertThreshold: 80,
  syncAlerts: false,
};

class PushNotificationService {
  private preferences: NotificationPreferences = DEFAULT_PREFS;
  private notifications: PushNotification[] = [];
  private pushToken: string | null = null;
  private initialized = false;

  /**
   * Initialize notification service.
   * In production: registers for push notifications with expo-notifications
   */
  async initialize(): Promise<boolean> {
    if (this.initialized) return true;

    // Load preferences
    const prefsStr = await AsyncStorage.getItem(PREFS_KEY);
    if (prefsStr) {
      this.preferences = JSON.parse(prefsStr);
    }

    // Load notification history
    const notifsStr = await AsyncStorage.getItem(NOTIFICATIONS_KEY);
    if (notifsStr) {
      this.notifications = JSON.parse(notifsStr);
    }

    // Load push token
    const token = await AsyncStorage.getItem(PUSH_TOKEN_KEY);
    if (token) {
      this.pushToken = token;
    }

    /**
     * Real implementation (uncomment when expo-notifications is installed):
     * 
     * import * as Notifications from 'expo-notifications';
     * import * as Device from 'expo-device';
     * import Constants from 'expo-constants';
     * 
     * if (Device.isDevice) {
     *   const { status: existingStatus } = await Notifications.getPermissionsAsync();
     *   let finalStatus = existingStatus;
     *   if (existingStatus !== 'granted') {
     *     const { status } = await Notifications.requestPermissionsAsync();
     *     finalStatus = status;
     *   }
     *   if (finalStatus !== 'granted') {
     *     return false;
     *   }
     *   const token = await Notifications.getExpoPushTokenAsync({
     *     projectId: Constants.expoConfig?.extra?.eas?.projectId,
     *   });
     *   this.pushToken = token.data;
     *   await AsyncStorage.setItem(PUSH_TOKEN_KEY, token.data);
     * }
     * 
     * Notifications.setNotificationHandler({
     *   handleNotification: async () => ({
     *     shouldShowAlert: true,
     *     shouldPlaySound: true,
     *     shouldSetBadge: true,
     *   }),
     * });
     */

    // Mock push token
    if (!this.pushToken) {
      this.pushToken = `ExponentPushToken[mock_${Date.now()}]`;
      await AsyncStorage.setItem(PUSH_TOKEN_KEY, this.pushToken);
    }

    this.initialized = true;
    return true;
  }

  /**
   * Get push token for backend registration.
   */
  getPushToken(): string | null {
    return this.pushToken;
  }

  /**
   * Update notification preferences.
   */
  async updatePreferences(prefs: Partial<NotificationPreferences>): Promise<void> {
    this.preferences = { ...this.preferences, ...prefs };
    await AsyncStorage.setItem(PREFS_KEY, JSON.stringify(this.preferences));
  }

  /**
   * Get current preferences.
   */
  getPreferences(): NotificationPreferences {
    return { ...this.preferences };
  }

  /**
   * Schedule a local notification.
   * In production: uses Notifications.scheduleNotificationAsync()
   */
  async scheduleLocalNotification(
    title: string,
    body: string,
    type: PushNotification['type'],
    data?: Record<string, unknown>,
  ): Promise<string> {
    const notification: PushNotification = {
      id: `notif_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`,
      title,
      body,
      data,
      timestamp: new Date().toISOString(),
      read: false,
      type,
    };

    this.notifications.unshift(notification);
    // Keep only last 100 notifications
    if (this.notifications.length > 100) {
      this.notifications = this.notifications.slice(0, 100);
    }
    await AsyncStorage.setItem(NOTIFICATIONS_KEY, JSON.stringify(this.notifications));

    return notification.id;
  }

  /**
   * Check data usage and send alert if threshold exceeded.
   */
  async checkDataUsageAlert(usedMB: number, limitMB: number): Promise<void> {
    if (!this.preferences.dataAlerts) return;

    const percentage = (usedMB / limitMB) * 100;
    const threshold = this.preferences.dataAlertThreshold;

    if (percentage >= 100) {
      await this.scheduleLocalNotification(
        'Alertă consum date',
        'Ai consumat toate datele planului tău. Fă upgrade pentru a continua.',
        'data_alert',
        { percentage: 100, usedMB, limitMB },
      );
    } else if (percentage >= 90) {
      await this.scheduleLocalNotification(
        'Alertă consum date',
        `Ai consumat 90% din datele planului. Mai ai ${((limitMB - usedMB) / 1024).toFixed(1)} GB.`,
        'data_alert',
        { percentage: 90, usedMB, limitMB },
      );
    } else if (percentage >= threshold) {
      await this.scheduleLocalNotification(
        'Alertă consum date',
        `Ai consumat ${Math.round(percentage)}% din datele planului. Mai ai ${((limitMB - usedMB) / 1024).toFixed(1)} GB.`,
        'data_alert',
        { percentage, usedMB, limitMB },
      );
    }
  }

  /**
   * Get all notifications.
   */
  getNotifications(): PushNotification[] {
    return [...this.notifications];
  }

  /**
   * Get unread count.
   */
  getUnreadCount(): number {
    return this.notifications.filter((n) => !n.read).length;
  }

  /**
   * Mark notification as read.
   */
  async markAsRead(notificationId: string): Promise<void> {
    const notif = this.notifications.find((n) => n.id === notificationId);
    if (notif) {
      notif.read = true;
      await AsyncStorage.setItem(NOTIFICATIONS_KEY, JSON.stringify(this.notifications));
    }
  }

  /**
   * Mark all as read.
   */
  async markAllAsRead(): Promise<void> {
    this.notifications.forEach((n) => { n.read = true; });
    await AsyncStorage.setItem(NOTIFICATIONS_KEY, JSON.stringify(this.notifications));
  }

  /**
   * Clear all notifications.
   */
  async clearAll(): Promise<void> {
    this.notifications = [];
    await AsyncStorage.setItem(NOTIFICATIONS_KEY, JSON.stringify(this.notifications));
  }
}

export const pushNotifications = new PushNotificationService();
