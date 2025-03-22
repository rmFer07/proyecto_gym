import 'package:flutter/material.dart';
import 'package:proyecto_gym/services/auth_device.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 190,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.6),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
              ),
              const SizedBox(height: 35),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo Electrónico",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {}, // Recuperación de contraseña (pendiente)
                child: const Text("¿Olvidaste tu contraseña?",
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  await AuthService().signin(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                child: const Text("Iniciar Sesión",
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 20),
              const Text("¿No eres miembro?",
                  style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                },
                child: const Text("Únete a nosotros",
                    style: TextStyle(color: Colors.yellow)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
