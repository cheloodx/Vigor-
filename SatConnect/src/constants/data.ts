import { Plan, OnboardingSlide, Contact, Conversation, Message, UsageStats, ConnectivityState } from '../types';

export const PLANS: Plan[] = [
  {
    id: 'basic',
    name: 'Basic',
    price: 4.99,
    currency: 'EUR',
    period: 'lună',
    features: [
      '100 mesaje/lună',
      'Partajare locație de bază',
      'Buton SOS',
      '50 MB date satelit',
      '1 dispozitiv',
    ],
    popular: false,
    dataLimit: '50 MB',
    messagingLimit: '100 mesaje',
    trackingEnabled: false,
    sosEnabled: true,
  },
  {
    id: 'standard',
    name: 'Standard',
    price: 9.99,
    currency: 'EUR',
    period: 'lună',
    features: [
      'Mesaje nelimitate',
      'Tracking GPS în timp real',
      'Buton SOS prioritar',
      '200 MB date satelit',
      '3 dispozitive',
      'Sincronizare automată',
    ],
    popular: true,
    dataLimit: '200 MB',
    messagingLimit: 'Nelimitate',
    trackingEnabled: true,
    sosEnabled: true,
  },
  {
    id: 'premium',
    name: 'Premium',
    price: 19.99,
    currency: 'EUR',
    period: 'lună',
    features: [
      'Mesaje nelimitate',
      'Tracking GPS avansat',
      'SOS prioritar + apel vocal',
      '1 GB date satelit',
      '10 dispozitive',
      'Sincronizare prioritară',
      'API acces',
      'Suport dedicat 24/7',
    ],
    popular: false,
    dataLimit: '1 GB',
    messagingLimit: 'Nelimitate',
    trackingEnabled: true,
    sosEnabled: true,
  },
];

export const ONBOARDING_SLIDES: OnboardingSlide[] = [
  {
    id: '1',
    title: 'Conectat Oriunde',
    description: 'Comunică fără limite, chiar și în locuri fără semnal mobil. Sateliții te conectează cu lumea.',
    icon: 'satellite-variant',
  },
  {
    id: '2',
    title: 'Offline-First',
    description: 'Toate mesajele și locațiile se salvează local. Se sincronizează automat când apare conexiune.',
    icon: 'cloud-sync-outline',
  },
  {
    id: '3',
    title: 'SOS de Urgență',
    description: 'Trimite alerte de urgență cu locația ta exactă, chiar și fără internet. Siguranța ta e prioritatea noastră.',
    icon: 'alert-circle-outline',
  },
  {
    id: '4',
    title: 'Securitate Maximă',
    description: 'Mesajele sunt criptate end-to-end. Datele tale sunt protejate indiferent de tipul conexiunii.',
    icon: 'shield-lock-outline',
  },
];

export const MOCK_CONTACTS: Contact[] = [
  { id: '1', name: 'Maria Popescu', email: 'maria@example.com', isOnline: true, lastSeen: new Date().toISOString() },
  { id: '2', name: 'Andrei Ionescu', email: 'andrei@example.com', isOnline: false, lastSeen: '2026-03-17T15:30:00Z' },
  { id: '3', name: 'Elena Dumitrescu', email: 'elena@example.com', isOnline: true, lastSeen: new Date().toISOString() },
  { id: '4', name: 'Mihai Popa', email: 'mihai@example.com', isOnline: false, lastSeen: '2026-03-17T10:00:00Z' },
  { id: '5', name: 'Ana Stoica', email: 'ana@example.com', isOnline: false, lastSeen: '2026-03-16T20:00:00Z' },
  { id: '6', name: 'Echipa Salvare', email: 'rescue@satconnect.com', isOnline: true, lastSeen: new Date().toISOString() },
];

