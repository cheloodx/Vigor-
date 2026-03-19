# Testing SatConnect App

## Overview
SatConnect is a React Native (Expo) mobile app located at `SatConnect/` in the repo. It uses TypeScript, React Navigation (bottom tabs + overlay pattern for chat), and mock data (no real backend).

## Local Setup
```bash
cd SatConnect
npm install
npx expo start --web --port 8084
```
The app will be available at `http://localhost:8084`. If port 8084 is in use, Expo will suggest an alternative.

## Navigation Flow
1. **Onboarding** (4 slides) - Click "Sari peste" (skip) or swipe through
2. **Login** - Enter any email/password, click "Conectează-te"
3. **Main Tabs** - 6 tabs: Acasă, Mesaje, Locație, eSIM, Planuri, Profil
4. **Chat** - Rendered as absolute overlay on top of tabs (preserves tab state)

## Key Screens to Test

### HomeScreen (Acasă tab)
- Connection status card at top
- "Conectivitate activă" panel with 6 tiles (WiFi, Date mobile, Roaming EU, GPS Satelit, eSIM, GPS Local)
- SOS button (hold to activate)
- Usage stats cards
- Quick actions row

### eSIM Screen (eSIM tab)
- 3 mock eSIM cards: România-Național (active), Europa-Roaming (active), Global-Satelit (inactive)
- Activation flow: tap card to switch/activate
- Active card shows teal border + "Activ acum" badge
- Switching between two active cards should work silently (no alert)
- Tapping the currently active card shows "este deja activă" alert
- Tapping inactive card shows activation confirmation dialog

### Plans Screen (Planuri tab)
- 3 plans: Starter (€1.99), Explorer (€4.99, popular), Global (€9.99)
- Explorer is marked as current plan ("Planul tău" + "Popular" badges)
- Selecting a different plan shows "coming soon" confirmation

## Known Web Limitations
- `Alert.alert()` renders as `window.confirm()` on Expo web - dialogs may auto-dismiss or behave differently than native iOS/Android
- SOS hold animation works but the callback is a no-op in HomeScreen
- Chat messages are ephemeral React state (not persisted)
- Android hardware back button handling not implemented (web/iOS only for now)

## TypeScript Check
```bash
cd SatConnect && npx tsc --noEmit
```
Should pass with 0 errors.

## Devin Secrets Needed
No secrets needed - app uses mock data only.
