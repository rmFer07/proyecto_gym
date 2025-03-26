// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_gym/main.dart' show showNotification;

class RegistroClienteScreen extends StatefulWidget {
  const RegistroClienteScreen({
    super.key,
    required String clienteId,
    required apellido,
    required nombre,
    required telefono,
    required tipoPago,
    required fechaPago,
    required fechaExpiracion,
    required codigoCliente,
  });

  @override
  _RegistroClienteScreenState createState() => _RegistroClienteScreenState();
}

class _RegistroClienteScreenState extends State<RegistroClienteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  String? _pagoSeleccionado = 'Dia';
  DateTime? _fechaPago;
  DateTime? _fechaExpiracion;

  @override
  void initState() {
    super.initState();
    _codigoController.text = '001'; // Inicializa el código en 001
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _seleccionarFecha(BuildContext context, Function(DateTime) onSelected) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          onSelected(date);
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.es,
    );
  }

  Future<void> _registrarCliente() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaExpiracion != null &&
          _fechaPago != null &&
          _fechaExpiracion!.isBefore(_fechaPago!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La fecha de expiración debe ser posterior a la fecha de pago.',
            ),
          ),
        );
        return;
      }

      try {
        // Generar un nuevo código de cliente
        int nuevoCodigoCliente = await _generarCodigoCliente();

        await FirebaseFirestore.instance.collection('clientes').add({
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'telefono': _telefonoController.text,
          'tipo_pago': _pagoSeleccionado,
          'fecha_pago': _fechaPago?.toIso8601String(),
          'fecha_expiracion': _fechaExpiracion?.toIso8601String(),
          'codigo_cliente': nuevoCodigoCliente,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente registrado correctamente!')),
        );

        // Llamar a la notificación
        showNotification(
          "Cliente Registrado",
          "El cliente ${_nombreController.text} ha sido registrado correctamente.",
        );

        setState(() {
          _codigoController.text = nuevoCodigoCliente.toString().padLeft(
            3,
            '0',
          );
          _nombreController.clear();
          _apellidoController.clear();
          _telefonoController.clear();
          _pagoSeleccionado = 'Dia';
          _fechaPago = null;
          _fechaExpiracion = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar cliente: $e')),
        );
      }
    }
  }

  Future<int> _generarCodigoCliente() async {
    // Obtén todos los documentos de la colección 'clientes'
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('clientes').get();

    // Extrae los códigos de cliente existentes
    List<int> codigosExistentes =
        snapshot.docs.map((doc) {
          try {
            // Intenta convertir a int
            return doc['codigo_cliente'] is int
                ? doc['codigo_cliente'] as int
                : int.tryParse(doc['codigo_cliente'].toString()) ?? 0;
          } catch (e) {
            // ignore: avoid_print
            print('Error al convertir el código: $e');
            return 0; // Si ocurre un error, asignamos un valor por defecto
          }
        }).toList();

    // Encuentra el siguiente código disponible
    int nuevoCodigo = 1; // Comienza desde 1 o el número que desees
    while (codigosExistentes.contains(nuevoCodigo)) {
      nuevoCodigo++;
    }

    return nuevoCodigo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un teléfono';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _pagoSeleccionado,
                items:
                    <String>[
                      'Dia',
                      'Semana',
                      'Mes',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _pagoSeleccionado = newValue;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo de Pago'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _seleccionarFecha(context, (fecha) {
                    setState(() {
                      _fechaPago = fecha;
                    });
                  });
                },
                child: Text(
                  _fechaPago == null
                      ? 'Seleccionar Fecha de Pago'
                      : 'Fecha de Pago: ${DateFormat('dd/MM/yyyy').format(_fechaPago!)}',
                ),
              ),
              TextButton(
                onPressed: () {
                  _seleccionarFecha(context, (fecha) {
                    setState(() {
                      _fechaExpiracion = fecha;
                    });
                  });
                },
                child: Text(
                  _fechaExpiracion == null
                      ? 'Seleccionar Fecha de Expiración'
                      : 'Fecha de Expiración: ${DateFormat('dd/MM/yyyy').format(_fechaExpiracion!)}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarCliente,
                child: const Text('Registrar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
