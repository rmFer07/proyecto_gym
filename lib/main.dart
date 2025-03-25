import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_gym/firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/noti.dart';
import 'screens/registro_clientes.dart';
import 'screens/carrito_de_compras.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/models/product.dart' as product_model;
import 'screens/providers/cart_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Valhalla Gym',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/notifications': (context) => NotificationScreen(),
        '/registroCliente': (context) => const RegistroClienteScreen(clienteId: '', apellido: null, nombre: null, telefono: null, tipoPago: null, fechaPago: null, fechaExpiracion: null, codigoCliente: null,),
        '/shoppingCart': (context) => const ShoppingCartScreen(),
        '/product-list': (context) => ProductListScreen(),
        '/product-detail': (context) => ProductDetailScreen(
          product: product_model.Product(
            id: '', 
            name: '', 
            description: '', 
            price: 0.0, 
            imageUrl: '',
          ),
        ),
      },
    );
  }
}