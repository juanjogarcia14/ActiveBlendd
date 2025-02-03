import 'package:activeblendd/screen/ropa_deportiva_screen.dart';
import 'package:flutter/material.dart';
import 'screen/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00796B), // Color principal
        scaffoldBackgroundColor: Color(0xFFACE0D4), // Fondo del login
      ),
      home: RopaDeportivaScreen(), // Pantalla inicial
    );
  }
}