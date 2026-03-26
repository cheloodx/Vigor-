# Testing SatConnect Payment Flow

## Overview
SatConnect is an eSIM storefront hosted at https://satconnect.net. The backend is Express.js running on a Hetzner server (46.224.164.70) behind nginx reverse proxy. Payments are processed via Stripe Checkout.

## Architecture
- **Frontend**: Static HTML/CSS/JS served by Express from `backend/public/`
- **Backend**: Express.js on port 3001, proxied by nginx on port 443 (HTTPS via Let's Encrypt)
- **Payments**: Stripe Checkout Sessions with redirect flow
- **eSIM Provider**: eSIM Access API (replaced Airalo)
- **Database**: Supabase (non-blocking - checkout works even if Supabase is down)

## Deployment
- SSH: `ssh -i /home/ubuntu/.ssh/hetzner_satconnect root@46.224.164.70`
- Backend runs via PM2: `pm2 restart satconnect-backend`
- Deploy steps: build locally (`npm run build`), rsync dist + public + node_modules to server, restart PM2
- nginx config: `/etc/nginx/sites-available/satconnect.net`
- SSL: Let's Encrypt via certbot

## Key Endpoints to Test

### 1. Plans API
```bash
curl -s https://satconnect.net/api/plans | python3 -m json.tool | head -50
```
Expect: JSON with countries array, each having plans with id, data, price, validity.

### 2. Checkout Redirect (Critical)
```bash
curl -s -D - "https://satconnect.net/api/stripe/checkout-redirect?planId=ro-1gb&returnUrl=https%3A%2F%2Fsatconnect.net" 2>&1 | head -20
```
Expect: 303 redirect to `checkout.stripe.com`. The `Location` header must point to Stripe, NOT to an IP address.

### 3. Verify success_url in Stripe Session
SSH to server and check the latest Stripe session:
```bash
ssh -i /home/ubuntu/.ssh/hetzner_satconnect root@46.224.164.70 'source /root/backend/.env && curl -s "https://api.stripe.com/v1/checkout/sessions?limit=1" -u "$STRIPE_SECRET_KEY:"' | python3 -c "
import json, sys
d = json.load(sys.stdin)
s = d['data'][0]
print('success_url:', s['success_url'])
print('cancel_url:', s['cancel_url'])
"
```
Expect: `success_url` starts with `https://satconnect.net/payment-success.html`, NOT `http://46.224.164.70`.

### 4. Session Details API
```bash
curl -s "https://satconnect.net/api/stripe/session/{SESSION_ID}" | python3 -m json.tool
```
Expect: JSON with status, planId, countryName, dataLabel, amountTotal, currency.

## UI Testing Flow

1. **Storefront** (https://satconnect.net): Verify 179 countries load, search autocomplete works, plan modal shows correct prices
2. **Checkout**: Select a plan, click buy, verify redirect to `checkout.stripe.com` (not HTTP IP)
3. **Payment Success** (payment-success.html?session_id=...): Should show loading animation then eSIM details (dark theme, not blank)
4. **Payment Cancel** (payment-cancel.html): Should show "Plata anulata" message with back button

## Known Caveats

- **Already-provisioned sessions**: If you test payment-success.html with a session that already had an eSIM provisioned, the page will show a timeout. This is expected - use a fresh session for full flow testing.
- **Live Stripe keys**: The production site uses live Stripe keys (`sk_live_*`). Do NOT complete real payments during testing unless authorized. You can verify the checkout redirect without paying.
- **FRONTEND_URL**: This env var in `.env` MUST be `https://satconnect.net`. If it's set to an IP address or wrong domain, Stripe will redirect users to the wrong URL after payment, causing a blank page.
- **trust proxy**: Express must have `app.set('trust proxy', 1)` for `req.protocol` and `req.get('host')` to work correctly behind nginx.
- **Cold cache**: After server restart, the plan cache may be empty. The storefront fetches /api/plans which warms the cache, so by checkout time it should be populated.

## Devin Secrets Needed
- `HETZNER_SATCONNECT_SSH_KEY` - SSH private key for Hetzner server access
- `STRIPE_SECRET_KEY` - Stripe live secret key (available on server at /root/backend/.env)
- `ESIM_ACCESS_CODE` - eSIM Access API key (available on server at /root/backend/.env)
- `SUPABASE_URL` and `SUPABASE_SERVICE_KEY` - Supabase credentials
