import 'package:flutter/material.dart';

class PantallaPagoScreen extends StatefulWidget {
  @override
  _PantallaPagoScreenState createState() => _PantallaPagoScreenState();
}

class _PantallaPagoScreenState extends State<PantallaPagoScreen> {
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  String message = '';

  void validateCard() {
    final card = cardNumberController.text.trim();
    final expiry = expiryController.text.trim();
    final cvv = cvvController.text.trim();
    final name = nameController.text.trim();

    if (card.length != 16 || !RegExp(r'^\d{16}$').hasMatch(card)) {
      setState(() => message = 'Número de tarjeta inválido');
      return;
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(expiry)) {
      setState(() => message = 'Fecha de caducidad inválida');
      return;
    }
    if (cvv.length != 3 || !RegExp(r'^\d{3}$').hasMatch(cvv)) {
      setState(() => message = 'CVV inválido');
      return;
    }
    if (name.isEmpty) {
      setState(() => message = 'Introduce el nombre del titular');
      return;
    }

    setState(() => message = '¡Pago procesado con éxito!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pasarela de Pago')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Número de tarjeta (16 dígitos)'),
              ),
              TextField(
                controller: expiryController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Fecha de caducidad (MM/AA)'),
              ),
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(labelText: 'CVV (3 dígitos)'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre del titular'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: validateCard,
                child: Text('Pagar'),
              ),
              SizedBox(height: 16),
              Text(message, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}