import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { stripeRouter } from './routes/stripe';

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

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`SatConnect backend running on port ${PORT}`);
});

export default app;
