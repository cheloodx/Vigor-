import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { stripeRouter } from './routes/stripe';
import { ordersRouter } from './routes/orders';
import { isSupabaseConfigured } from './services/supabase';
import { isAiraloConfigured } from './services/airalo';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Stripe webhook needs raw body, so we handle it before json middleware
app.use('/api/stripe/webhook', express.raw({ type: 'application/json' }));

// Standard middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/stripe', stripeRouter);
app.use('/api/orders', ordersRouter);

// Health check
app.get('/api/health', (_req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    services: {
      supabase: isSupabaseConfigured(),
      airalo: isAiraloConfigured(),
      stripe: Boolean(process.env.STRIPE_SECRET_KEY),
    },
  });
});

app.listen(PORT, () => {
  console.log(`SatConnect backend running on port ${PORT}`);
  console.log(`  Supabase: ${isSupabaseConfigured() ? 'configured' : 'not configured'}`);
  console.log(`  Airalo: ${isAiraloConfigured() ? 'configured' : 'not configured'}`);
  console.log(`  Stripe: ${process.env.STRIPE_SECRET_KEY ? 'configured' : 'not configured'}`);
});

export default app;
