import 'package:flutter/material.dart';
import 'models/product.dart'; 

class ProductDetailScreen extends StatelessWidget {
  final Product product; // Cambia el tipo de Product? a Product (no nullable)

  // Ahora no se permite un Product nulo
  const ProductDetailScreen({super.key, required this.product}); // Cambié 'this.product' a 'required'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name), // Aquí no es necesario el operador null-aware
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              product.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}