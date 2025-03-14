import 'package:flutter/material.dart';

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: const ColorScheme.light(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.tealAccent),
      ),
      home: const ShoppingCartScreen(),
    );
  }
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final List<Product> products = [
    Product(
      name: "GALLETAS DE PROTEINA",
      price: 132.00,
      quantity: 1,
      id: '1',
      description: 'Galletas ricas en proteína para un mejor rendimiento.',
      imageUrl: 'assets/proteina.png',
    ),
    Product(
      name: "SUERO DE ELITE",
      price: 2600.00,
      quantity: 1,
      id: '2',
      description: 'Suero de alta calidad para mejorar tu fuerza.',
      imageUrl: 'assets/suero.png',
    ),
    Product(
      name: "ISOPURE 3 LB",
      price: 2497.00,
      quantity: 1,
      id: '3',
      description: 'Proteína pura sin carbohidratos.',
      imageUrl: 'assets/isopure.png',
    ),
    Product(
      name: "ISOTOPE 5 LB",
      price: 2699.00,
      quantity: 1,
      id: '4',
      description: 'Suplemento de proteína para rendimiento.',
      imageUrl: 'assets/isotope.png',
    ),
  ];

  double get total =>
      products.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void updateQuantity(int index, int change) {
    setState(() {
      products[index].quantity += change;
      if (products[index].quantity < 1) products[index].quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de Compras"),
        backgroundColor: Colors.teal,
        elevation: 5,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(12.0),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center,
                        color: Colors.teal, size: 30),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      "L${product.price.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.green[700], fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: () => updateQuantity(index, -1),
                        ),
                        Text(
                          "${product.quantity}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () => updateQuantity(index, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "L${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  int quantity;
  final String id;
  final String description;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.id,
    required this.description,
    required this.imageUrl,
  });
}
