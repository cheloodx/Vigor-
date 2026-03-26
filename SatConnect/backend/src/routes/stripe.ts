import { Router, Request, Response } from 'express';
import Stripe from 'stripe';
import { getPlanById, PlanEntry } from '../data/planCatalog';
import { getCachedApiPlan } from './plans';
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
    const { planId, successUrl, cancelUrl } = req.body;

    if (!planId) {
      res.status(400).json({ error: 'Missing required field: planId' });
      return;
    }

    // Server-side price lookup — never trust client-provided prices
    // First check the cached API plans (same prices shown on the storefront),
    // then fall back to the static catalog for legacy plan IDs.
    const apiPlan = getCachedApiPlan(planId);
    let plan: PlanEntry;
    if (apiPlan) {
      plan = {
        id: apiPlan.id,
        countryCode: apiPlan.country_code,
        countryName: apiPlan.country_name,
        countryFlag: '',
        dataLimitMB: apiPlan.data_limit_mb,
        dataLabel: apiPlan.data_label,
        validDays: apiPlan.valid_days,
        price: apiPlan.price,
        currency: apiPlan.currency,
      };
    } else {
      const catalogPlan = getPlanById(planId);
      if (!catalogPlan) {
        res.status(400).json({ error: 'Invalid plan ID' });
        return;
      }
      plan = catalogPlan;
    }

    const stripe = getStripe();

    // Price in cents (Stripe expects smallest currency unit)
    const unitAmount = Math.round(plan.price * 100);
    const curr = plan.currency.toLowerCase();

    // Use client-provided URLs only if they match our allowed origin (prevent open redirect)
    // Prefer FRONTEND_URL env var; fall back to X-Forwarded headers from reverse proxy
    const inferredOrigin = `${req.get('x-forwarded-proto') || req.protocol}://${req.get('x-forwarded-host') || req.get('host')}`;
    const allowedOrigin = process.env.FRONTEND_URL || inferredOrigin;
    const finalSuccessUrl = (successUrl && process.env.FRONTEND_URL && successUrl.startsWith(allowedOrigin + '/')) ? successUrl : `${allowedOrigin}/payment-success.html?session_id={CHECKOUT_SESSION_ID}&plan_id=${plan.id}`;
    const finalCancelUrl = (cancelUrl && process.env.FRONTEND_URL && cancelUrl.startsWith(allowedOrigin + '/')) ? cancelUrl : `${allowedOrigin}/payment-cancel.html`;

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: curr,
            product_data: {
              name: `eSIM ${plan.dataLabel} - ${plan.countryName}`,
              description: `Internet ${plan.dataLabel} pentru ${plan.countryName} (${plan.validDays} zile)`,
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
      success_url: finalSuccessUrl,
      cancel_url: finalCancelUrl,
      metadata: {
        planId: plan.id,
        countryCode: plan.countryCode,
        countryName: plan.countryName,
        dataLabel: plan.dataLabel,
        validDays: String(plan.validDays),
        price: String(plan.price),
      },
    });

    // Create order record (best-effort — don't block checkout if DB is down)
    try {
      const orderRecord = await createOrderForSession(session.id, plan.id);
      if (!orderRecord) {
        console.warn('Order record creation returned null — proceeding anyway');
      }
    } catch (orderErr) {
      console.error('Failed to create order record (non-blocking):', orderErr);
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

// ---------------------------------------------------------------------------
// GET /api/stripe/checkout-redirect
// Browser-navigation checkout: creates session and 302-redirects to Stripe.
// Used by static frontends that cannot make cross-origin POST requests.
// ---------------------------------------------------------------------------
router.get('/checkout-redirect', async (req: Request, res: Response) => {
  try {
    const planId = req.query.planId as string;
    const returnUrl = req.query.returnUrl as string;

    if (!planId) {
      res.status(400).send('Missing planId parameter');
      return;
    }

    // Server-side price lookup
    const apiPlan = getCachedApiPlan(planId);
    let plan: PlanEntry;
    if (apiPlan) {
      plan = {
        id: apiPlan.id,
        countryCode: apiPlan.country_code,
        countryName: apiPlan.country_name,
        countryFlag: '',
        dataLimitMB: apiPlan.data_limit_mb,
        dataLabel: apiPlan.data_label,
        validDays: apiPlan.valid_days,
        price: apiPlan.price,
        currency: apiPlan.currency,
      };
    } else {
      const catalogPlan = getPlanById(planId);
      if (!catalogPlan) {
        res.status(400).send('Invalid plan ID');
        return;
      }
      plan = catalogPlan;
    }

    const stripe = getStripe();
    const unitAmount = Math.round(plan.price * 100);
    const curr = plan.currency.toLowerCase();

    // Validate returnUrl against allowed origin to prevent open redirect
    // Prefer FRONTEND_URL env var; fall back to X-Forwarded headers from reverse proxy
    const inferredOrigin = `${req.get('x-forwarded-proto') || req.protocol}://${req.get('x-forwarded-host') || req.get('host')}`;
    const allowedOrigin = process.env.FRONTEND_URL || inferredOrigin;
    const baseUrl = (returnUrl && process.env.FRONTEND_URL && returnUrl.startsWith(allowedOrigin + '/')) ? returnUrl : allowedOrigin;
    const successUrl = `${baseUrl}/payment-success.html?session_id={CHECKOUT_SESSION_ID}&plan_id=${plan.id}`;
    const cancelUrl = `${baseUrl}/payment-cancel.html`;

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: curr,
            product_data: {
              name: `eSIM ${plan.dataLabel} - ${plan.countryName}`,
              description: `Internet ${plan.dataLabel} pentru ${plan.countryName} (${plan.validDays} zile)`,
            },
            unit_amount: unitAmount,
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: successUrl,
      cancel_url: cancelUrl,
      metadata: {
        planId: plan.id,
        countryCode: plan.countryCode,
        countryName: plan.countryName,
        dataLabel: plan.dataLabel,
        validDays: String(plan.validDays),
        price: String(plan.price),
      },
    });

    // Create order record (best-effort — don't block checkout if DB is down)
    try {
      const orderRecord = await createOrderForSession(session.id, plan.id);
      if (!orderRecord) {
        console.warn('Order record creation returned null — proceeding to checkout anyway');
      }
    } catch (orderErr) {
      console.error('Failed to create order record (non-blocking):', orderErr);
    }

    // Redirect to Stripe Checkout
    if (session.url) {
      res.redirect(303, session.url);
    } else {
      res.status(500).send('Failed to get checkout URL');
    }
  } catch (err) {
    console.error('Checkout redirect error:', err);
    res.status(500).send('Checkout error');
  }
});

export { router as stripeRouter };
