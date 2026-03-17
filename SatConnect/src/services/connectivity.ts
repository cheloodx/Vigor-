import { ConnectivityState, ConnectionType } from '../types';
import { MOCK_CONNECTIVITY } from '../constants/data';

// Connectivity manager - monitors connection state and manages sync
class ConnectivityManager {
  private state: ConnectivityState;
  private listeners: Array<(state: ConnectivityState) => void> = [];

  constructor() {
    this.state = { ...MOCK_CONNECTIVITY };
  }

  getState(): ConnectivityState {
    return { ...this.state };
  }

  subscribe(listener: (state: ConnectivityState) => void): () => void {
    this.listeners.push(listener);
    return () => {
      this.listeners = this.listeners.filter((l) => l !== listener);
    };
  }

  private notify(): void {
    this.listeners.forEach((l) => l(this.getState()));
  }

  // Simulate connection type change (in production, this would use expo-network)
  setConnectionType(type: ConnectionType): void {
    this.state = {
      ...this.state,
      connectionType: type,
      isConnected: type !== 'none',
      signalStrength: type === 'none' ? 0 : type === 'satellite' ? 35 : type === 'wifi' ? 72 : 55,
      bandwidth: type === 'none' ? 0 : type === 'satellite' ? 256 : type === 'wifi' ? 2400 : 1200,
      latency: type === 'none' ? 0 : type === 'satellite' ? 600 : type === 'wifi' ? 120 : 200,
    };
    this.notify();
  }

  // Mark sync in progress
  setSyncing(isSyncing: boolean): void {
    this.state = {
      ...this.state,
      isSyncing,
      lastSyncAt: isSyncing ? this.state.lastSyncAt : new Date().toISOString(),
    };
    this.notify();
  }

  // Update pending sync count
  setPendingSync(count: number): void {
    this.state = { ...this.state, pendingSync: count };
    this.notify();
  }

  // Get human-readable connection description
  getConnectionLabel(): string {
    const labels: Record<ConnectionType, string> = {
      wifi: 'WiFi',
      cellular: 'Rețea mobilă',
      bluetooth: 'Bluetooth',
      satellite: 'Satelit',
      none: 'Deconectat',
    };
    return labels[this.state.connectionType];
  }

  // Get signal quality label
  getSignalQuality(): 'strong' | 'medium' | 'weak' | 'none' {
    if (this.state.signalStrength > 60) return 'strong';
    if (this.state.signalStrength > 30) return 'medium';
    if (this.state.signalStrength > 0) return 'weak';
    return 'none';
  }
}

export const connectivityManager = new ConnectivityManager();
