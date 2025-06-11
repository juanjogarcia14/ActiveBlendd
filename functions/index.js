const functions = require('firebase-functions');
const admin = require('firebase-admin');
require('dotenv').config();

const stripe = require('stripe')(process.env.STRIPE_SECRET);

admin.initializeApp();

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    const amount = req.body.amount;

    if (!amount || typeof amount !== 'number') {
      return res.status(400).json({ error: 'El campo "amount" debe ser un número válido.' });
    }

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency: 'eur',
    });

    return res.status(200).json({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    console.error('Error en createPaymentIntent:', error);
    return res.status(500).json({ error: 'Error al crear PaymentIntent' });
  }
});
