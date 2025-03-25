// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_gym/screens/providers/cart_provider.dart';
import 'package:proyecto_gym/screens/models/product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> products = [
    Product(
      id: '1',
      name: "BCAA",
      price: 612.00,
      description:
          'Aminoácidos de cadena ramificada para recuperación muscular.',
      imageUrl: 'assets/Bcaa.png',
    ),
    Product(
      id: '2',
      name: "Creatina",
      price: 735.00,
      description: 'Creatina monohidratada para mejorar el rendimiento.',
      imageUrl: 'assets/creatina.png',
    ),
    Product(
      id: '3',
      name: "Proteína",
      price: 1225.00,
      description: 'Proteína en polvo para ganar masa muscular.',
      imageUrl: 'assets/proteina.png',
    ),
    Product(
      id: '4',
      name: "Glutamina",
      price: 666.00,
      description: 'Suplemento de glutamina para la recuperación muscular.',
      imageUrl: 'assets/glutamina.png',
    ),
    Product(
      id: '5',
      name: "Omega 3",
      price: 367.00,
      description: 'Ácidos grasos esenciales para la salud cardiovascular.',
      imageUrl: 'assets/omega3.png',
    ),
    Product(
      id: '6',
      name: "Pre-Entreno",
      price: 857.00,
      description: 'Suplemento energético para mejorar el rendimiento.',
      imageUrl: 'assets/pre-entreno.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Suplementos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar productos...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
              ),
            ),
          ),

          // Lista de productos en GridView
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              product.imageUrl, // 🔹 Corrección aquí
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "L${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            cartProvider.addToCart(product);
                          },
                          child: const Text("Añadir al carrito"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
