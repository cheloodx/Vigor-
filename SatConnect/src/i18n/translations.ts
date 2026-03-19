export type Language = 'ro' | 'en';

export interface Translations {
  // Common
  cancel: string;
  confirm: string;
  save: string;
  delete: string;
  back: string;
  ok: string;
  success: string;
  error: string;
  loading: string;
  search: string;

  // Tabs
  tabHome: string;
  tabMessages: string;
  tabLocation: string;
  tabEsim: string;
  tabPlans: string;
  tabProfile: string;

  // Home
  greeting: string;
  connected: string;
  disconnected: string;
  signal: string;
  pendingSync: string;
  lastSync: string;
  activeConnectivity: string;
  wifi: string;
  mobileData: string;
  roamingGlobal: string;
  gpsSatellite: string;
  esim: string;
  gpsLocal: string;
  usage: string;
  dataUsed: string;
  messagesSent: string;
  inQueue: string;
  locationsShared: string;
  daysRemaining: string;
  plan: string;
  quickActions: string;
  newMessage: string;
  sendLocation: string;
  sync: string;
  settings: string;
  holdSOS: string;

  // Messages
  messages: string;
  synced: string;
  noConversations: string;
  offlineMessages: string;
  now: string;
  you: string;
  unknown: string;
  searchMessages: string;
  noResults: string;

  // Plans
  plans: string;
  choosePlan: string;
  changePlan: string;
  currentPlan: string;
  activePlan: string;
  selectPlan: string;
  popular: string;
  yourPlan: string;
  needMore: string;
  contactUs: string;
  allPlansInclude: string;
  perMonth: string;

  // Profile
  editProfile: string;
  security: string;
  notifications: string;
  account: string;
  connectivity: string;
  satelliteDevices: string;
  bluetooth: string;
  synchronization: string;
  dataStorage: string;
  localData: string;
  dataCompression: string;
  enabled: string;
  disabled: string;
  clearCache: string;
  clearCacheConfirm: string;
  about: string;
  version: string;
  termsConditions: string;
  privacyPolicy: string;
  helpSupport: string;
  logout: string;
  logoutConfirm: string;
  unsyncedDataKept: string;

  // Settings
  settingsTitle: string;
  appearance: string;
  darkMode: string;
  darkModeDesc: string;
  language: string;
  languageDesc: string;
  notificationsSettings: string;
  pushNotifications: string;
  pushNotificationsDesc: string;
  sosAlerts: string;
  sosAlertsDesc: string;
  dataAlerts: string;
  dataAlertsDesc: string;
  dataAlertThreshold: string;
  securitySettings: string;
  biometricLogin: string;
  biometricDesc: string;
  autoLock: string;
  autoLockDesc: string;
  generalSettings: string;
  autoSync: string;
  autoSyncDesc: string;
  dataCompressor: string;
  dataCompressorDesc: string;
  wifiOnly: string;
  wifiOnlyDesc: string;

  // Login
  loginTitle: string;
  loginSubtitle: string;
  email: string;
  password: string;
  loginButton: string;
  noAccount: string;
  register: string;
  forgotPassword: string;

  // Register
  registerTitle: string;
  fullName: string;
  confirmPassword: string;
  registerButton: string;
  haveAccount: string;
  login: string;

  // Forgot Password
  forgotPasswordTitle: string;
  forgotPasswordDesc: string;
  sendResetLink: string;
  resetLinkSent: string;
  resetLinkSentDesc: string;
  backToLogin: string;

  // Terms
  termsTitle: string;
  privacyTitle: string;
  lastUpdated: string;
  acceptTerms: string;

  // Map
  locationGps: string;
  trackingActive: string;
  trackingStopped: string;
  gpsMap: string;
  lastLocation: string;
  accuracy: string;
  shareLocation: string;
  stopTracking: string;
  startTracking: string;
  totalPoints: string;
  synchronized: string;
  pending: string;
  locationHistory: string;
  inQueueSync: string;

  // eSIM
  esimVirtual: string;
  manageCards: string;
  activeConnection: string;
  noActiveEsim: string;
  connectivityModes: string;
  myEsimCards: string;
  activateEsim: string;
  activateConfirm: string;
  activate: string;
  esimActive: string;
  esimAlreadyActive: string;
  addNewEsim: string;
  scanQr: string;
  manualCode: string;
  comingSoon: string;
  esimInfo: string;
  activeNow: string;

