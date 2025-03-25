// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'models/product.dart' as product_model;
import 'registro_clientes.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';
import 'carrito_de_compras.dart';
import 'clientes_screen.dart';  // Asegúrate de importar el archivo ClientesScreen

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Encabezado del Drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 100),
                  const SizedBox(height: 10),
                  const Text(
                    "VALHALLA GYM",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            // Elementos del Drawer
            _buildDrawerItem(
              context,
              "Registrar Clientes",
              const RegistroClienteScreen(
                clienteId: '',
                apellido: null,
                nombre: null,
                tipoPago: null,
                telefono: null,
                fechaPago: null,
                fechaExpiracion: null,
                codigoCliente: null,
              ),
            ),
            _buildDrawerItem(context, "Ver Clientes", const ClientesScreen()),
            _buildDrawerItem(
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
              ),
            ),
            _buildDrawerItem(context, "Lista de Productos", ProductListScreen()),
            _buildDrawerItem(context, "Carrito de Compras", const ShoppingCartScreen()),
            const Divider(),
            ListTile(
              title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Contenido principal
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bienvenido a VALHALLA GYM",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: const Text(
                    "Tu viaje hacia una vida más saludable comienza hoy. ¡Vamos a lograrlo juntos!",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center, // Esto alinea el texto al centro
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, Widget screen) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cerrar el Drawer antes de navegar
        Future.delayed(Duration(milliseconds: 200), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        });
      },
    );
  }
}
