const { onRequest } = require('firebase-functions/v2/https');
const express     = require('express');
const cors        = require('cors');
const admin       = require('firebase-admin');
admin.initializeApp();

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

app.post('/createPaymentIntent', async (req, res) => {
  const { amount, currency = 'usd' } = req.body;
  if (typeof amount !== 'number') {
    return res.status(400).json({ error: 'Invalid amount' });
  }
  try {
    // Handler içinde Stripe’ı init et
    const stripe = require('stripe')(process.env.STRIPE_SECRET);
    const pi = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100),
      currency,
    });
    return res.json({ clientSecret: pi.client_secret });
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

exports.api = onRequest(
  { region: 'us-central1', secrets: ['STRIPE_SECRET'] },
  app
);
