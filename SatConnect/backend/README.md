# SatConnect MVP Backend

Express + TypeScript + Supabase + Airalo eSIM API

## Architecture

```
backend/
├── sql/
│   └── schema.sql          # PostgreSQL schema (run in Supabase SQL editor)
├── src/
│   ├── index.ts             # Express server entry point
│   ├── config/
│   │   └── database.ts      # Supabase client
│   ├── middleware/
│   │   └── auth.ts          # JWT auth (validates Supabase tokens)
│   ├── routes/
│   │   ├── plans.ts         # GET /plans
│   │   ├── orders.ts        # POST /orders/esim
│   │   ├── esims.ts         # GET /my-esims
│   │   └── subscriptions.ts # GET /subscription/status
│   ├── services/
│   │   └── airalo.ts        # Airalo Partner API integration
│   └── types/
│       └── index.ts         # TypeScript types
├── .env.example             # Environment variables template
├── package.json
└── tsconfig.json
```

## Setup

### 1. Supabase Database

1. Create a Supabase project at https://supabase.com
2. Go to SQL Editor
3. Paste and run `sql/schema.sql`
4. Copy your project URL and service role key

### 2. Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your credentials:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-role-key
SUPABASE_ANON_KEY=your-anon-key
AIRALO_CLIENT_ID=your-airalo-client-id
AIRALO_CLIENT_SECRET=your-airalo-client-secret
AIRALO_API_URL=https://sandbox-partners-api.airalo.com/v2
PORT=3001
```

### 3. Install & Run

```bash
npm install
npm run dev
```

Server starts on http://localhost:3001

## API Endpoints

### GET /plans
List available eSIM plans. **Public** (no auth required).

```bash
# All plans
curl http://localhost:3001/plans

# Filter by country
curl http://localhost:3001/plans?country_code=JP

# Filter by region
curl http://localhost:3001/plans?region=Europa
```

**Response:**
```json
{
  "success": true,
  "data": {
    "RO": {
      "country_code": "RO",
      "country_name": "România",
      "region": "Europa",
      "plans": [
        {
          "id": "uuid",
          "name": "România 5 GB",
          "slug": "ro-5gb",
          "data_label": "5 GB",
          "valid_days": 30,
          "price": 4.99,
          "currency": "EUR",
          "is_popular": true
        }
      ]
    }
  }
}
```

### POST /orders/esim
Create an eSIM order. **Requires auth** (Bearer token).

```bash
curl -X POST http://localhost:3001/orders/esim \
  -H "Authorization: Bearer YOUR_SUPABASE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"plan_id": "plan-uuid", "apple_transaction_id": "optional"}'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "esim-uuid",
    "iccid": "8940...",
    "qr_code_url": "https://...",
    "qr_code_data": "LPA:1$smdp.io$...",
    "activation_code": "SC-JP-...",
    "country_code": "JP",
    "country_name": "Japonia",
    "data_label": "5 GB",
    "valid_days": 30,
    "status": "pending"
  }
}
```

### GET /my-esims
List user's eSIM profiles. **Requires auth**.

```bash
curl http://localhost:3001/my-esims \
  -H "Authorization: Bearer YOUR_SUPABASE_TOKEN"
```

### GET /subscription/status
Check premium subscription status. **Requires auth**.

```bash
curl http://localhost:3001/subscription/status \
  -H "Authorization: Bearer YOUR_SUPABASE_TOKEN"
```

**Response:**
```json
{
  "success": true,
  "data": {
    "has_subscription": true,
    "subscription": {
      "id": "sub-uuid",
      "plan_type": "premium",
      "status": "active",
      "expires_at": "2026-04-20T00:00:00Z"
    }
  }
}
```

### GET /health
Health check. **Public**.

```bash
curl http://localhost:3001/health
```

## Provider: Airalo

- **Sandbox**: `https://sandbox-partners-api.airalo.com/v2`
- **Production**: `https://partners-api.airalo.com/v2`
- When Airalo credentials are not set, the backend uses **mock data** (generates fake QR codes)
- Coverage: Europa + Americas (22 countries + EU regional pack)

## Database Tables

| Table | Description |
|-------|-------------|
| `users` | User profiles (extends Supabase auth) |
| `plans` | Available eSIM plans with pricing |
| `subscriptions` | Apple IAP premium subscriptions |
| `orders` | eSIM purchase orders |
| `user_esims` | Provisioned eSIM profiles with QR codes |

## Testing with Postman

Import the following requests:

1. **Health Check**: `GET http://localhost:3001/health`
2. **List Plans**: `GET http://localhost:3001/plans`
3. **Plans by Country**: `GET http://localhost:3001/plans?country_code=RO`
4. **Order eSIM**: `POST http://localhost:3001/orders/esim` (needs Bearer token + plan_id body)
5. **My eSIMs**: `GET http://localhost:3001/my-esims` (needs Bearer token)
6. **Subscription**: `GET http://localhost:3001/subscription/status` (needs Bearer token)

For auth tokens, sign in via Supabase and use the `access_token` from the response.
