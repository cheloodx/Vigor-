import { SyncQueueItem } from '../types';
import { storage } from './storage';
import { connectivityManager } from './connectivity';

// Sync engine - manages offline queue and data synchronization
class SyncEngine {
  private isRunning = false;
  private intervalId: ReturnType<typeof setInterval> | null = null;

  // Add item to sync queue (offline-first)
  async enqueue(type: SyncQueueItem['type'], data: object, priority: number = 3): Promise<void> {
    const item: SyncQueueItem = {
      id: `sync-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      type,
      data: JSON.stringify(data),
      priority,
      createdAt: new Date().toISOString(),
      retries: 0,
      maxRetries: 5,
    };
    await storage.addToSyncQueue(item);
    connectivityManager.setPendingSync((await this.getQueueSize()));

    // Try to sync immediately if connected
    if (connectivityManager.getState().isConnected) {
      this.processQueue();
    }
  }

  // Process queued items (called when connection is available)
  async processQueue(): Promise<void> {
    if (this.isRunning) return;
    if (!connectivityManager.getState().isConnected) return;

    this.isRunning = true;
    connectivityManager.setSyncing(true);

    try {
      const queue = (await storage.getSyncQueue()) as SyncQueueItem[];
      // Sort by priority (1 = highest = SOS)
      const sorted = queue.sort((a, b) => a.priority - b.priority);

      for (const item of sorted) {
        try {
          await this.syncItem(item);
          await storage.removeSyncItem(item.id);
        } catch {
          // Item failed - increment retries
          if (item.retries < item.maxRetries) {
            item.retries++;
          }
          // If max retries, leave in queue for manual handling
        }
      }
    } finally {
      this.isRunning = false;
      connectivityManager.setSyncing(false);
      connectivityManager.setPendingSync(await this.getQueueSize());
    }
  }

  // Sync a single item to the server
  private async syncItem(item: SyncQueueItem): Promise<void> {
    // In production, this would make API calls to Supabase
    // For MVP, we simulate the sync
    const delay = connectivityManager.getState().connectionType === 'satellite' ? 2000 : 500;
    await new Promise((resolve) => setTimeout(resolve, delay));

    // Simulate occasional failures for satellite connections
    if (
      connectivityManager.getState().connectionType === 'satellite' &&
      Math.random() < 0.1
    ) {
      throw new Error('Satellite connection lost during sync');
    }
  }

  // Get queue size
  async getQueueSize(): Promise<number> {
    const queue = await storage.getSyncQueue();
    return queue.length;
  }

  // Start periodic sync check
  startPeriodicSync(intervalMs: number = 30000): void {
    if (this.intervalId) return;
    this.intervalId = setInterval(() => {
      this.processQueue();
    }, intervalMs);
  }

  // Stop periodic sync
  stopPeriodicSync(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  // Get compressed data size estimate
  estimateCompressedSize(data: string): number {
    // Simple estimation: compressed size is ~40% of original for text
    return Math.ceil(new TextEncoder().encode(data).length * 0.4);
  }
}

export const syncEngine = new SyncEngine();