  // Contacts
  contacts: string;
  addContact: string;
  editContact: string;
  deleteContact: string;
  deleteContactConfirm: string;
  contactName: string;
  contactEmail: string;
  contactPhone: string;
  noContacts: string;

  // Data alerts
  dataAlertTitle: string;
  dataAlertMessage80: string;
  dataAlertMessage90: string;
  dataAlertMessage100: string;

  // Apple IAP
  purchasePlan: string;
  restorePurchases: string;
  purchaseSuccess: string;
  purchaseFailed: string;
  subscriptionActive: string;
  manageSubscription: string;
}

const ro: Translations = {
  cancel: 'Anulează',
  confirm: 'Confirmă',
  save: 'Salvează',
  delete: 'Șterge',
  back: 'Înapoi',
  ok: 'OK',
  success: 'Succes',
  error: 'Eroare',
  loading: 'Se încarcă...',
  search: 'Caută',

  tabHome: 'Acasă',
  tabMessages: 'Mesaje',
  tabLocation: 'Locație',
  tabEsim: 'eSIM',
  tabPlans: 'Planuri',
  tabProfile: 'Profil',

  greeting: 'Bună ziua!',
  connected: 'Conectat',
  disconnected: 'Deconectat',
  signal: 'semnal',
  pendingSync: 'elemente în așteptare',
  lastSync: 'Ultima sincronizare',
  activeConnectivity: 'Conectivitate activă',
  wifi: 'WiFi',
  mobileData: 'Date mobile',
  roamingGlobal: 'Roaming Global',
  gpsSatellite: 'GPS Satelit',
  esim: 'eSIM',
  gpsLocal: 'GPS Local',
  usage: 'Utilizare',
  dataUsed: 'Date folosite',
  messagesSent: 'Mesaje trimise',
  inQueue: 'în coadă',
  locationsShared: 'Locații partajate',
  daysRemaining: 'Zile rămase',
  plan: 'plan',
  quickActions: 'Acțiuni rapide',
  newMessage: 'Mesaj nou',
  sendLocation: 'Trimite locația',
  sync: 'Sincronizează',
  settings: 'Setări',
  holdSOS: 'Ține apăsat 3 secunde',

  messages: 'Mesaje',
  synced: 'Sincronizat',
  noConversations: 'Nicio conversație încă',
  offlineMessages: 'Mesajele tale se salvează offline și se sincronizează automat',
  now: 'Acum',
  you: 'Tu',
  unknown: 'Necunoscut',
  searchMessages: 'Caută în mesaje...',
  noResults: 'Niciun rezultat',

  plans: 'Planuri',
  choosePlan: 'Alege planul potrivit pentru nevoile tale de conectivitate',
  changePlan: 'Schimbă planul',
  currentPlan: 'Planul curent',
  activePlan: 'Plan activ',
  selectPlan: 'Alege planul',
  popular: 'Popular',
  yourPlan: 'Planul tău',
  needMore: 'Ai nevoie de mai mult?',
  contactUs: 'Contactează-ne pentru planuri personalizate pentru echipe și business.',
  allPlansInclude: 'Toate planurile includ buton SOS de urgență și criptare end-to-end.',
  perMonth: 'lună',

  editProfile: 'Editează profilul',
  security: 'Securitate',
  notifications: 'Notificări',
  account: 'Cont',
  connectivity: 'Conectivitate',
  satelliteDevices: 'Dispozitive satelit',
  bluetooth: 'Bluetooth',
  synchronization: 'Sincronizare',
  dataStorage: 'Date & Stocare',
  localData: 'Date locale',
  dataCompression: 'Compresie date',
  enabled: 'Activată',
  disabled: 'Dezactivat',
  clearCache: 'Șterge cache-ul',
  clearCacheConfirm: 'Ești sigur? Datele nesincronizate vor fi pierdute.',
  about: 'Despre',
  version: 'Versiune',
  termsConditions: 'Termeni și condiții',
  privacyPolicy: 'Politica de confidențialitate',
  helpSupport: 'Ajutor & Suport',
  logout: 'Deconectează-te',
  logoutConfirm: 'Ești sigur că vrei să te deconectezi? Datele nesincronizate vor fi păstrate local.',
  unsyncedDataKept: 'Datele nesincronizate vor fi păstrate local.',

  settingsTitle: 'Setări',
  appearance: 'Aspect',
  darkMode: 'Mod întunecat',
  darkModeDesc: 'Activează tema întunecată pentru economie de baterie',
  language: 'Limbă',
  languageDesc: 'Schimbă limba aplicației',
  notificationsSettings: 'Notificări',
  pushNotifications: 'Notificări push',
  pushNotificationsDesc: 'Primește notificări pentru mesaje noi',
  sosAlerts: 'Alerte SOS',
  sosAlertsDesc: 'Alertele SOS sunt întotdeauna active',
  dataAlerts: 'Alerte consum date',
  dataAlertsDesc: 'Primește alertă când datele sunt aproape consumate',
  dataAlertThreshold: 'Prag alertă date',
  securitySettings: 'Securitate',
  biometricLogin: 'Autentificare biometrică',
  biometricDesc: 'Folosește Face ID / Touch ID la login',
  autoLock: 'Blocare automată',
  autoLockDesc: 'Blochează aplicația după 5 minute de inactivitate',
  generalSettings: 'General',
  autoSync: 'Sincronizare automată',
  autoSyncDesc: 'Sincronizează datele automat când ai conexiune',
  dataCompressor: 'Compresie date',
  dataCompressorDesc: 'Comprimă mesajele pentru a economisi date',
  wifiOnly: 'Doar WiFi',
  wifiOnlyDesc: 'Sincronizează doar pe WiFi pentru a economisi date mobile',

  loginTitle: 'SatConnect',
  loginSubtitle: 'Conectat oriunde, oricând',
  email: 'Email',
  password: 'Parolă',
  loginButton: 'Conectează-te',
  noAccount: 'Nu ai cont?',
  register: 'Înregistrează-te',
  forgotPassword: 'Am uitat parola',

  registerTitle: 'Creează cont',
  fullName: 'Nume complet',
  confirmPassword: 'Confirmă parola',
  registerButton: 'Creează contul',
  haveAccount: 'Ai deja cont?',
  login: 'Conectează-te',

  forgotPasswordTitle: 'Recuperare parolă',
  forgotPasswordDesc: 'Introdu adresa de email asociată contului tău și îți vom trimite un link pentru resetarea parolei.',
  sendResetLink: 'Trimite link de resetare',
  resetLinkSent: 'Email trimis!',
  resetLinkSentDesc: 'Verifică emailul pentru linkul de resetare a parolei. Poate dura câteva minute.',
  backToLogin: 'Înapoi la login',

  termsTitle: 'Termeni și Condiții',
  privacyTitle: 'Politica de Confidențialitate',
  lastUpdated: 'Ultima actualizare',
  acceptTerms: 'Accept termenii și condițiile',

  locationGps: 'Locație & GPS',
  trackingActive: 'Tracking activ',
  trackingStopped: 'Tracking oprit',
  gpsMap: 'Hartă GPS',
  lastLocation: 'Ultima locație',
  accuracy: 'Precizie',
  shareLocation: 'Partajează locația',
  stopTracking: 'Oprește tracking',
  startTracking: 'Pornește tracking',
  totalPoints: 'Total puncte',
  synchronized: 'Sincronizate',
  pending: 'În așteptare',
  locationHistory: 'Istoric locații',
  inQueueSync: 'În coadă',

  esimVirtual: 'eSIM Virtual',
  manageCards: 'Gestionează cartelele tale digitale',
  activeConnection: 'Conexiune activă',
  noActiveEsim: 'Niciun eSIM activ',
  connectivityModes: 'Moduri de conectivitate',
  myEsimCards: 'Cartelele mele eSIM',
  activateEsim: 'Activează eSIM',
  activateConfirm: 'Dorești să activezi',
  activate: 'Activează',
  esimActive: 'eSIM Activ',
  esimAlreadyActive: 'este deja activă și în uz.',
  addNewEsim: 'Adaugă eSIM nou',
  scanQr: 'Scanează QR',
  manualCode: 'Cod manual',
  comingSoon: 'Coming soon',
  esimInfo: 'eSIM-ul virtual îți permite să ai internet în 175+ țări fără cartelă fizică. Activează planul potrivit pentru destinația ta.',
  activeNow: 'Activ acum',

  contacts: 'Contacte',
  addContact: 'Adaugă contact',
  editContact: 'Editează contact',
  deleteContact: 'Șterge contact',
  deleteContactConfirm: 'Ești sigur că vrei să ștergi acest contact?',
  contactName: 'Nume',
  contactEmail: 'Email',
  contactPhone: 'Telefon',
  noContacts: 'Niciun contact',

  dataAlertTitle: 'Alertă consum date',
  dataAlertMessage80: 'Ai consumat 80% din datele planului tău. Mai ai {remaining} disponibil.',
  dataAlertMessage90: 'Ai consumat 90% din datele planului tău. Consideră upgrade-ul la un plan superior.',
  dataAlertMessage100: 'Ai consumat toate datele planului tău. Fă upgrade pentru a continua navigarea.',

  purchasePlan: 'Cumpără planul',
  restorePurchases: 'Restaurează cumpărăturile',
  purchaseSuccess: 'Achiziție reușită! Planul tău a fost activat.',
  purchaseFailed: 'Achiziția a eșuat. Încearcă din nou.',
  subscriptionActive: 'Abonament activ',
  manageSubscription: 'Gestionează abonamentul',
};

