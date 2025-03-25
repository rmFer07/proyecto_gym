// ignore_for_file: library_private_types_in_public_api, use_super_parameters, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'registro_clientes.dart'; // Asegúrate de importar la pantalla de registro

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({Key? key}) : super(key: key);

  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistroClienteScreen(clienteId: '', apellido: null, nombre: null, telefono: null, tipoPago: null, fechaPago: null, fechaExpiracion: null, codigoCliente: null,),
                ),
              ).then((_) {
                setState(() {}); // Actualiza la lista al volver
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('clientes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos.'));
          }

          final clientes = snapshot.data?.docs ?? [];
          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados.'));
          }

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index].data() as Map<String, dynamic>;
              final clienteId = clientes[index].id; // Obtener el ID del cliente
              final nombre = cliente['nombre'] ?? 'Nombre no disponible';
              final apellido = cliente['apellido'] ?? 'Apellido no disponible';
              final telefono = cliente['telefono'] ?? 'Teléfono no disponible';

              return ListTile(
                title: Text('$nombre $apellido'),
                subtitle: Text('Teléfono: $telefono'),
                onTap: () {
                  _mostrarInformacionCliente(cliente, clienteId);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistroClienteScreen(
                              clienteId: clienteId,
                              nombre: nombre,
                              apellido: apellido,
                              telefono: telefono,
                              tipoPago: cliente['tipo_pago'],
                              fechaPago: cliente['fecha_pago'],
                              fechaExpiracion: cliente['fecha_expiracion'],
                              codigoCliente: cliente['codigo_cliente'],
                            ),
                          ),
                        ).then((_) {
                          setState(() {}); // Actualiza la lista al volver
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _eliminarCliente(clienteId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _mostrarInformacionCliente(Map<String, dynamic> cliente, String clienteId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${cliente['nombre']} ${cliente['apellido']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Teléfono: ${cliente['telefono']}'),
              Text('Tipo de Pago: ${cliente['tipo_pago']}'),
              Text('Fecha de Pago: ${cliente['fecha_pago']}'),
              Text('Fecha de Expiración: ${cliente['fecha_expiracion']}'),
              Text('Código Cliente: ${cliente['codigo_cliente']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarCliente(String clienteId) async {
    try {
      await _firestore.collection('clientes').doc(clienteId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente eliminado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar cliente: $e')),
      );
    }
  }
}