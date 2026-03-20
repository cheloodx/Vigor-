# Testing SatConnect App

## Overview
SatConnect is a React Native (Expo) app located in `SatConnect/` within the Vigor- repo. It supports WiFi, mobile data, roaming, satellite, eSIM connectivity.

## Local Testing Setup

### Starting the App
```bash
cd SatConnect
npm install
npx expo start --web --port 8082
```
The app runs at `http://localhost:8082`.

### DevTools Mobile Simulation
- Open Chrome DevTools (F12) and enable device simulation (e.g. iPhone SE 375x667)
- This gives a more realistic mobile layout for testing

## Auth Flow Testing (Mock Mode)

When no Supabase credentials are configured (`EXPO_PUBLIC_SUPABASE_URL` not set), the app uses mock auth:

- **Login**: Accepts any email/password. User name is derived from email prefix via `buildFallbackName()` (capitalizes first letter). E.g. `maria.ionescu@test.com` → name "Maria.ionescu"
- **Register**: Accepts any valid input. User name comes directly from the "Nume complet" form field, not email.
- **Forgot Password**: Returns success after ~1.2s delay, shows "Email trimis!" confirmation screen.
- **Session persistence**: Mock sessions are stored in AsyncStorage (localStorage on web). Clear localStorage to reset state.

## Navigation

The app uses bottom tab navigation with tabs: Acasa (Home), Mesaje, Locatie (Map), eSIM, Planuri, Profil.

### Known Issue: Tab Bar Off-Screen on Web
The React Native web layout may render the tab bar below the visible viewport, especially with DevTools open. Workarounds:
1. Use DevTools console to programmatically click tabs:
   ```js
   document.querySelectorAll('[role="tab"]').forEach(e => { if(e.textContent.includes('Profil')) e.click() })
   ```
2. Or scroll within the app content area to find the tab bar.

## Clearing State

To reset the app to fresh state (show onboarding again):
- In DevTools console: `localStorage.clear(); location.reload();`
- Or use Chrome's "Clear browsing data" (Ctrl+Shift+Delete → All time)

## Key Assertions for Auth Integration

1. After login with mock: HomeScreen greeting should show name derived from email prefix, NOT hardcoded "Ion Popescu"
2. After register with mock: HomeScreen greeting should show the name entered in the form
3. Profile tab should show the authenticated user's name, email, and correct initials (first letters of name words)
4. Forgot password should transition to success state showing "Email trimis!" after ~1.2s
5. Logout (from Profile screen → "Deconectaza-te") should clear session and return to login screen

## Environment Variables

For real backend testing (not mock):
- `EXPO_PUBLIC_SUPABASE_URL` - Supabase project URL
- `EXPO_PUBLIC_SUPABASE_ANON_KEY` - Supabase anon key
- `EXPO_PUBLIC_AIRALO_CLIENT_ID` - Airalo API client ID
- `EXPO_PUBLIC_AIRALO_CLIENT_SECRET` - Airalo API client secret

## Devin Secrets Needed

No secrets needed for mock mode testing. For real backend testing:
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key
- `AIRALO_CLIENT_ID` - Airalo sandbox client ID
- `AIRALO_CLIENT_SECRET` - Airalo sandbox client secret

## Xcode Testing

For iOS testing on Mac:
```bash
cd SatConnect
git pull
chmod +x setup-ios.sh
./setup-ios.sh
```
Then open Xcode, select iPhone simulator, and press Play. Node.js v20.11.1 on user's Mac may lack `util.styleText` - the setup script includes a polyfill for this.
