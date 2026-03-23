-- ============================================================================
-- SatConnect MVP - Database Schema (Supabase / PostgreSQL)
-- ============================================================================
-- Tables: users, plans, subscriptions, orders, user_esims
-- Provider: Airalo (single provider)
-- Coverage: Europa + Americas
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. USERS
-- ============================================================================
-- Extends Supabase auth.users with app-specific profile data.
-- id references auth.users(id) from Supabase Auth.

CREATE TABLE IF NOT EXISTS users (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email         TEXT NOT NULL UNIQUE,
  full_name     TEXT,
  apple_user_id TEXT UNIQUE,          -- Apple Sign-In identifier
  avatar_url    TEXT,
  phone         TEXT,
  country_code  TEXT DEFAULT 'RO',    -- User's home country (ISO 3166-1 alpha-2)
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- 2. PLANS
-- ============================================================================
-- Available eSIM plans. Each plan targets a specific country or region.
-- Prices in EUR. Only Europa + Americas for MVP.

CREATE TABLE IF NOT EXISTS plans (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          TEXT NOT NULL,                       -- e.g. "Japonia 5 GB"
  slug          TEXT NOT NULL UNIQUE,                -- e.g. "jp-5gb"
  country_code  TEXT NOT NULL,                       -- ISO 3166-1 alpha-2 (e.g. "JP") or region code ("EU")
  country_name  TEXT NOT NULL,                       -- Display name (e.g. "Japonia")
  region        TEXT NOT NULL,                       -- "Europa" or "Americas"
  data_limit_mb INTEGER NOT NULL,                    -- Data in MB (e.g. 5120 = 5GB)
  data_label    TEXT NOT NULL,                       -- Display label (e.g. "5 GB")
  valid_days    INTEGER NOT NULL,                    -- Validity in days
  price         NUMERIC(10,2) NOT NULL,              -- Price in EUR
  currency      TEXT NOT NULL DEFAULT 'EUR',
  is_popular    BOOLEAN NOT NULL DEFAULT FALSE,      -- Show "POPULAR" badge
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,       -- Soft delete / disable
  apple_product_id TEXT,                             -- Apple IAP product ID (e.g. "com.satconnect.esim.jp5gb")
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER plans_updated_at
  BEFORE UPDATE ON plans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_plans_country ON plans(country_code);
CREATE INDEX idx_plans_region ON plans(region);
CREATE INDEX idx_plans_active ON plans(is_active);

-- ============================================================================
-- 3. SUBSCRIPTIONS
-- ============================================================================
-- Tracks Apple In-App Purchase subscriptions (premium access).

CREATE TYPE subscription_status AS ENUM ('active', 'expired', 'cancelled', 'pending', 'trial');

CREATE TABLE IF NOT EXISTS subscriptions (
  id                    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan_type             TEXT NOT NULL DEFAULT 'premium',  -- 'free', 'premium', 'family'
  status                subscription_status NOT NULL DEFAULT 'pending',
  apple_transaction_id  TEXT UNIQUE,              -- Apple original_transaction_id
  apple_product_id      TEXT,                     -- Apple product ID
  apple_receipt_data    TEXT,                     -- Apple receipt for server-side validation
  starts_at             TIMESTAMPTZ,
  expires_at            TIMESTAMPTZ,
  cancelled_at          TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_apple_tx ON subscriptions(apple_transaction_id);

-- ============================================================================
-- 4. ORDERS
-- ============================================================================
-- eSIM purchase orders. Links user → plan → Airalo order.

CREATE TYPE order_status AS ENUM ('pending', 'processing', 'completed', 'failed', 'refunded');

CREATE TABLE IF NOT EXISTS orders (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan_id           UUID NOT NULL REFERENCES plans(id),
  status            order_status NOT NULL DEFAULT 'pending',
  airalo_order_id   TEXT,                -- Airalo API order ID
  apple_transaction_id TEXT,             -- Apple IAP transaction for this purchase
  price_paid        NUMERIC(10,2) NOT NULL,
  currency          TEXT NOT NULL DEFAULT 'EUR',
  error_message     TEXT,                -- If status = 'failed'
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_airalo ON orders(airalo_order_id);

-- ============================================================================
-- 5. USER_ESIMS
-- ============================================================================
-- Provisioned eSIM profiles. One per order. Contains QR code for activation.

CREATE TYPE esim_status AS ENUM ('pending', 'active', 'expired', 'deactivated');

CREATE TABLE IF NOT EXISTS user_esims (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  order_id          UUID NOT NULL REFERENCES orders(id) UNIQUE,
  iccid             TEXT UNIQUE,                    -- eSIM ICCID from Airalo
  activation_code   TEXT,                           -- SM-DP+ activation code
  qr_code_url      TEXT,                            -- QR code image URL for activation
  qr_code_data      TEXT,                           -- Raw QR code data (LPA string)
  country_code      TEXT NOT NULL,
  country_name      TEXT NOT NULL,
  data_limit_mb     INTEGER NOT NULL,
  data_used_mb      INTEGER NOT NULL DEFAULT 0,
  data_label        TEXT NOT NULL,                  -- "5 GB"
  valid_days        INTEGER NOT NULL,
  status            esim_status NOT NULL DEFAULT 'pending',
  activated_at      TIMESTAMPTZ,
  expires_at        TIMESTAMPTZ,
  airalo_esim_id    TEXT,                           -- Airalo eSIM reference
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER user_esims_updated_at
  BEFORE UPDATE ON user_esims
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_user_esims_user ON user_esims(user_id);
CREATE INDEX idx_user_esims_status ON user_esims(status);
CREATE INDEX idx_user_esims_iccid ON user_esims(iccid);

-- ============================================================================
-- Row Level Security (RLS) - Users can only see their own data
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_esims ENABLE ROW LEVEL SECURITY;

-- Users can read/update their own profile
CREATE POLICY users_select ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY users_update ON users FOR UPDATE USING (auth.uid() = id);

-- Users can read their own subscriptions
CREATE POLICY subscriptions_select ON subscriptions FOR SELECT USING (auth.uid() = user_id);

-- Users can read their own orders
CREATE POLICY orders_select ON orders FOR SELECT USING (auth.uid() = user_id);

-- Users can read their own eSIMs
CREATE POLICY user_esims_select ON user_esims FOR SELECT USING (auth.uid() = user_id);

-- Plans are public (everyone can read)
-- No RLS needed on plans (or enable with a permissive policy)

-- ============================================================================
-- Seed data: Europa + Americas plans
-- ============================================================================

INSERT INTO plans (name, slug, country_code, country_name, region, data_limit_mb, data_label, valid_days, price, is_popular, apple_product_id) VALUES
-- Europa
('România 1 GB',          'ro-1gb',   'RO', 'România',         'Europa', 1024,  '1 GB',  7,  1.99, FALSE, 'com.satconnect.esim.ro1gb'),
('România 5 GB',          'ro-5gb',   'RO', 'România',         'Europa', 5120,  '5 GB',  30, 4.99, TRUE,  'com.satconnect.esim.ro5gb'),
('România 10 GB',         'ro-10gb',  'RO', 'România',         'Europa', 10240, '10 GB', 30, 7.99, FALSE, 'com.satconnect.esim.ro10gb'),
('Franța 1 GB',           'fr-1gb',   'FR', 'Franța',          'Europa', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.fr1gb'),
('Franța 5 GB',           'fr-5gb',   'FR', 'Franța',          'Europa', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.fr5gb'),
('Franța 10 GB',          'fr-10gb',  'FR', 'Franța',          'Europa', 10240, '10 GB', 30, 12.99, FALSE, 'com.satconnect.esim.fr10gb'),
('Germania 1 GB',         'de-1gb',   'DE', 'Germania',        'Europa', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.de1gb'),
('Germania 5 GB',         'de-5gb',   'DE', 'Germania',        'Europa', 5120,  '5 GB',  30, 8.99, TRUE,  'com.satconnect.esim.de5gb'),
('Germania 10 GB',        'de-10gb',  'DE', 'Germania',        'Europa', 10240, '10 GB', 30, 14.99, FALSE, 'com.satconnect.esim.de10gb'),
('Italia 1 GB',           'it-1gb',   'IT', 'Italia',          'Europa', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.it1gb'),
('Italia 5 GB',           'it-5gb',   'IT', 'Italia',          'Europa', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.it5gb'),
('Italia 10 GB',          'it-10gb',  'IT', 'Italia',          'Europa', 10240, '10 GB', 30, 12.99, FALSE, 'com.satconnect.esim.it10gb'),
('Spania 1 GB',           'es-1gb',   'ES', 'Spania',          'Europa', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.es1gb'),
('Spania 5 GB',           'es-5gb',   'ES', 'Spania',          'Europa', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.es5gb'),
('Spania 10 GB',          'es-10gb',  'ES', 'Spania',          'Europa', 10240, '10 GB', 30, 12.99, FALSE, 'com.satconnect.esim.es10gb'),
('Marea Britanie 1 GB',   'gb-1gb',   'GB', 'Marea Britanie',  'Europa', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.gb1gb'),
('Marea Britanie 5 GB',   'gb-5gb',   'GB', 'Marea Britanie',  'Europa', 5120,  '5 GB',  30, 9.99, TRUE,  'com.satconnect.esim.gb5gb'),
('Marea Britanie 10 GB',  'gb-10gb',  'GB', 'Marea Britanie',  'Europa', 10240, '10 GB', 30, 16.99, FALSE, 'com.satconnect.esim.gb10gb'),
('Grecia 1 GB',           'gr-1gb',   'GR', 'Grecia',          'Europa', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.gr1gb'),
('Grecia 5 GB',           'gr-5gb',   'GR', 'Grecia',          'Europa', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.gr5gb'),
('Grecia 10 GB',          'gr-10gb',  'GR', 'Grecia',          'Europa', 10240, '10 GB', 30, 12.99, FALSE, 'com.satconnect.esim.gr10gb'),
('Turcia 1 GB',           'tr-1gb',   'TR', 'Turcia',          'Europa', 1024,  '1 GB',  7,  1.99, FALSE, 'com.satconnect.esim.tr1gb'),
('Turcia 5 GB',           'tr-5gb',   'TR', 'Turcia',          'Europa', 5120,  '5 GB',  30, 5.99, TRUE,  'com.satconnect.esim.tr5gb'),
('Turcia 10 GB',          'tr-10gb',  'TR', 'Turcia',          'Europa', 10240, '10 GB', 30, 9.99, FALSE, 'com.satconnect.esim.tr10gb'),
('Olanda 1 GB',           'nl-1gb',   'NL', 'Olanda',          'Europa', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.nl1gb'),
('Olanda 5 GB',           'nl-5gb',   'NL', 'Olanda',          'Europa', 5120,  '5 GB',  30, 8.99, TRUE,  'com.satconnect.esim.nl5gb'),
('Belgia 1 GB',           'be-1gb',   'BE', 'Belgia',          'Europa', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.be1gb'),
('Belgia 5 GB',           'be-5gb',   'BE', 'Belgia',          'Europa', 5120,  '5 GB',  30, 8.99, TRUE,  'com.satconnect.esim.be5gb'),
('Austria 1 GB',          'at-1gb',   'AT', 'Austria',         'Europa', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.at1gb'),
('Austria 5 GB',          'at-5gb',   'AT', 'Austria',         'Europa', 5120,  '5 GB',  30, 8.99, TRUE,  'com.satconnect.esim.at5gb'),
('Elveția 1 GB',          'ch-1gb',   'CH', 'Elveția',         'Europa', 1024,  '1 GB',  7,  3.99, FALSE, 'com.satconnect.esim.ch1gb'),
('Elveția 5 GB',          'ch-5gb',   'CH', 'Elveția',         'Europa', 5120,  '5 GB',  30, 11.99, TRUE, 'com.satconnect.esim.ch5gb'),
('Portugalia 1 GB',       'pt-1gb',   'PT', 'Portugalia',      'Europa', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.pt1gb'),
('Portugalia 5 GB',       'pt-5gb',   'PT', 'Portugalia',      'Europa', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.pt5gb'),
('Europa 30+ țări 1 GB',  'eu-1gb',   'EU', 'Europa (30+ țări)', 'Europa', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.eu1gb'),
('Europa 30+ țări 5 GB',  'eu-5gb',   'EU', 'Europa (30+ țări)', 'Europa', 5120,  '5 GB',  30, 8.99, TRUE,  'com.satconnect.esim.eu5gb'),
('Europa 30+ țări 10 GB', 'eu-10gb',  'EU', 'Europa (30+ țări)', 'Europa', 10240, '10 GB', 30, 14.99, FALSE, 'com.satconnect.esim.eu10gb'),

-- Americas
('SUA 1 GB',              'us-1gb',   'US', 'SUA',             'Americas', 1024,  '1 GB',  7,  3.99, FALSE, 'com.satconnect.esim.us1gb'),
('SUA 5 GB',              'us-5gb',   'US', 'SUA',             'Americas', 5120,  '5 GB',  30, 12.99, TRUE,  'com.satconnect.esim.us5gb'),
('SUA 10 GB',             'us-10gb',  'US', 'SUA',             'Americas', 10240, '10 GB', 30, 19.99, FALSE, 'com.satconnect.esim.us10gb'),
('SUA 20 GB',             'us-20gb',  'US', 'SUA',             'Americas', 20480, '20 GB', 30, 29.99, FALSE, 'com.satconnect.esim.us20gb'),
('Canada 1 GB',           'ca-1gb',   'CA', 'Canada',          'Americas', 1024,  '1 GB',  7,  3.99, FALSE, 'com.satconnect.esim.ca1gb'),
('Canada 5 GB',           'ca-5gb',   'CA', 'Canada',          'Americas', 5120,  '5 GB',  30, 12.99, TRUE,  'com.satconnect.esim.ca5gb'),
('Canada 10 GB',          'ca-10gb',  'CA', 'Canada',          'Americas', 10240, '10 GB', 30, 19.99, FALSE, 'com.satconnect.esim.ca10gb'),
('Mexic 1 GB',            'mx-1gb',   'MX', 'Mexic',           'Americas', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.mx1gb'),
('Mexic 5 GB',            'mx-5gb',   'MX', 'Mexic',           'Americas', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.mx5gb'),
('Mexic 10 GB',           'mx-10gb',  'MX', 'Mexic',           'Americas', 10240, '10 GB', 30, 12.99, FALSE, 'com.satconnect.esim.mx10gb'),
('Brazilia 1 GB',         'br-1gb',   'BR', 'Brazilia',        'Americas', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.br1gb'),
('Brazilia 5 GB',         'br-5gb',   'BR', 'Brazilia',        'Americas', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.br5gb'),
('Brazilia 10 GB',        'br-10gb',  'BR', 'Brazilia',        'Americas', 10240, '10 GB', 30, 12.99, FALSE, 'com.satconnect.esim.br10gb'),
('Argentina 1 GB',        'ar-1gb',   'AR', 'Argentina',       'Americas', 1024,  '1 GB',  7,  2.99, FALSE, 'com.satconnect.esim.ar1gb'),
('Argentina 5 GB',        'ar-5gb',   'AR', 'Argentina',       'Americas', 5120,  '5 GB',  30, 8.99, TRUE,  'com.satconnect.esim.ar5gb'),
('Columbia 1 GB',         'co-1gb',   'CO', 'Columbia',        'Americas', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.co1gb'),
('Columbia 5 GB',         'co-5gb',   'CO', 'Columbia',        'Americas', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.co5gb'),
('Chile 1 GB',            'cl-1gb',   'CL', 'Chile',           'Americas', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.cl1gb'),
('Chile 5 GB',            'cl-5gb',   'CL', 'Chile',           'Americas', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.cl5gb'),
('Peru 1 GB',             'pe-1gb',   'PE', 'Peru',            'Americas', 1024,  '1 GB',  7,  2.49, FALSE, 'com.satconnect.esim.pe1gb'),
('Peru 5 GB',             'pe-5gb',   'PE', 'Peru',            'Americas', 5120,  '5 GB',  30, 7.99, TRUE,  'com.satconnect.esim.pe5gb');
