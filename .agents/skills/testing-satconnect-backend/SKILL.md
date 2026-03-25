# Testing SatConnect Backend

## Overview
SatConnect backend is an Express.js + TypeScript server running on port 3001. It integrates with:
- **eSIM Access** (https://api.esimaccess.com) for eSIM provisioning
- **Stripe** for payment processing
- **Supabase** for database

## Prerequisites
- Node.js installed
- Backend directory: `SatConnect/backend/`
- `.env` file with `ESIM_ACCESS_CODE`, `STRIPE_SECRET_KEY`, `SUPABASE_URL`, `SUPABASE_SERVICE_KEY`

## Starting the Server
```bash
cd SatConnect/backend
npm install
unset STRIPE_SECRET_KEY  # Use .env file values, not shell env
npx ts-node src/index.ts
```
Expected output: `eSIM Access: REAL (API configured)` (not `MOCK`)

## Key Endpoints to Test

### 1. Health Check
```bash
curl -s http://localhost:3001/health
```
Expect: `{"status":"ok","services":{"esimaccess":"configured","stripe":"configured","supabase":"configured"}}`

### 2. Plans
```bash
curl -s http://localhost:3001/plans
```
Expect: `{"success":true,"data":{...}}` with country codes and plans

### 3. Stripe Checkout
```bash
curl -s -X POST http://localhost:3001/api/stripe/create-checkout \
  -H "Content-Type: application/json" \
  -d '{"planId":"ro-1gb","successUrl":"http://localhost/success","cancelUrl":"http://localhost/cancel"}'
```
Expect: `{"sessionId":"cs_live_...","url":"https://checkout.stripe.com/..."}`

### 4. Provisioning (requires paid session)
```bash
curl -s -X POST http://localhost:3001/api/orders/provision \
  -H "Content-Type: application/json" \
  -d '{"sessionId":"cs_live_..."}'
```
Without payment: expect `{"error":"Payment not confirmed..."}`

## eSIM Access API Direct Testing
```bash
# List packages for a country
curl -s -X POST https://api.esimaccess.com/api/v1/open/package/list \
  -H "RT-AccessCode: $ESIM_ACCESS_CODE" \
  -H "Content-Type: application/json" \
  -d '{"locationCode":"RO","type":"BASE"}'

# Check balance
curl -s -X POST https://api.esimaccess.com/api/v1/open/balance/query \
  -H "RT-AccessCode: $ESIM_ACCESS_CODE" \
  -H "Content-Type: application/json" -d '{}'
```

## Common Issues
- **STRIPE_SECRET_KEY env override**: If `STRIPE_SECRET_KEY` is set in shell env, it overrides `.env`. Use `unset STRIPE_SECRET_KEY` before starting.
- **Balance = 0**: Cannot test real eSIM orders without funds in eSIM Access account. Provisioning will fail gracefully.
- **eSIM Access prices**: Prices are in USD thousandths (e.g., 7000 = $7.00). Retail prices are typically 2x provider prices.
- **Profile polling**: eSIM Access allocates profiles asynchronously. After ordering, backend polls every 5s for up to 60s.
- **Old Airalo references**: `airalo.ts` file may still exist as dead code. Active code should only reference eSIM Access.

## Devin Secrets Needed
- `ESIM_ACCESS_CODE` - eSIM Access API access code
- `STRIPE_SECRET_KEY` - Stripe secret key (must start with `sk_live_` or `sk_test_`)
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_SERVICE_KEY` - Supabase service role key
