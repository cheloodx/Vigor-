# SatConnect Development & Testing

## Project Structure
- `SatConnect/` - React Native (Expo) frontend
- `SatConnect/backend/` - Express + TypeScript backend
- `SatConnect/landing-page/` - Vite + React landing page

## Local Development Setup

### Backend (port 3001)
```bash
cd SatConnect/backend
npm install
# Ensure .env has: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY, STRIPE_SECRET_KEY, STRIPE_PUBLISHABLE_KEY
npm run dev
```

### Frontend (Expo web, port 8082)
```bash
cd SatConnect
npm install
# Ensure .env has: EXPO_PUBLIC_BACKEND_URL=http://localhost:3001
npx expo start --web --port 8082
```

## Environment Variables
- Backend `.env`: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY, STRIPE_SECRET_KEY, STRIPE_PUBLISHABLE_KEY, STRIPE_WEBHOOK_SECRET, FRONTEND_URL, PORT
- Frontend `.env`: EXPO_PUBLIC_BACKEND_URL, EXPO_PUBLIC_SUPABASE_URL, EXPO_PUBLIC_SUPABASE_ANON_KEY
- Stripe keys are stored as saved secrets (STRIPE_SECRET_KEY)
- Supabase keys are stored as saved secrets (SUPABASE_ACCESS_TOKEN)

## Common Gotchas

### Shell env overrides .env file
If shell has stale environment variables (e.g. old STRIPE_SECRET_KEY), they override the .env file values. Fix:
```bash
unset STRIPE_SECRET_KEY && unset STRIPE_PUBLISHABLE_KEY && npm run dev
```

### Supabase schema must match Order interface
The `orders` table must have all 23 columns defined in `backend/src/services/supabase.ts` Order interface. If schema is out of date, use the Supabase Management API (`POST /v1/projects/{ref}/sql`) with the SUPABASE_ACCESS_TOKEN to ALTER TABLE.

Key columns: stripe_session_id, plan_id (text, NOT uuid), country_code, country_name, data_label, valid_days, price, currency, status, airalo_order_id, airalo_order_code, iccid, qrcode_url, lpa, matching_id, direct_apple_install_url, error_message, updated_at.

Old columns (amount, user_id, transaction_id) must be nullable since new code doesn't use them.

### Airalo demo mode
Without AIRALO_CLIENT_ID and AIRALO_CLIENT_SECRET, the backend runs in demo mode - creates mock eSIMs with placeholder ICCID and QR codes. This is sufficient for testing the payment flow.

## Testing the Payment Flow
1. Navigate to eSIM tab > select country > select plan
2. Click "Plateste securizat" - opens Stripe Checkout in new tab (web) or system browser (native)
3. Return to app - "Am platit - Verifica" button appears
4. Backend verifies payment status via Stripe API before provisioning
5. Without actual payment, status returns "unpaid" and provisioning is blocked (correct behavior)

## API Endpoints for Testing
```bash
# Create checkout session
curl -X POST http://localhost:3001/api/stripe/create-checkout -H 'Content-Type: application/json' -d '{"planId":"ro-1gb"}'

# Check payment status
curl http://localhost:3001/api/stripe/session/{sessionId}

# Provision eSIM (requires paid session)
curl -X POST http://localhost:3001/api/orders/provision -H 'Content-Type: application/json' -d '{"sessionId":"cs_..."}'
```

## Navigation Screens
6 bottom tabs: Acasa (Home), Mesaje, Locatie (GPS), eSIM, Planuri, Profil
Login screen has "Mod Demo" button for testing without authentication.
