import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/noti.dart';
import 'screens/registro_clientes.dart';
import 'screens/carrito_de_compras.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Valhalla Gym',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/registroCliente': (context) => const RegistroClienteScreen(),
        '/shoppingCart': (context) => const ShoppingCartScreen(),
        '/product-list': (context) => ProductListScreen(),
        '/product-detail': (context) => ProductDetailScreen(product: Product(id: '', name: '', description: '', price: 0.0, imageUrl: '')),
      },
    );
  }
}
