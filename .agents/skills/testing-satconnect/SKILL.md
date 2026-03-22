# SatConnect Testing Skills

## Local Development Setup

### Prerequisites
- Node.js 22+ (Node 20.x causes `styleText` errors with Expo)
- Backend runs on port 3001, Expo web on port 8082

### Environment Configuration

**Frontend (.env)**:
```
EXPO_PUBLIC_SUPABASE_URL=<supabase-url>
EXPO_PUBLIC_SUPABASE_ANON_KEY=<anon-key>
EXPO_PUBLIC_BACKEND_URL=http://localhost:3001
EXPO_PUBLIC_AIRALO_MODE=sandbox
```

**Backend (backend/.env)**:
```
SUPABASE_URL=<supabase-url>
SUPABASE_ANON_KEY=<anon-key>
SUPABASE_SERVICE_KEY=<service-key>
STRIPE_SECRET_KEY=<stripe-secret-key>
STRIPE_PUBLISHABLE_KEY=<stripe-publishable-key>
STRIPE_WEBHOOK_SECRET=<webhook-secret>
FRONTEND_URL=http://localhost:8082
PORT=3001
```

**Important**: `EXPO_PUBLIC_BACKEND_URL` must be set for the payment flow to appear. Without it, the app provisions eSIMs directly (demo mode) skipping the Stripe payment step.

### Starting Services

```bash
# Terminal 1: Backend
cd backend && npm install && npm run dev

# Terminal 2: Frontend (Expo web)
npm install && npx expo start --web --port 8082
```

### Devin Secrets Needed
- `SUPABASE_EMAIL` - Supabase dashboard login
- `SUPABASE_PASSWORD` - Supabase dashboard password
- `STRIPE_EMAIL` - Stripe dashboard login (${SUPABASE_EMAIL})
- `STRIPE_PASSWORD` - Stripe dashboard password
- Stripe Secret Key (not yet saved as secret - user needs to provide from Stripe dashboard)

## Testing the eSIM Payment Flow

### UI Flow Path
1. Open http://localhost:8082
2. Click "Mod Demo" to enter demo mode (or use Supabase auth if configured)
3. Click "eSIM" tab (4th icon in bottom nav)
4. Select a country (e.g., Romania)
5. Select a plan (e.g., 10 GB at €5.49)
6. **Payment confirmation screen** appears with plan details and "Plateste securizat" button
7. After clicking pay and returning from Stripe, button changes to "Am platit - Verifica"

### Payment Flow States
- **No backend URL configured**: Plan selection → direct provisioning (demo mode, no payment)
- **Backend configured, placeholder Stripe key**: Payment screen shows → clicking pay shows error alert → returns to plans
- **Backend configured, real Stripe key**: Payment screen → Stripe Checkout opens → after payment, click "Am platit - Verifica" → eSIM provisioned

### Server-Side Validation Testing (curl)
```bash
# Invalid plan → 400
curl -X POST localhost:3001/api/stripe/create-checkout \
  -H 'Content-Type: application/json' \
  -d '{"planId":"fake-plan"}'
# Expected: {"error":"Invalid plan ID"}

# Missing planId → 400
curl -X POST localhost:3001/api/stripe/create-checkout \
  -H 'Content-Type: application/json' \
  -d '{}'
# Expected: {"error":"Missing required field: planId"}

# Valid plan → passes validation (may fail on Stripe API if key is placeholder)
curl -X POST localhost:3001/api/stripe/create-checkout \
  -H 'Content-Type: application/json' \
  -d '{"planId":"ro-10gb"}'
# Expected: Stripe API error (not "Invalid plan ID")
```

## Common Issues

### Backend TypeScript Error: Stripe apiVersion
The Stripe npm package version determines which API version string is valid. For `stripe@14.x`, use `apiVersion: '2023-10-16'`. Using a newer version string like `'2024-04-10'` will cause a TypeScript compilation error.

### Expo Web Alert Behavior
`Alert.alert()` renders as `window.confirm()` on Expo web. The dialog may auto-dismiss quickly. On native iOS/Android, proper system dialogs appear.

### Node.js Version
Node 20.x causes `styleText is not a function` errors with newer Expo versions. Use Node 22+ via nvm.

### CAPTCHA on Stripe Dashboard
Stripe login has CAPTCHA that may block automated access. Ask the user for the Stripe Secret Key directly rather than trying to log into the dashboard.
