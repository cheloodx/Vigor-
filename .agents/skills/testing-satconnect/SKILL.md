# Testing SatConnect App

## Overview
SatConnect is a React Native (Expo) app for satellite connectivity. It can be tested locally via Expo web.

## Setup

```bash
cd SatConnect
npm install
npx expo start --web --port 8081
```

If port 8081 is busy, accept the alternate port suggestion (usually 8082).

The app loads at `http://localhost:8081` (or alternate port).

## Authentication

- The app starts on the **Login screen**
- Click **"Mod Demo"** to bypass authentication and enter demo mode
- Demo mode uses mock data for all services
- For real auth testing, Supabase credentials are needed (stored in `.env`)

## Navigation Structure

After login, the app uses a **bottom tab navigator** with 6 tabs:
1. **Acasa (Home)** - Dashboard with connectivity status, SOS button, usage cards
2. **Mesaje (Messages)** - Message list with search; clicking a message opens **ChatScreen** as overlay
3. **Locatie (Map)** - GPS tracking with map grid and location history
4. **eSIM** - Country selection with flags, plan selection, Stripe payment flow
5. **Planuri (Plans)** - Subscription plans (Free, Explorer, Pro, Business)
6. **Profil (Profile)** - User profile with links to overlay screens

**Overlay screens** (accessed from Profile > scroll down > APLICATIE section):
- **Setari (Settings)** - App settings with toggles
- **Contacte (Contacts)** - Contact management with add/edit/delete
- **Termeni & Conditii (Terms)** - Terms of service
- **Confidentialitate (Privacy)** - Privacy policy

## Dark Theme Verification

All screens should use:
- **Background**: Dark navy `#0A1628` (COLORS.surface)
- **Text**: Light `#F1F5F9` (COLORS.text)
- **Accent**: Teal `#00D4AA` (COLORS.accent)
- **Cards/Panels**: Semi-transparent glass effect (`rgba(255,255,255,0.06-0.08)`)
- **No white backgrounds** anywhere in the app

To verify dark theme, navigate through ALL tabs and overlay screens checking for any white backgrounds.

## Flag Rendering

Flags are displayed on the **eSIM screen**:
- Popular countries grid (top) shows 9 country cards with flag emojis
- Full country list (below) shows flags next to country names
- Flags are generated programmatically via `countryFlag()` function using Unicode regional indicator symbols
- This approach is more reliable than hardcoded emoji strings which can get corrupted during file encoding

**Note**: Flag emoji rendering depends on the platform. They render correctly on iOS, macOS, and modern browsers. On some Linux systems, flags may appear as letter pairs (e.g., "RO" instead of the Romanian flag).

## Stripe Payment Flow

The eSIM purchase flow requires backend configuration:
1. Select country on eSIM screen
2. Select a data plan
3. Payment confirmation screen appears
4. "Plateste securizat" opens Stripe Checkout
5. After payment, click "Am platit - Verifica" to verify

Without `EXPO_PUBLIC_BACKEND_URL` configured, clicking a plan shows "Configurare incompleta" alert.

## Devin Secrets Needed

- `SUPABASE_URL` - Supabase project URL (for real auth testing)
- `SUPABASE_ANON_KEY` - Supabase anonymous key (for real auth testing)
- `STRIPE_PUBLISHABLE_KEY` - Stripe publishable key (for payment testing)
- `STRIPE_SECRET_KEY` - Stripe secret key (for backend payment processing)

## Common Issues

- **Metro bundler cache**: If changes don't appear, restart with `npx expo start --clear`
- **Port conflicts**: Kill previous Expo processes or accept alternate port
- **Flags not showing on iOS**: Ensure `countryFlag()` is used instead of hardcoded emoji strings
- **White backgrounds**: Check for `COLORS.white` or `COLORS.gray[50]` in stylesheets - should be replaced with `COLORS.surface` or `GLASS.panel`/`GLASS.card`
