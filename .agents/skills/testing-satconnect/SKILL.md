# Testing SatConnect App

## Overview
SatConnect is a React Native (Expo) app for satellite-assisted communication. It uses mock data (no real backend) and can be tested via Expo web.

## Setup & Running

```bash
cd SatConnect
npm install
npx expo start --web --port 8082
```

- The app runs at `http://localhost:8082` (port may vary if occupied - Expo will prompt)
- Package version warnings about `@react-native-async-storage/async-storage`, `react-native-safe-area-context`, `react-native-screens` are cosmetic and do not block testing
- TypeScript check: `npx tsc --noEmit` (should pass with 0 errors)

## Navigation Structure

The app has a state-based navigation flow:
1. **Onboarding** (4 slides) → click "Skip" or swipe through
2. **Login** → enter any email/password (mock auth, accepts anything)
3. **Main tabs** (6 tabs at bottom):
   - **Acasă** (Home) - Dashboard with connectivity tiles, SOS button, usage stats
   - **Mesaje** (Messages) - Conversation list → tap to open ChatScreen overlay
   - **Locație** (Map) - GPS/location placeholder
   - **eSIM** - Virtual eSIM card management
   - **Planuri** (Plans) - Subscription plan cards
   - **Profil** (Profile) - User profile with logout

## Key Testing Areas

### Plans Screen
- Navigate via "Planuri" tab
- Verify plan count, names, prices, and feature lists
- The `currentPlan` in PlansScreen.tsx determines which plan shows "Planul tău" badge and disabled "Plan activ" button
- The `popular: true` plan gets a dark blue background with "Popular" badge

### HomeScreen Usage Cards
- "Date folosite" card shows data in GB format (computed from `MOCK_USAGE.dataUsedMB / 1024`)
- "Zile rămase" card shows subtitle with current plan name (hardcoded string in HomeScreen.tsx)
- 6 connectivity tiles: WiFi, Date mobile, Roaming Global, GPS Satelit, eSIM, GPS Local

### eSIM Screen
- Shows all cards from `MOCK_ESIM_CARDS` in data.ts
- Each card shows: data usage progress bar, price, ROAMING badge, Activ/Inactiv status
- Tapping an inactive card triggers activation (uses `window.confirm` on web instead of native Alert)
- Switching between active cards works without error alerts

## Known Limitations (Web Testing)
- `Alert.alert` renders as `window.confirm()` on Expo web (eSIM activation, logout, plan selection dialogs)
- Chat messages are ephemeral React state - navigating away resets them
- SOS button animation works but `onActivate` callback is a no-op
- No real network detection - connectivity tiles are decorative
- Onboarding/auth state persists in AsyncStorage between sessions; if app skips onboarding on reload, that's expected

## Data Files
- All mock data: `src/constants/data.ts` (PLANS, MOCK_USAGE, MOCK_ESIM_CARDS, etc.)
- Types: `src/types/index.ts`
- Theme/colors: `src/constants/theme.ts`

## Devin Secrets Needed
None - the app uses only mock data with no real backend or API keys.
