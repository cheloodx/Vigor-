// User types
export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  plan: PlanType;
  createdAt: string;
}

export type PlanType = 'free' | 'basic' | 'standard' | 'premium';

export interface Plan {
  id: PlanType;
  name: string;
  price: number;
  currency: string;
  period: string;
  features: string[];
  popular: boolean;
  dataLimit: string;
  messagingLimit: string;
  trackingEnabled: boolean;
  sosEnabled: boolean;
}

// Messaging types
export interface Message {
  id: string;
  senderId: string;
  receiverId: string;
  conversationId: string;
  text: string;
  timestamp: string;
  status: MessageStatus;
  compressed: boolean;
  sizeBytes: number;
}

export type MessageStatus = 'queued' | 'sending' | 'sent' | 'delivered' | 'failed';

export interface Conversation {
  id: string;
  participants: string[];
  lastMessage?: Message;
  unreadCount: number;
  updatedAt: string;
}

export interface Contact {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  avatar?: string;
  lastSeen?: string;
  isOnline: boolean;
}

// Location types
export interface LocationPoint {
  id: string;
  userId: string;
  latitude: number;
  longitude: number;
  altitude?: number;
  accuracy: number;
  timestamp: string;
  synced: boolean;
}

export interface SOSAlert {
  id: string;
  userId: string;
  latitude: number;
  longitude: number;
  timestamp: string;
  status: SOSStatus;
  message?: string;
  contacts: string[];
}

export type SOSStatus = 'queued' | 'sending' | 'sent' | 'acknowledged' | 'resolved';

// Connectivity types
export type ConnectionType = 'wifi' | 'cellular' | 'bluetooth' | 'satellite' | 'none';

export interface ConnectivityState {
  isConnected: boolean;
  connectionType: ConnectionType;
  signalStrength: number; // 0-100
  bandwidth: number; // kbps
  latency: number; // ms
  isSyncing: boolean;
  pendingSync: number;
  lastSyncAt?: string;
}

export interface SyncQueueItem {
  id: string;
  type: 'message' | 'location' | 'sos' | 'profile';
  data: string; // JSON serialized
  priority: number; // 1=highest (SOS), 5=lowest
  createdAt: string;
  retries: number;
  maxRetries: number;
}

// Usage types
export interface UsageStats {
  dataUsedMB: number;
  dataLimitMB: number;
  messagesSent: number;
  messagesQueued: number;
  locationsShared: number;
  sosAlertsSent: number;
  lastConnectionType: ConnectionType;
  totalSyncEvents: number;
  planDaysRemaining: number;
}

// Navigation types
export type RootStackParamList = {
  Onboarding: undefined;
  Login: undefined;
  Register: undefined;
  Main: undefined;
  Chat: { conversationId: string; contactName: string };
  SOSActive: undefined;
};

export type MainTabParamList = {
  Home: undefined;
  Messages: undefined;
  Map: undefined;
  Plans: undefined;
  Profile: undefined;
};

// Onboarding
export interface OnboardingSlide {
  id: string;
  title: string;
  description: string;
  icon: string;
}
