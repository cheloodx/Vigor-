# Testing SatConnect MVP Backend

## Overview
The SatConnect backend is an Express + TypeScript server with 4 API endpoints, backed by Supabase (PostgreSQL) and Airalo eSIM integration. It runs on port 3001 by default.

## Devin Secrets Needed
- `SUPABASE_EMAIL` - Supabase dashboard login email
- `SUPABASE_PASSWORD` - Supabase dashboard login password
- `SUPABASE_ACCESS_TOKEN` - Supabase Management API access token (for running SQL migrations)
- `SUPABASE_DB_PASSWORD` - Supabase database password

## Setup

### 1. Install Dependencies
```bash
cd SatConnect/backend && npm install
```

### 2. Environment Configuration
The `.env` file should contain:
- `SUPABASE_URL` - Supabase project URL (e.g., `https://xxxxx.supabase.co`)
- `SUPABASE_ANON_KEY` - Supabase anon/public key
- `SUPABASE_SERVICE_KEY` - Supabase service role key
- `AIRALO_CLIENT_ID` / `AIRALO_CLIENT_SECRET` - Leave empty for mock mode
- `PORT` - Default 3001

### 3. Start Server
```bash
npm run dev
```
Expected output:
- `SatConnect backend running on port 3001`
- `Airalo: MOCK (no credentials)` (when Airalo credentials not set)
- `Supabase: configured`

### 4. Port Conflicts
If port 3001 is already in use from a previous session:
```bash
fuser -k 3001/tcp
```
Note: `lsof` may not be available on the VM, use `fuser` instead.

## Testing Endpoints

### Public Endpoints (no auth needed)
- `GET /health` - Returns `{"status": "ok", "airalo": "mock"}`
- `GET /plans` - Returns all 58 plans grouped by 22 country codes
- `GET /plans?country_code=RO` - Filter by country (Romania: 3 plans)
- `GET /plans?region=Europa` - Filter by region

### Authenticated Endpoints
Require `Authorization: Bearer <token>` header.

#### Getting a Test Auth Token
Sign up a test user via Supabase Auth REST API:
```bash
curl -s -X POST "https://<PROJECT_URL>/auth/v1/signup" \
  -H "apikey: <ANON_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"email": "test-<timestamp>@satconnect.test", "password": "TestPass123!"}'
```
The response contains `access_token` which is used as the Bearer token.

#### Authenticated Endpoint Tests
- `POST /orders/esim` - Create eSIM order (requires `{"plan_id": "<uuid>"}` in body)
  - Get valid plan_id from `GET /plans` response first
  - In mock mode: returns mock ICCID starting with `8940`, QR code via qrserver.com
- `GET /my-esims` - List user's provisioned eSIMs
- `GET /subscription/status` - Check subscription (returns `has_subscription: false` for new users)

## Mock vs Real Airalo Mode
- **Mock mode** (default when `AIRALO_CLIENT_ID`/`AIRALO_CLIENT_SECRET` are empty): Generates demo ICCIDs, QR codes via `api.qrserver.com`, activation codes like `SC-RO-XXXXX`
- **Real mode**: Calls Airalo sandbox API at `sandbox-partners-api.airalo.com/v2`

## Database Migration
If tables don't exist yet, run `sql/migration.sql` via Supabase Management API:
```bash
curl -s -X POST "https://api.supabase.com/v1/projects/<PROJECT_REF>/database/query" \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{"query": "<SQL_CONTENT>"}'
```
The migration is idempotent (safe to re-run). Creates 4 tables: `esim_plans`, `subscriptions`, `esim_orders`, `user_esims` + 58 seed plans.

## Known Issues / Gotchas
- Direct DB connection to Supabase may fail (IPv6 only, pooler auth issues). Use the Management API endpoint instead.
- Supabase dashboard login may be blocked by CAPTCHA. Get credentials (URL, keys) from the user directly rather than trying to log in via browser.
- The `sql/schema.sql` file is stale and uses old table names — always use `sql/migration.sql` instead.
- TypeScript check: use `npx --package=typescript tsc --noEmit` (not `npx tsc` which tries to install wrong package `tsc@2.0.4`).
