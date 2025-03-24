import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'models/product.dart' as product_model;
import 'registro_clientes.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';
import 'carrito_de_compras.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VALHALLA GYM"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 150),
            const SizedBox(height: 20),
            const Text(
              "Bienvenido a VALHALLA GYM",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    _buildMenuButton(context, "Registrar Clientes",
                        const RegistroClienteScreen()),
                    _buildMenuButton(
                        context,
                        "Detalle del Producto",
                        ProductDetailScreen(
                          product: product_model.Product(
                            id: '1',
                            name: "Producto de prueba",
                            description: "Descripción de prueba",
                            price: 0.0,
                            imageUrl: "assets/placeholder.png",
                          ),
                        )),
                    _buildMenuButton(
                        context, "Lista de Productos", ProductListScreen()),
                    _buildMenuButton(
                        context, "Carrito de Compras", const ShoppingCartScreen()),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        "Cerrar Sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
