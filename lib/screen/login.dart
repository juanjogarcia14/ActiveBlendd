import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    print("Ejecutando LoginScreen actualizado"); // Para depuración
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo en la parte superior
              Image.asset('lib/assets/logo.png', height: 120, errorBuilder: (context, error, stackTrace) {
                return Text('Error al cargar logo.png');
              }),
              SizedBox(height: 20),
              Text(
                'Bienvenido a ActiveBlend',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00796B), // Nuevo color para el texto
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF00796B)), // Nuevo color para icono
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF00796B)), // Nuevo color para icono
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00796B), // Nuevo color para el botón
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Color(0xFF00796B)), // Nuevo color para el texto
                ),
              ),
              SizedBox(height: 32),
              // Logo de Google para futuro inicio de sesión con Firebase
              GestureDetector(
                onTap: () {},
                child: Image.asset('lib/assets/google_logo.png', height: 50, errorBuilder: (context, error, stackTrace) {
                  return Text('Error al cargar google_logo.png');
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
