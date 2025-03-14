import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Para dar formato a las fechas
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';  // Para el selector de fechas

class RegistroClienteScreen extends StatefulWidget {
  const RegistroClienteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistroClienteScreenState createState() => _RegistroClienteScreenState();
}

class _RegistroClienteScreenState extends State<RegistroClienteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  String? _pagoSeleccionado = 'Dia'; // Valor por defecto
  DateTime? _fechaPago;
  DateTime? _fechaExpiracion;
  int _codigoCliente = 1; // Primer código

  @override
  void initState() {
    super.initState();
    _codigoController.text = _codigoCliente.toString().padLeft(3, '0');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombres'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese los nombres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese los apellidos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un teléfono';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _pagoSeleccionado,
                onChanged: (newValue) {
                  setState(() {
                    _pagoSeleccionado = newValue!;
                  });
                },
                items: ['Dia', 'Semana', 'Mes'].map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Tipo de Pago'),
              ),
              if (_pagoSeleccionado != 'Dia')
                TextFormField(
                  controller: _codigoController,
                  enabled: false,
                  decoration: const InputDecoration(labelText: 'Código Cliente'),
                ),
              ListTile(
                title: Text(
                    'Fecha de Pago: ${_fechaPago != null ? DateFormat('yyyy-MM-dd').format(_fechaPago!) : 'Seleccionar'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true, onConfirm: (date) {
                    setState(() {
                      _fechaPago = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
              ),
              ListTile(
                title: Text(
                    'Fecha de Expiración: ${_fechaExpiracion != null ? DateFormat('yyyy-MM-dd').format(_fechaExpiracion!) : 'Seleccionar'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true, onConfirm: (date) {
                    setState(() {
                      _fechaExpiracion = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí iría la lógica para registrar al cliente en la base de datos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cliente registrado'),
                      ),
                    );

                    // Incrementa el código para el siguiente cliente
                    setState(() {
                      _codigoCliente++;
                      _codigoController.text = _codigoCliente.toString().padLeft(3, '0');
                    });
                  }
                },
                child: const Text('Registrar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
