// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'models/product.dart'; 

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                product.imageUrl,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                // Añadimos un placeholder si la imagen no carga correctamente
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/logo.png', // Usa una imagen de placeholder
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Precio: \$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('${product.name} agregado al carrito')),
                );
              },
              child: const Text('Agregar al Carrito'),
            ),
          ],
        ),
      ),
    );
  }
}
