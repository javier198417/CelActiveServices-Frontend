import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController =
      TextEditingController();

  final _correoController =
      TextEditingController();

  final _telefonoController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> registerUser() async {
  print('ENTRO A registerUser');

  try {
    const url =
        'http://192.168.1.183:5000/register';

    print('URL: $url');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': _nombreController.text.trim(),
        'correo': _correoController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'contrasena':
            _passwordController.text.trim(),
      }),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    return true;
  } catch (e) {
    print('ERROR COMPLETO: $e');
    rethrow;
  }
}
    Future<void> _registrar() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  final success = await registerUser();

  if (!mounted) return;

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          '✅ Usuario registrado correctamente',
        ),
      ),
    );

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    context.go('/login');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          '❌ Error al registrar usuario',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Usuario',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller:
                    _nombreController,
                decoration:
                    const InputDecoration(
                  labelText: 'Nombre',
                  border:
                      OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Ingrese su nombre';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller:
                    _correoController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Correo electrónico',
                  border:
                      OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Ingrese un correo';
                  }

                  if (!RegExp(
                    r'^[^@]+@[^@]+\.[^@]+$',
                  ).hasMatch(value)) {
                    return 'Correo inválido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller:
                    _telefonoController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Teléfono',
                  border:
                      OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller:
                    _passwordController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Contraseña',
                  border:
                      OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Ingrese una contraseña';
                  }

                  if (value.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller:
                    _confirmPasswordController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Confirmar contraseña',
                  border:
                      OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Confirme la contraseña';
                  }

                  if (value !=
                      _passwordController
                          .text) {
                    return 'Las contraseñas no coinciden';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed:
                    _registrar,
                child: const Text(
                  'Registrarse',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}