import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:activeblendd/screen/product_provider.dart';
import 'screen/login.dart';
import 'screen/ropa_deportiva_screen.dart';
import 'screen/alimentacionscreen.dart';
import 'screen/home.dart';
import 'screen/materialscreen.dart';
import 'screen/sobre_nosotros_screen.dart';
import 'screen/carrito_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00796B),
        scaffoldBackgroundColor: Color(0xFFACE0D4),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => home(),
        '/alimentacion': (context) => AlimentacionScreen(),
        '/material': (context) => MaterialScreen(),
        '/ropaDeportiva': (context) => RopaDeportivaScreen(),
        '/sobreNosotros': (context) => SobreNosotrosScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