export const MOCK_CONVERSATIONS: Conversation[] = [
  {
    id: 'conv-1',
    participants: ['user', '1'],
    lastMessage: {
      id: 'msg-1',
      senderId: '1',
      receiverId: 'user',
      conversationId: 'conv-1',
      text: 'Am ajuns la tabăra de bază. Semnalul e slab dar funcționează!',
      timestamp: '2026-03-17T18:30:00Z',
      status: 'delivered',
      compressed: false,
      sizeBytes: 120,
    },
    unreadCount: 1,
    updatedAt: '2026-03-17T18:30:00Z',
  },
  {
    id: 'conv-2',
    participants: ['user', '2'],
    lastMessage: {
      id: 'msg-2',
      senderId: 'user',
      receiverId: '2',
      conversationId: 'conv-2',
      text: 'Locație trimisă via satelit.',
      timestamp: '2026-03-17T16:00:00Z',
      status: 'sent',
      compressed: true,
      sizeBytes: 45,
    },
    unreadCount: 0,
    updatedAt: '2026-03-17T16:00:00Z',
  },
  {
    id: 'conv-3',
    participants: ['user', '6'],
    lastMessage: {
      id: 'msg-3',
      senderId: '6',
      receiverId: 'user',
      conversationId: 'conv-3',
      text: 'Echipa de salvare a confirmat primirea alertei SOS.',
      timestamp: '2026-03-17T12:00:00Z',
      status: 'delivered',
      compressed: false,
      sizeBytes: 95,
    },
    unreadCount: 0,
    updatedAt: '2026-03-17T12:00:00Z',
  },
];

export const MOCK_MESSAGES: Message[] = [
  {
    id: 'msg-10',
    senderId: 'user',
    receiverId: '1',
    conversationId: 'conv-1',
    text: 'Salut Maria! Sunt pe munte, semnalul e slab.',
    timestamp: '2026-03-17T17:00:00Z',
    status: 'delivered',
    compressed: false,
    sizeBytes: 80,
  },
  {
    id: 'msg-11',
    senderId: '1',
    receiverId: 'user',
    conversationId: 'conv-1',
    text: 'Ai grijă! Trimite-mi locația din când în când.',
    timestamp: '2026-03-17T17:05:00Z',
    status: 'delivered',
    compressed: false,
    sizeBytes: 85,
  },
  {
    id: 'msg-12',
    senderId: 'user',
    receiverId: '1',
    conversationId: 'conv-1',
    text: '📍 Locație partajată: 45.5943° N, 24.2737° E (Vârful Moldoveanu)',
    timestamp: '2026-03-17T18:00:00Z',
    status: 'sent',
    compressed: true,
    sizeBytes: 60,
  },
  {
    id: 'msg-13',
    senderId: '1',
    receiverId: 'user',
    conversationId: 'conv-1',
    text: 'Am ajuns la tabăra de bază. Semnalul e slab dar funcționează!',
    timestamp: '2026-03-17T18:30:00Z',
    status: 'delivered',
    compressed: false,
    sizeBytes: 120,
  },
];

export const MOCK_USAGE: UsageStats = {
  dataUsedMB: 127,
  dataLimitMB: 200,
  messagesSent: 342,
  messagesQueued: 3,
  locationsShared: 58,
  sosAlertsSent: 0,
  lastConnectionType: 'wifi',
  totalSyncEvents: 156,
  planDaysRemaining: 18,
};

export const MOCK_CONNECTIVITY: ConnectivityState = {
  isConnected: true,
  connectionType: 'wifi',
  signalStrength: 72,
  bandwidth: 2400,
  latency: 120,
  isSyncing: false,
  pendingSync: 3,
  lastSyncAt: '2026-03-17T19:00:00Z',
};

export const CONNECTION_TYPE_LABELS: Record<string, string> = {
  wifi: 'WiFi',
  cellular: 'Mobil',
  bluetooth: 'Bluetooth',
  satellite: 'Satelit',
  none: 'Deconectat',
};

export const CONNECTION_TYPE_ICONS: Record<string, string> = {
  wifi: 'wifi',
  cellular: 'signal-cellular-alt',
  bluetooth: 'bluetooth',
  satellite: 'satellite-variant',
  none: 'wifi-off',
};
