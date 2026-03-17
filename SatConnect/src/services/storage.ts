import AsyncStorage from '@react-native-async-storage/async-storage';

const KEYS = {
  AUTH_TOKEN: '@satconnect_auth_token',
  USER: '@satconnect_user',
  ONBOARDING_COMPLETE: '@satconnect_onboarding',
  SYNC_QUEUE: '@satconnect_sync_queue',
  MESSAGES: '@satconnect_messages',
  LOCATIONS: '@satconnect_locations',
  CONNECTIVITY: '@satconnect_connectivity',
};

export const storage = {
  // Auth
  async setAuthToken(token: string): Promise<void> {
    await AsyncStorage.setItem(KEYS.AUTH_TOKEN, token);
  },

  async getAuthToken(): Promise<string | null> {
    return AsyncStorage.getItem(KEYS.AUTH_TOKEN);
  },

  async removeAuthToken(): Promise<void> {
    await AsyncStorage.removeItem(KEYS.AUTH_TOKEN);
  },

  // User
  async setUser(user: object): Promise<void> {
    await AsyncStorage.setItem(KEYS.USER, JSON.stringify(user));
  },

  async getUser(): Promise<object | null> {
    const data = await AsyncStorage.getItem(KEYS.USER);
    return data ? JSON.parse(data) : null;
  },

  async removeUser(): Promise<void> {
    await AsyncStorage.removeItem(KEYS.USER);
  },

  // Onboarding
  async setOnboardingComplete(): Promise<void> {
    await AsyncStorage.setItem(KEYS.ONBOARDING_COMPLETE, 'true');
  },

  async isOnboardingComplete(): Promise<boolean> {
    const value = await AsyncStorage.getItem(KEYS.ONBOARDING_COMPLETE);
    return value === 'true';
  },

  // Sync Queue (offline-first)
  async getSyncQueue(): Promise<object[]> {
    const data = await AsyncStorage.getItem(KEYS.SYNC_QUEUE);
    return data ? JSON.parse(data) : [];
  },

  async addToSyncQueue(item: object): Promise<void> {
    const queue = await this.getSyncQueue();
    queue.push(item);
    await AsyncStorage.setItem(KEYS.SYNC_QUEUE, JSON.stringify(queue));
  },

  async clearSyncQueue(): Promise<void> {
    await AsyncStorage.setItem(KEYS.SYNC_QUEUE, JSON.stringify([]));
  },

  async removeSyncItem(id: string): Promise<void> {
    const queue = await this.getSyncQueue();
    const filtered = queue.filter((item: any) => item.id !== id);
    await AsyncStorage.setItem(KEYS.SYNC_QUEUE, JSON.stringify(filtered));
  },

  // Messages (offline cache)
  async getMessages(conversationId: string): Promise<object[]> {
    const data = await AsyncStorage.getItem(`${KEYS.MESSAGES}_${conversationId}`);
    return data ? JSON.parse(data) : [];
  },

  async saveMessages(conversationId: string, messages: object[]): Promise<void> {
    await AsyncStorage.setItem(`${KEYS.MESSAGES}_${conversationId}`, JSON.stringify(messages));
  },

  // Locations (offline cache)
  async getLocations(): Promise<object[]> {
    const data = await AsyncStorage.getItem(KEYS.LOCATIONS);
    return data ? JSON.parse(data) : [];
  },

  async addLocation(location: object): Promise<void> {
    const locations = await this.getLocations();
    locations.push(location);
    await AsyncStorage.setItem(KEYS.LOCATIONS, JSON.stringify(locations));
  },

  // Clear all
  async clearAll(): Promise<void> {
    const keys = [
      KEYS.AUTH_TOKEN,
      KEYS.USER,
      KEYS.ONBOARDING_COMPLETE,
      KEYS.SYNC_QUEUE,
      KEYS.MESSAGES,
      KEYS.LOCATIONS,
      KEYS.CONNECTIVITY,
    ];
    for (const key of keys) {
      await AsyncStorage.removeItem(key);
    }
  },
};
