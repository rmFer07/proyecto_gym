import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'models/product.dart' as product_model; // Usamos el alias product_model

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  // Definir la lista de productos usando la clase del modelo correcto.
  final List<product_model.Product> products = [
    product_model.Product(
      id: '1',
      name: 'Producto 1',
      description: 'Descripción del Producto 1',
      price: 10.0,
      imageUrl: 'assets/placeholder.png',
    ),
    product_model.Product(
      id: '2',
      name: 'Producto 2',
      description: 'Descripción del Producto 2',
      price: 20.0,
      imageUrl: 'assets/placeholder.png',
    ),
    // Agrega más productos según necesites.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.asset(
              product.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: product, // Aquí se usa el product_model.Product
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
