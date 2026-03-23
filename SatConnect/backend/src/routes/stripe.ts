import { Router, Request, Response } from 'express';
import Stripe from 'stripe';
import { getPlanById } from '../data/planCatalog';
import { createOrderForSession, provisionForSession } from '../services/provisioning';

const router = Router();

// Lazy Stripe init — reads env at call time so dotenv.config() has already run
function getStripe(): Stripe {
  const key = process.env.STRIPE_SECRET_KEY;
  if (!key) {
    throw new Error('STRIPE_SECRET_KEY is not configured');
  }
  return new Stripe(key, { apiVersion: '2023-10-16' });
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

    // Create order record in Supabase (blocking — if this fails, don't let user pay)
    // Note: createOrderForSession returns null on internal errors instead of throwing,
    // so we check both null return AND exceptions.
    try {
      const orderRecord = await createOrderForSession(session.id, plan.id);
      if (!orderRecord) {
        // Expire the orphaned Stripe session so it doesn't linger for 24h
        await stripe.checkout.sessions.expire(session.id).catch(() => {});
        res.status(500).json({ error: 'Failed to initialize order. Please try again.' });
        return;
      }
    } catch (orderErr) {
      console.error('Failed to create order record:', orderErr);
      await stripe.checkout.sessions.expire(session.id).catch(() => {});
      res.status(500).json({ error: 'Failed to initialize order. Please try again.' });
      return;
    }

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

      // Auto-provision eSIM after payment (non-blocking — respond to Stripe immediately)
      provisionForSession(session.id)
        .then((provResult) => {
          if (provResult.success) {
            console.log('Auto-provisioned eSIM:', provResult.order?.iccid);
          } else {
            console.error('Auto-provision failed:', provResult.error);
          }
        })
        .catch((provErr) => {
          console.error('Auto-provision error:', provErr);
        });

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
