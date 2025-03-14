import 'package:flutter/material.dart';
import 'carrito_de_compras.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Proteína en Polvo',
      description: 'Proteína de suero de leche para ganar masa muscular.',
      price: 25.99,
      imageUrl: 'assets/proteina.png', // Ruta de la imagen
    ),
    Product(
      id: '2',
      name: 'Creatina',
      description: 'Suplemento para mejorar el rendimiento deportivo.',
      price: 19.99,
      imageUrl: 'assets/creatina.png', // Ruta de la imagen
    ),
    Product(
      id: '3',
      name: 'BCAA',
      description:
          'Aminoácidos de cadena ramificada para recuperación muscular.',
      price: 15.99,
      imageUrl: 'assets/Bcaa.png', // Ruta de la imagen
    ),
  ];

  ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Image.asset(
              products[index].imageUrl, // Usa la imagen del producto
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(products[index].name),
            subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: products[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
