import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';  // Aquí importas el archivo de la pantalla de registro
import 'screens/welcome_screen.dart';
import 'screens/noti.dart';
import 'screens/registro_clientes.dart';  // Asegúrate de importar la pantalla de registro de clientes

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
        '/registroCliente': (context) => const RegistroClienteScreen(),  // Nueva ruta para la pantalla de registro de clientes
      },
    );
  }
}
