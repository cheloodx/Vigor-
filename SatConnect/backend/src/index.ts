// ============================================================================
// SatConnect MVP Backend - Express Server
// ============================================================================
// Endpoints:
//   GET  /plans              - List available eSIM plans (public)
//   POST /orders/esim        - Create eSIM order + provision via Airalo (auth)
//   GET  /my-esims           - List user's eSIM profiles (auth)
//   GET  /subscription/status - Check premium subscription (auth)
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
import { hasAiraloCredentials } from './services/airalo';

const app = express();
const PORT = process.env.PORT || 3001;

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

// Health check
app.get('/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'satconnect-backend',
    version: '1.0.0',
    airalo: hasAiraloCredentials() ? 'configured' : 'mock',
    timestamp: new Date().toISOString(),
  });
});

// 404 handler
app.use((_req, res) => {
  res.status(404).json({ success: false, error: 'Endpoint not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`SatConnect backend running on port ${PORT}`);
  console.log(`Airalo: ${hasAiraloCredentials() ? 'REAL (API configured)' : 'MOCK (no credentials)'}`);
  console.log(`Supabase: ${process.env.SUPABASE_URL ? 'configured' : 'NOT configured'}`);
});

export default app;
