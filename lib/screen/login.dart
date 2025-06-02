import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  String error = '';

  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => error = 'Rellena todos los campos.');
      return;
    }

    try {
      if (isLogin) {
        // Intentar iniciar sesión directamente
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Intentar registrar nuevo usuario
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (isLogin) {
        if (e.code == 'user-not-found') {
          setState(() => error = 'No existe ninguna cuenta con este correo.');
        } else if (e.code == 'wrong-password') {
          setState(() => error = 'La contraseña es incorrecta.');
        } else if (e.code == 'too-many-requests') {
          setState(() => error = 'Demasiados intentos fallidos. Inténtalo más tarde.');
        } else {
          setState(() => error = 'Error al iniciar sesión: ${e.message}');
        }
      } else {
        if (e.code == 'email-already-in-use') {
          setState(() => error = 'Ya existe una cuenta con este correo.');
        } else if (e.code == 'invalid-email') {
          setState(() => error = 'El correo electrónico no es válido.');
        } else if (e.code == 'weak-password') {
          setState(() => error = 'La contraseña es demasiado débil.');
        } else {
          setState(() => error = 'Error al registrar: ${e.message}');
        }
      }
    } catch (e) {
      setState(() => error = 'Error inesperado: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) {
        try {
          await googleSignIn.signOut();
        } catch (e) {
          print('[GoogleSignIn] Error al cerrar sesión previa: $e');
        }
      }

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      print('[GoogleSignIn] Sesión iniciada como: ${userCredential.user?.email}');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '[FirebaseAuth] ${e.code}: ${e.message}';
      });
    } catch (e) {
      setState(() {
        error = '[Error] $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                height: 180,
                errorBuilder: (context, error, stackTrace) => Text('Error al cargar logo.png'),
              ),
              SizedBox(height: 20),
              Text(
                isLogin ? 'Bienvenido a ActiveBlend' : 'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00796B),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF00796B)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF00796B)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00796B),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isLogin ? 'Iniciar sesión' : 'Registrarse',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    error = '';
                  });
                },
                child: Text(
                  isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(color: Color(0xFF00796B)),
                ),
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(error, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: signInWithGoogle,
                child: Image.asset(
                  'lib/assets/google_logo.png',
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => Text('Error al cargar google_logo.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
