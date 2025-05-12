import 'package:flutter/material.dart';

class SobreNosotrosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre Nosotros')),
      body: Center(
        child: Text(
          'Contenido de Sobre Nosotros',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
