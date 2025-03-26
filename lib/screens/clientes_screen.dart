// ignore_for_file: unused_local_variable, use_super_parameters, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_gym/screens/edit_cliente_screen.dart';
import 'registro_clientes.dart';
import 'package:intl/intl.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({Key? key}) : super(key: key);

  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const RegistroClienteScreen(
                        clienteId: '',
                        apellido: null,
                        nombre: null,
                        telefono: null,
                        tipoPago: null,
                        fechaPago: null,
                        fechaExpiracion: null,
                        codigoCliente: null,
                      ),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Buscar cliente',
                hintText: 'Nombre, Apellido, Teléfono...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection('clientes')
                .orderBy('nombre') // Ordenando por 'nombre'
                .snapshots(),
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

          final filteredClients =
              clientes.where((cliente) {
                final clienteData = cliente.data() as Map<String, dynamic>;
                final nombre = (clienteData['nombre'] ?? '').toLowerCase();
                final apellido = (clienteData['apellido'] ?? '').toLowerCase();
                final telefono = (clienteData['telefono'] ?? '').toLowerCase();

                return nombre.contains(_searchQuery) ||
                    apellido.contains(_searchQuery) ||
                    telefono.contains(_searchQuery);
              }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              final cliente =
                  filteredClients[index].data() as Map<String, dynamic>;
              final clienteId = filteredClients[index].id;
              final nombre = cliente['nombre'] ?? 'Sin nombre';
              final apellido = cliente['apellido'] ?? '';
              final telefono = cliente['telefono'] ?? 'Sin teléfono';
              final tipoPago = cliente['tipo_pago'] ?? 'No especificado';

              final fechaExpiracion = cliente['fecha_expiracion'];
              final fechaActual = DateTime.now();

              // Asegurémonos de que estamos comparando solo la parte de la fecha, no la hora.
              bool fechaIgual =
                  (fechaExpiracion is Timestamp) &&
                  (fechaExpiracion.toDate().year == fechaActual.year &&
                      fechaExpiracion.toDate().month == fechaActual.month &&
                      fechaExpiracion.toDate().day == fechaActual.day);

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  title: Text(
                    '$nombre $apellido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: fechaIgual ? Colors.red : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Teléfono: $telefono',
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () => _mostrarInformacionCliente(cliente, clienteId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => EditClienteScreen(
                                    clienteId: clienteId,
                                    apellido: cliente['apellido'],
                                    nombre: cliente['nombre'],
                                    telefono: cliente['telefono'],
                                    tipoPago: cliente['tipo_pago'],
                                    fechaPago: _convertirFecha(
                                      cliente['fecha_pago'],
                                    ),
                                    fechaExpiracion: _convertirFecha(
                                      cliente['fecha_expiracion'],
                                    ),
                                    codigoCliente:
                                        cliente['codigo_cliente']!.toString(),
                                  ),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _confirmarEliminacion(clienteId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatearFecha(dynamic fecha) {
    if (fecha == null) return 'No disponible';
    if (fecha is Timestamp) {
      return DateFormat('dd/MM/yyyy').format(fecha.toDate());
    }
    if (fecha is String) {
      try {
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(fecha));
      } catch (_) {
        return fecha;
      }
    }
    return 'Formato desconocido';
  }

  Timestamp _convertirFecha(dynamic fecha) {
    if (fecha is Timestamp) {
      return fecha;
    }
    if (fecha is String) {
      try {
        return Timestamp.fromDate(DateTime.parse(fecha));
      } catch (_) {
        return Timestamp.now();
      }
    }
    return Timestamp.now();
  }

  Future<void> _mostrarInformacionCliente(
    Map<String, dynamic> cliente,
    String clienteId,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            '${cliente['nombre']} ${cliente['apellido']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📞 Teléfono: ${cliente['telefono']}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '💳 Tipo de Pago: ${cliente['tipo_pago']}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '📅 Fecha de Pago: ${_formatearFecha(cliente['fecha_pago'])}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '⏳ Fecha de Expiración: ${_formatearFecha(cliente['fecha_expiracion'])}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminacion(String clienteId) async {
    await _firestore.collection('clientes').doc(clienteId).delete();
    setState(() {});
  }
}
