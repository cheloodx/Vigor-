import { Router, Request, Response } from 'express';
import Stripe from 'stripe';
import { getPlanById } from '../data/planCatalog';

const router = Router();

// Initialize Stripe with secret key
const stripeSecretKey = process.env.STRIPE_SECRET_KEY;
if (!stripeSecretKey) {
  console.warn('STRIPE_SECRET_KEY not set — Stripe endpoints will fail');
}

function getStripe(): Stripe {
  if (!stripeSecretKey) {
    throw new Error('STRIPE_SECRET_KEY is not configured');
  }
  return new Stripe(stripeSecretKey, { apiVersion: '2023-10-16' });
}

// ---------------------------------------------------------------------------
// POST /api/stripe/create-checkout
// Creates a Stripe Checkout Session for an eSIM plan purchase
// ---------------------------------------------------------------------------
router.post('/create-checkout', async (req: Request, res: Response) => {
  try {
    const { planId } = req.body;

    if (!planId) {
      res.status(400).json({ error: 'Missing required field: planId' });
      return;
    }

    // Server-side price lookup — never trust client-provided prices
    const plan = getPlanById(planId);
    if (!plan) {
      res.status(400).json({ error: 'Invalid plan ID' });
      return;
    }

    const stripe = getStripe();

    // Price in cents (Stripe expects smallest currency unit)
    const unitAmount = Math.round(plan.price * 100);
    const curr = plan.currency.toLowerCase();

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: curr,
            product_data: {
              name: `eSIM ${plan.dataLabel} - ${plan.countryName}`,
              description: `${plan.countryFlag} Internet ${plan.dataLabel} pentru ${plan.countryName} (${plan.validDays} zile)`,
              metadata: {
                planId: plan.id,
                countryCode: plan.countryCode,
                countryName: plan.countryName,
                dataLabel: plan.dataLabel,
                validDays: String(plan.validDays),
              },
            },
            unit_amount: unitAmount,
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: `${process.env.FRONTEND_URL || 'http://localhost:8082'}/payment-success?session_id={CHECKOUT_SESSION_ID}&plan_id=${plan.id}`,
      cancel_url: `${process.env.FRONTEND_URL || 'http://localhost:8082'}/payment-cancel`,
      metadata: {
        planId: plan.id,
        countryCode: plan.countryCode,
        countryName: plan.countryName,
        dataLabel: plan.dataLabel,
        validDays: String(plan.validDays),
        price: String(plan.price),
      },
    });

    res.json({
      sessionId: session.id,
      url: session.url,
    });
  } catch (err) {
    console.error('Stripe checkout error:', err);
    const message = err instanceof Error ? err.message : 'Failed to create checkout session';
    res.status(500).json({ error: message });
  }
});

// ---------------------------------------------------------------------------
// POST /api/stripe/webhook
// Handles Stripe webhook events (payment confirmation)
// ---------------------------------------------------------------------------
router.post('/webhook', async (req: Request, res: Response) => {
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;
  const sig = req.headers['stripe-signature'];

  if (!webhookSecret || !sig) {
    console.warn('Webhook secret or signature missing');
    res.status(400).json({ error: 'Missing webhook secret or signature' });
    return;
  }

  let event: Stripe.Event;
  try {
    const stripe = getStripe();
    event = stripe.webhooks.constructEvent(req.body, sig, webhookSecret);
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Webhook signature verification failed';
    console.error('Webhook verification error:', message);
    res.status(400).json({ error: message });
    return;
  }

  // Handle the event
  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session;
      console.log('Payment successful for session:', session.id);
      console.log('Plan:', session.metadata?.planId);
      console.log('Country:', session.metadata?.countryName);

      // TODO: Provision eSIM via Airalo API here
      // const planId = session.metadata?.planId;
      // await esimProvisioning.provisionESIM(planId);

      break;
    }
    case 'payment_intent.payment_failed': {
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      console.log('Payment failed:', paymentIntent.id);
      break;
    }
    default:
      console.log(`Unhandled event type: ${event.type}`);
  }

  res.json({ received: true });
});

// ---------------------------------------------------------------------------
// GET /api/stripe/session/:sessionId
// Check payment status for a session
// ---------------------------------------------------------------------------
router.get('/session/:sessionId', async (req: Request, res: Response) => {
  try {
    const stripe = getStripe();
    const session = await stripe.checkout.sessions.retrieve(req.params.sessionId);

    res.json({
      id: session.id,
      status: session.payment_status,
      planId: session.metadata?.planId,
      countryName: session.metadata?.countryName,
      dataLabel: session.metadata?.dataLabel,
      amountTotal: session.amount_total,
      currency: session.currency,
    });
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Failed to retrieve session';
    res.status(500).json({ error: message });
  }
});

export { router as stripeRouter };
