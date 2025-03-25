// ignore_for_file: library_private_types_in_public_api, use_super_parameters, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String _searchQuery = ''; // Almacena el texto de búsqueda

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
                  builder: (context) => const RegistroClienteScreen(
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
          preferredSize: Size.fromHeight(50),
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
        stream: _firestore
            .collection('clientes')
            .orderBy('codigo_cliente', descending: false) // Ordena por código
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

          // Filtrar clientes según la búsqueda
          final filteredClients = clientes.where((cliente) {
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
              final fechaPago = cliente['fecha_pago'] ?? 'No disponible';
              final fechaExpiracion =
                  cliente['fecha_expiracion'] ?? 'No disponible';
              final codigoCliente = cliente['codigo_cliente'] ?? 'Sin código';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text('$nombre $apellido',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  subtitle: Text('Código: $codigoCliente - Teléfono: $telefono',
                      style: const TextStyle(fontSize: 14)),
                  onTap: () => _mostrarInformacionCliente(cliente, clienteId),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistroClienteScreen(
                                clienteId: clienteId,
                                nombre: nombre,
                                apellido: apellido,
                                telefono: telefono,
                                tipoPago: tipoPago,
                                fechaPago: fechaPago,
                                fechaExpiracion: fechaExpiracion,
                                codigoCliente: codigoCliente,
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

  Future<void> _mostrarInformacionCliente(
      Map<String, dynamic> cliente, String clienteId) async {
    String formatearFecha(dynamic fecha) {
      if (fecha == null) {
        return 'No disponible';
      }
      if (fecha is Timestamp) {
        return DateFormat('dd/MM/yyyy')
            .format(fecha.toDate()); // Convierte Timestamp a String
      }
      if (fecha is String) {
        try {
          DateTime fechaConvertida =
              DateTime.parse(fecha); // Convierte String a DateTime
          return DateFormat('dd/MM/yyyy').format(fechaConvertida);
        } catch (e) {
          return fecha; // Si no se puede convertir, devuelve el texto original
        }
      }
      return 'Formato desconocido';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text('${cliente['nombre']} ${cliente['apellido']}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📞 Teléfono: ${cliente['telefono']}',
                  style: const TextStyle(fontSize: 16)),
              Text('💳 Tipo de Pago: ${cliente['tipo_pago']}',
                  style: const TextStyle(fontSize: 16)),
              Text('📅 Fecha de Pago: ${formatearFecha(cliente['fecha_pago'])}',
                  style: const TextStyle(fontSize: 16)),
              Text(
                  '⏳ Fecha de Expiración: ${formatearFecha(cliente['fecha_expiracion'])}',
                  style: const TextStyle(fontSize: 16)),
              Text('🔢 Código Cliente: ${cliente['codigo_cliente']}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminacion(String clienteId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Confirmar Eliminación',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este cliente? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                _eliminarCliente(clienteId);
                Navigator.pop(context);
              },
              child: const Text('Eliminar',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarCliente(String clienteId) async {
    await _firestore.collection('clientes').doc(clienteId).delete();
    setState(() {});
  }
}
