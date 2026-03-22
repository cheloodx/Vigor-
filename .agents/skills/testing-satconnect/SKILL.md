# SatConnect E2E Testing

## Overview
SatConnect is a React Native/Expo satellite connectivity app with 6 tabs, overlay screens, and authentication flows. Testing is done via Expo Web.

## Setup

1. Navigate to `/SatConnect` directory
2. Start Expo web server: `npx expo start --web --port 8082`
3. Wait for bundling to complete (~720 modules)
4. Open `http://localhost:8082` in browser
5. The app may show onboarding on first load - click "Sari peste" (Skip) to bypass
6. Use "Mod Demo" button on login screen to enter the app without real credentials

## Testable Features

### Tab 1: Acasa (Home)
- Header with username and connectivity badge
- Connection status card (Conectat/Deconectat)
- eSIM Global Plan card with data stats
- 6 connectivity tiles: WiFi, Date mobile, Roaming, Satelit (with BETA badge), eSIM, GPS
- SOS button (long press 3s to activate)
- Usage stats: Date folosite, Mesaje, Locatii, Zile ramase
- Quick Actions row
- Pull-to-refresh functionality

### Tab 2: Mesaje (Messages)
- 3 mock conversations with avatars
- Search bar filters by contact name or message text
- Click conversation to open ChatScreen overlay
- ChatScreen: send messages with status transitions (queued → sending → sent → delivered)
- Character count and size estimate shown below input
- Back arrow to close chat overlay

### Tab 3: Locatie (Location)
- Map display with location points
- Tracking status badge
- Stats: Total puncte, Sincronizate, In asteptare
- Istoric locatii list

### Tab 4: eSIM
- Country selection with popular grid (9 countries) and full list
- Search bar filters by country name or code
- Click country → plan selection with prices and features
- Click plan → activation flow (loading → success with ICCID)
- "Gata" button returns to country selection

### Tab 5: Planuri (Plans)
- 4 subscription plans: Free, Explorer, Pro, Business
- ACTUAL badge on current plan, POPULAR badge on Explorer
- Upgrade button triggers Alert dialog

### Tab 6: Profil (Profile)
- User info with avatar, name, email, badge
- Usage summary stats
- Menu sections: CONT, ESIM, APLICATIE
- Overlay screens: Setari, Contacte, Termeni & Conditii, Confidentialitate
- Deconectare (logout) button
- Version info at bottom

### Settings Overlay
- APARENTA: Mod intunecat toggle
- NOTIFICARI: Push, Alerte consum, Alerte roaming toggles
- SECURITATE: Biometric auth, Change password, 2FA
- GENERAL: Auto-sync, WiFi only, Analytics toggles
- DESPRE: Version, Terms, Privacy, Licenses
- ZONA PERICULOASA: Delete account

### Authentication Flow
- Onboarding → Login → Main app
- Login screen: Email/Password fields, "Mod Demo" button, "Creeaza cont", "Am uitat parola"
- Clear localStorage to reset to onboarding state
- Demo login bypasses real auth

## Known Limitations

- **Alert dialogs on web**: React Native's `Alert.alert` uses `window.confirm` on web, which may be auto-accepted by browser automation. To test logout flow, clear localStorage manually via browser console instead.
- **Diacritics in search**: Search is exact match, so searching "tabara" won't match "tabăra" (with Romanian diacritics). Search by contact name instead.
- **Animated transitions**: eSIM step transitions use Animated.timing which works on web but may be subtle.
- **Pull-to-refresh**: Works on web but may require precise scroll-up gesture from top.

## Devin Secrets Needed
- SUPABASE_EMAIL - Supabase dashboard login
- SUPABASE_PASSWORD - Supabase dashboard password
- SUPABASE_ACCESS_TOKEN - Supabase Management API token
- SUPABASE_DB_PASSWORD - Database password for SQL migrations
- ESIM_RESELLER_EMAIL - eSIM reseller platform login
- ESIM_RESELLER_PASSWORD - eSIM reseller platform password
