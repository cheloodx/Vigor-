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
import path from 'path';

// Load env vars before importing modules that use them
dotenv.config();

import plansRouter from './routes/plans';
import ordersRouter from './routes/orders';
import esimsRouter from './routes/esims';
import subscriptionsRouter from './routes/subscriptions';
import { stripeRouter } from './routes/stripe';
import { ordersRouter as stripeOrdersRouter } from './routes/orders';
import { hasEsimAccessCredentials } from './services/esimAccess';
import { isSupabaseConfigured } from './services/supabase';

const app = express();
const PORT = process.env.PORT || 3001;

// Trust first proxy (nginx) so req.protocol and req.get('host') use X-Forwarded-* headers
app.set('trust proxy', 1);

// Stripe webhook needs raw body, so we handle it before other middleware
app.use('/api/stripe/webhook', express.raw({ type: 'application/json' }));

// Middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'", "https://unpkg.com", "https://cdnjs.cloudflare.com"],
      styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
      fontSrc: ["'self'", "https://fonts.gstatic.com"],
      imgSrc: ["'self'", "data:", "https:", "blob:"],
      connectSrc: ["'self'", "https://api.esimaccess.com", "https://checkout.stripe.com"],
      frameSrc: ["'self'", "https://checkout.stripe.com"],
      workerSrc: ["'self'", "blob:"],
    },
  },
}));
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());

// Serve static web checkout pages
app.use(express.static(path.join(__dirname, '..', 'public')));

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
      esimaccess: hasEsimAccessCredentials() ? 'configured' : 'mock',
      stripe: process.env.STRIPE_SECRET_KEY ? 'configured' : 'not configured',
      supabase: isSupabaseConfigured() ? 'configured' : 'not configured',
    },
  });
});

// SPA fallback: serve index.html for non-API routes
app.use((req, res, next) => {
  if (req.path.startsWith('/api/') || req.path.startsWith('/plans') || req.path.startsWith('/orders') || req.path.startsWith('/health') || req.path.startsWith('/my-esims') || req.path.startsWith('/subscription')) {
    res.status(404).json({ success: false, error: 'Endpoint not found' });
  } else {
    res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`SatConnect backend running on port ${PORT}`);
  console.log(`  eSIM Access: ${hasEsimAccessCredentials() ? 'REAL (API configured)' : 'MOCK (no credentials)'}`);
  console.log(`  Stripe: ${process.env.STRIPE_SECRET_KEY ? 'configured' : 'NOT configured'}`);
  console.log(`  Supabase: ${isSupabaseConfigured() ? 'configured' : 'NOT configured'}`);
});

export default app;
