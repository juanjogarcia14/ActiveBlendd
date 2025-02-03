import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'screen/ropa_deportiva_screen.dart';
import 'screen/home.dart';
import 'screen/alimentacionscreen.dart';
import 'screen/materialscreen.dart';
import 'screen/carrito_screen.dart';


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
      initialRoute: '/login', // Ruta inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/alimentacion': (context) => AlimentacionScreen(),
        '/material': (context) => MaterialScreen(),
        '/ropaDeportiva': (context) => RopaDeportivaScreen(),
      },
    );
  }
}
