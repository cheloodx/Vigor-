// ============================================================================
// SatConnect Backend - Express Server
// ============================================================================
// Endpoints:
//   GET  /plans              - List available eSIM plans (public)
//   POST /orders/esim        - Create eSIM order + provision via Airalo (auth)
//   POST /api/orders/provision - Provision eSIM after Stripe payment (web)
//   GET  /api/orders/:id     - Get order status by Stripe session ID
//   GET  /my-esims           - List user's eSIM profiles (auth)
//   GET  /subscription/status - Check premium subscription (auth)
//   POST /api/stripe/create-checkout - Create Stripe checkout session
//   POST /api/stripe/webhook - Handle Stripe payment webhooks
//   GET  /api/stripe/session/:id - Check payment status
//   GET  /health             - Health check (public)
// ============================================================================

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';

// Load env vars before importing modules that use them
dotenv.config();

import plansRouter from './routes/plans';
import ordersRouter from './routes/orders';
import esimsRouter from './routes/esims';
import subscriptionsRouter from './routes/subscriptions';
import { stripeRouter } from './routes/stripe';
import { ordersRouter as stripeOrdersRouter } from './routes/orders';
import { hasAiraloCredentials } from './services/airalo';
import { isSupabaseConfigured } from './services/supabase';

const app = express();
const PORT = process.env.PORT || 3001;

// Stripe webhook needs raw body, so we handle it before other middleware
app.use('/api/stripe/webhook', express.raw({ type: 'application/json' }));

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());

// Routes
app.use('/plans', plansRouter);
app.use('/orders', ordersRouter);
app.use('/my-esims', esimsRouter);
app.use('/subscription', subscriptionsRouter);
app.use('/api/stripe', stripeRouter);
app.use('/api/orders', stripeOrdersRouter);

// Health check
app.get('/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'satconnect-backend',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    services: {
      airalo: hasAiraloCredentials() ? 'configured' : 'mock',
      stripe: process.env.STRIPE_SECRET_KEY ? 'configured' : 'not configured',
      supabase: isSupabaseConfigured() ? 'configured' : 'not configured',
    },
  });
});

// 404 handler
app.use((_req, res) => {
  res.status(404).json({ success: false, error: 'Endpoint not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`SatConnect backend running on port ${PORT}`);
  console.log(`  Airalo: ${hasAiraloCredentials() ? 'REAL (API configured)' : 'MOCK (no credentials)'}`);
  console.log(`  Stripe: ${process.env.STRIPE_SECRET_KEY ? 'configured' : 'NOT configured'}`);
  console.log(`  Supabase: ${isSupabaseConfigured() ? 'configured' : 'NOT configured'}`);
});

export default app;
