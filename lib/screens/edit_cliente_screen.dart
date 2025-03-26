// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditClienteScreen extends StatefulWidget {
  final String clienteId;
  final String nombre;
  final String apellido;
  final String telefono;
  final String tipoPago;
  final Timestamp fechaPago; // Cambiado a Timestamp
  final Timestamp fechaExpiracion; // Cambiado a Timestamp
  final String codigoCliente;

  const EditClienteScreen({
    Key? key,
    required this.clienteId,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.tipoPago,
    required this.fechaPago,
    required this.fechaExpiracion,
    required this.codigoCliente,
  }) : super(key: key);

  @override
  _EditClienteScreenState createState() => _EditClienteScreenState();
}

class _EditClienteScreenState extends State<EditClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _telefonoController;
  late TextEditingController _tipoPagoController;
  late TextEditingController _fechaPagoController;
  late TextEditingController _fechaExpiracionController;
  late TextEditingController _codigoClienteController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre);
    _apellidoController = TextEditingController(text: widget.apellido);
    _telefonoController = TextEditingController(text: widget.telefono);
    _tipoPagoController = TextEditingController(text: widget.tipoPago);
    _fechaPagoController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(widget.fechaPago.toDate())); // Formatear fecha
    _fechaExpiracionController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(widget.fechaExpiracion.toDate())); // Formatear fecha
    _codigoClienteController = TextEditingController(text: widget.codigoCliente);
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('clientes').doc(widget.clienteId).update({
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'telefono': _telefonoController.text,
        'tipo_pago': _tipoPagoController.text,
        'fecha_pago': Timestamp.fromDate(DateFormat('dd/MM/yyyy').parse(_fechaPagoController.text)), // Guardar como Timestamp
        'fecha_expiracion': Timestamp.fromDate(DateFormat('dd/MM/yyyy').parse(_fechaExpiracionController.text)), // Guardar como Timestamp
        'codigo_cliente': _codigoClienteController.text,
      });
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked); // Formato de fecha
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Envuelve en SingleChildScrollView
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                TextFormField(
                  controller: _tipoPagoController,
                  decoration: const InputDecoration(labelText: 'Tipo de Pago'),
                ),
                TextFormField(
                  controller: _fechaPagoController,
                  decoration: const InputDecoration(labelText: 'Fecha de Pago'),
                  onTap: () => _selectDate(context, _fechaPagoController), // Selector de fecha
                  readOnly: true, // Evita que el usuario escriba
                ),
                TextFormField(
                  controller: _fechaExpiracionController,
                  decoration: const InputDecoration(labelText: 'Fecha de Expiración'),
                  onTap: () => _selectDate(context, _fechaExpiracionController), // Selector de fecha
                  readOnly: true, // Evita que el usuario escriba
                ),
                TextFormField(
                  controller: _codigoClienteController,
                  decoration: const InputDecoration(labelText: 'Código de Cliente'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _guardarCambios,
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}