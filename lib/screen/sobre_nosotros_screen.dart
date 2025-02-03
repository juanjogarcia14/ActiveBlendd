import 'package:flutter/material.dart';

class SobreNosotrosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre Nosotros'),
        backgroundColor: Color(0xFF00796B),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFA8E6DB),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Color(0xFF00796B),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.set_meal),
              title: Text('Alimentación'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/alimentacion');
              },
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Material'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/material');
              },
            ),
            ListTile(
              leading: Icon(Icons.checkroom),
              title: Text('Ropa Deportiva'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/ropaDeportiva');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre Nosotros'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/sobreNosotros');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiénes Somos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Somos una empresa dedicada a ofrecer la mejor ropa deportiva para todo tipo de actividades físicas. '
                  'Nuestro objetivo es proporcionar calidad, comodidad y estilo en cada una de nuestras prendas.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Nuestra Misión',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Buscamos inspirar un estilo de vida activo ofreciendo productos diseñados con materiales de alta calidad '
                  'y tecnología innovadora para maximizar el rendimiento de nuestros clientes.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