const en: Translations = {
  cancel: 'Cancel',
  confirm: 'Confirm',
  save: 'Save',
  delete: 'Delete',
  back: 'Back',
  ok: 'OK',
  success: 'Success',
  error: 'Error',
  loading: 'Loading...',
  search: 'Search',

  tabHome: 'Home',
  tabMessages: 'Messages',
  tabLocation: 'Location',
  tabEsim: 'eSIM',
  tabPlans: 'Plans',
  tabProfile: 'Profile',

  greeting: 'Good day!',
  connected: 'Connected',
  disconnected: 'Disconnected',
  signal: 'signal',
  pendingSync: 'items pending sync',
  lastSync: 'Last sync',
  activeConnectivity: 'Active connectivity',
  wifi: 'WiFi',
  mobileData: 'Mobile data',
  roamingGlobal: 'Global Roaming',
  gpsSatellite: 'GPS Satellite',
  esim: 'eSIM',
  gpsLocal: 'Local GPS',
  usage: 'Usage',
  dataUsed: 'Data used',
  messagesSent: 'Messages sent',
  inQueue: 'in queue',
  locationsShared: 'Locations shared',
  daysRemaining: 'Days remaining',
  plan: 'plan',
  quickActions: 'Quick actions',
  newMessage: 'New message',
  sendLocation: 'Send location',
  sync: 'Sync',
  settings: 'Settings',
  holdSOS: 'Hold 3 seconds',

  messages: 'Messages',
  synced: 'Synced',
  noConversations: 'No conversations yet',
  offlineMessages: 'Your messages are saved offline and sync automatically',
  now: 'Now',
  you: 'You',
  unknown: 'Unknown',
  searchMessages: 'Search messages...',
  noResults: 'No results',

  plans: 'Plans',
  choosePlan: 'Choose the right plan for your connectivity needs',
  changePlan: 'Change plan',
  currentPlan: 'Current plan',
  activePlan: 'Active plan',
  selectPlan: 'Select plan',
  popular: 'Popular',
  yourPlan: 'Your plan',
  needMore: 'Need more?',
  contactUs: 'Contact us for custom plans for teams and business.',
  allPlansInclude: 'All plans include SOS emergency button and end-to-end encryption.',
  perMonth: 'month',

  editProfile: 'Edit profile',
  security: 'Security',
  notifications: 'Notifications',
  account: 'Account',
  connectivity: 'Connectivity',
  satelliteDevices: 'Satellite devices',
  bluetooth: 'Bluetooth',
  synchronization: 'Synchronization',
  dataStorage: 'Data & Storage',
  localData: 'Local data',
  dataCompression: 'Data compression',
  enabled: 'Enabled',
  disabled: 'Disabled',
  clearCache: 'Clear cache',
  clearCacheConfirm: 'Are you sure? Unsynced data will be lost.',
  about: 'About',
  version: 'Version',
  termsConditions: 'Terms & Conditions',
  privacyPolicy: 'Privacy Policy',
  helpSupport: 'Help & Support',
  logout: 'Log out',
  logoutConfirm: 'Are you sure you want to log out? Unsynced data will be kept locally.',
  unsyncedDataKept: 'Unsynced data will be kept locally.',

  settingsTitle: 'Settings',
  appearance: 'Appearance',
  darkMode: 'Dark mode',
  darkModeDesc: 'Enable dark theme to save battery',
  language: 'Language',
  languageDesc: 'Change app language',
  notificationsSettings: 'Notifications',
  pushNotifications: 'Push notifications',
  pushNotificationsDesc: 'Receive notifications for new messages',
  sosAlerts: 'SOS alerts',
  sosAlertsDesc: 'SOS alerts are always active',
  dataAlerts: 'Data usage alerts',
  dataAlertsDesc: 'Get alerted when data is almost used up',
  dataAlertThreshold: 'Data alert threshold',
  securitySettings: 'Security',
  biometricLogin: 'Biometric login',
  biometricDesc: 'Use Face ID / Touch ID to log in',
  autoLock: 'Auto-lock',
  autoLockDesc: 'Lock app after 5 minutes of inactivity',
  generalSettings: 'General',
  autoSync: 'Auto sync',
  autoSyncDesc: 'Sync data automatically when connected',
  dataCompressor: 'Data compression',
  dataCompressorDesc: 'Compress messages to save data',
  wifiOnly: 'WiFi only',
  wifiOnlyDesc: 'Sync only on WiFi to save mobile data',

  loginTitle: 'SatConnect',
  loginSubtitle: 'Connected anywhere, anytime',
  email: 'Email',
  password: 'Password',
  loginButton: 'Log in',
  noAccount: "Don't have an account?",
  register: 'Register',
  forgotPassword: 'Forgot password',

  registerTitle: 'Create account',
  fullName: 'Full name',
  confirmPassword: 'Confirm password',
  registerButton: 'Create account',
  haveAccount: 'Already have an account?',
  login: 'Log in',

  forgotPasswordTitle: 'Password recovery',
  forgotPasswordDesc: 'Enter the email address associated with your account and we will send you a password reset link.',
  sendResetLink: 'Send reset link',
  resetLinkSent: 'Email sent!',
  resetLinkSentDesc: 'Check your email for the password reset link. It may take a few minutes.',
  backToLogin: 'Back to login',

  termsTitle: 'Terms & Conditions',
  privacyTitle: 'Privacy Policy',
  lastUpdated: 'Last updated',
  acceptTerms: 'I accept the terms and conditions',

  locationGps: 'Location & GPS',
  trackingActive: 'Tracking active',
  trackingStopped: 'Tracking stopped',
  gpsMap: 'GPS Map',
  lastLocation: 'Last location',
  accuracy: 'Accuracy',
  shareLocation: 'Share location',
  stopTracking: 'Stop tracking',
  startTracking: 'Start tracking',
  totalPoints: 'Total points',
  synchronized: 'Synchronized',
  pending: 'Pending',
  locationHistory: 'Location history',
  inQueueSync: 'In queue',

  esimVirtual: 'eSIM Virtual',
  manageCards: 'Manage your digital cards',
  activeConnection: 'Active connection',
  noActiveEsim: 'No active eSIM',
  connectivityModes: 'Connectivity modes',
  myEsimCards: 'My eSIM cards',
  activateEsim: 'Activate eSIM',
  activateConfirm: 'Do you want to activate',
  activate: 'Activate',
  esimActive: 'eSIM Active',
  esimAlreadyActive: 'is already active and in use.',
  addNewEsim: 'Add new eSIM',
  scanQr: 'Scan QR',
  manualCode: 'Manual code',
  comingSoon: 'Coming soon',
  esimInfo: 'The virtual eSIM lets you have internet in 175+ countries without a physical card. Activate the right plan for your destination.',
  activeNow: 'Active now',

  contacts: 'Contacts',
  addContact: 'Add contact',
  editContact: 'Edit contact',
  deleteContact: 'Delete contact',
  deleteContactConfirm: 'Are you sure you want to delete this contact?',
  contactName: 'Name',
  contactEmail: 'Email',
  contactPhone: 'Phone',
  noContacts: 'No contacts',

  dataAlertTitle: 'Data usage alert',
  dataAlertMessage80: 'You have used 80% of your plan data. You have {remaining} left.',
  dataAlertMessage90: 'You have used 90% of your plan data. Consider upgrading to a higher plan.',
  dataAlertMessage100: 'You have used all your plan data. Upgrade to continue browsing.',

  purchasePlan: 'Purchase plan',
  restorePurchases: 'Restore purchases',
  purchaseSuccess: 'Purchase successful! Your plan has been activated.',
  purchaseFailed: 'Purchase failed. Please try again.',
  subscriptionActive: 'Active subscription',
  manageSubscription: 'Manage subscription',
};

export const translations: Record<Language, Translations> = { ro, en };

export const LANGUAGE_NAMES: Record<Language, string> = {
  ro: 'Română',
  en: 'English',
};
