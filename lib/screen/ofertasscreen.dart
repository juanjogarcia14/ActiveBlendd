import 'package:flutter/material.dart';

class OfertaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ofertas Especiales'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(
          '¡Aquí van tus ofertas especiales!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
