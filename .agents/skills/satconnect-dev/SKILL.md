# SatConnect Development & Testing

## Project Setup

```bash
cd SatConnect
npm install
```

## Running the App

### Web (for quick testing)
```bash
npx expo start --web --port 8081
```
The app will be available at http://localhost:8081

### iOS (requires macOS with Xcode)
```bash
npx expo prebuild --platform ios
cd ios && pod install && cd ..
open ios/SatConnect.xcworkspace
```

### TypeScript Check
```bash
npx tsc --noEmit
```
Must pass with 0 errors before committing.

## Architecture

- **Navigation**: State-based with overlay pattern (not React Navigation stack). `AppNavigator.tsx` manages `overlayScreen` state for Settings, Terms, Privacy, Contacts screens. Chat uses separate `chatState`.
- **Tab bar**: 6 tabs - Acasă, Mesaje, Locație, eSIM, Planuri, Profil
- **Theme**: `ThemeContext` provides dark/light mode. Currently only wired into SettingsScreen; other screens use hardcoded `COLORS.*`.
- **i18n**: `LanguageContext` with Romanian (default) + English. Translation keys in `src/i18n/translations.ts`.
- **Storage**: AsyncStorage via `src/services/storage.ts` for user data, settings persistence.

## Key Directories

- `src/screens/` — All 15 screens
- `src/components/` — 6 reusable components (Button, ConnectivityBadge, MessageBubble, PlanCard, SOSButton, UsageCard)
- `src/services/` — 7 services (storage, connectivity, syncEngine, supabaseAuth, appleIAP, pushNotifications, esimProvisioning)
- `src/contexts/` — ThemeContext
- `src/i18n/` — LanguageContext + translations
- `src/constants/` — theme colors, mock data, types

## Testing on Expo Web — Known Limitations

1. **Alert.alert** renders as `window.confirm()` on web. CDP (Chrome DevTools Protocol) auto-dismisses these dialogs, making it impossible to test flows that require dialog confirmation:
   - Apple IAP purchase flow (confirm → purchase → success alert)
   - Contact delete (confirm dialog)
   - Logout (confirm dialog)
   - These flows MUST be tested on native iOS/Android.

2. **Push notifications** — `expo-notifications` scaffold only works on native devices.

3. **SOS button** — 3-second hold interaction is difficult to test with CDP automation.

4. **Map** — Uses a custom grid with positioned pins, not react-native-maps. Works on web.

## Mock Data & Services

All services are scaffolds with mock data:
- **Auth**: Login always succeeds with any email/password
- **Apple IAP**: Purchase always succeeds after 2-second simulated delay
- **eSIM**: 3 hardcoded cards (Europa, America & Asia, Global)
- **Plans**: 4 plans (Free €0, Explorer €1.99, Pro €3.99, Unlimited €6.99)
- **Contacts**: 6 default contacts, add/delete is React state only (not persisted)
- **Messages**: 3 conversations with mock data
- **GPS**: 5 location pins with mock coordinates

## Test Flow (Web)

1. Skip onboarding → Login with any credentials
2. HomeScreen: Verify 6 connectivity tiles, SOS button, usage cards
3. Messages: Test search filter and empty state
4. Chat: Open conversation, send message, verify tab preservation on return
5. Map: Verify pins, legend, coordinates, stats
6. eSIM: Verify 3 cards with pricing
7. Plans: Verify 4 plans with correct prices
8. Profile → Settings: Toggle dark mode, toggle language
9. Profile → Terms & Conditions / Privacy Policy: Verify content
10. Profile → Contacts: Search, add new contact

## Browser Setup for Testing

The Chrome binary is at `/opt/.devin/chrome/chrome/linux-137.0.7118.2/chrome-linux64/chrome`.

To launch Chrome with CDP support for testing:
```bash
/opt/.devin/chrome/chrome/linux-137.0.7118.2/chrome-linux64/chrome \
  --no-first-run --no-sandbox --disable-dev-shm-usage --disable-gpu \
  --remote-debugging-port=29229 --remote-allow-origins=* \
  --user-data-dir=/tmp/chrome-test-data \
  http://localhost:8081
```

The `google-chrome` wrapper at `~/.local/bin/google-chrome` uses `curl` to open URLs via CDP on port 29229 — it requires Chrome to already be running.
