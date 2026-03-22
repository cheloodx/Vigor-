# Testing SatConnect (React Native / Expo)

## Quick Start

```bash
cd /home/ubuntu/repos/Vigor-/SatConnect
npx expo start --web --port 8082
```

Open `http://localhost:8082` in the browser to view the app.

## Port Conflicts

If port 8081/8082 is in use from a previous session, kill stale processes:
```bash
kill -9 $(lsof -ti:8082) 2>/dev/null; npx expo start --web --port 8082
```

## App Navigation Structure

The app uses a bottom tab bar with 6 tabs:
1. **Acasa** (Home) - Dashboard with connectivity tiles, SOS button, usage stats
2. **Mesaje** (Messages) - Conversation list with search
3. **Locatie** (Location) - Map/GPS tracking
4. **eSIM** - Country selection → plan selection → activation flow
5. **Planuri** (Plans) - Subscription tiers (Free, Explorer, Pro, Business)
6. **Profil** (Profile) - User info, menu sections, logout

## Overlay Screens

From the **Profil** tab, scroll down to the APLICATIE section to access:
- **Setari** (Settings) - Opens as full-screen overlay with back button
- **Contacte** - Opens as overlay
- **Termeni & Conditii** - Opens as overlay
- **Confidentialitate** - Opens as overlay

## Authentication Flow

The app starts with a demo/mock login. On Expo web, it auto-logs in with demo credentials. The login screen appears when:
- First launch (after onboarding)
- After logout (Profil → Deconectare)
- After session expiry (auth token cleared)

## Design System

- **Theme file**: `src/constants/theme.ts`
- **Primary color**: `#0A1628` (deep navy)
- **Accent color**: `#00D4AA` (teal/cyan)
- **Glass constants**: `GLASS.panel`, `GLASS.card`, `GLASS.cardActive`, `GLASS.tabBar`
- **Satellite color**: `#A78BFA` (purple) with BETA badge

## Key Things to Verify After UI Changes

1. Background color matches `COLORS.surface` (#0A1628) on redesigned screens
2. Glass panels have semi-transparent backgrounds with visible borders
3. Tab bar has glass effect (translucent dark, not solid)
4. Active tab icon uses accent color (#00D4AA)
5. BETA badge on Satelit connectivity tile (HomeScreen)
6. All MaterialCommunityIcons render (not blank) — check icon names at https://materialdesignicons.com

## Screens NOT Yet on Dark Theme

As of the glassmorphism redesign, these screens still use the original light theme:
- RegisterScreen, ForgotPasswordScreen, OnboardingScreen
- MapScreen, MessagesScreen, ChatScreen
- ContactsScreen, TermsScreen, PrivacyScreen

Navigating between dark and light screens will show a jarring theme switch — this is expected.

## TypeScript Verification

```bash
npx tsc --noEmit
```

Should return 0 errors. Run this before committing any changes.

## Devin Secrets Needed

- `SUPABASE_EMAIL` - Supabase dashboard login email
- `SUPABASE_PASSWORD` - Supabase dashboard login password
- `SUPABASE_DB_PASSWORD` - Database password for SQL migrations
- `SUPABASE_ACCESS_TOKEN` - Management API token
- `ESIM_RESELLER_EMAIL` - eSIM reseller portal login
- `ESIM_RESELLER_PASSWORD` - eSIM reseller portal password
