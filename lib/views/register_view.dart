import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authUtils = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    bool success = await authVM.register(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!context.mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authVM.errorMessage ?? 'Error al crear cuenta'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ENVOLVEMOS EN UN CONSUMER PARA ASOCIAR EL CONTEXTO DE FORMA SEGURA
    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Registrar cuenta')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo Institucional', border: OutlineInputBorder()),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Ingresa un correo';
                      if (!_authUtils.isInstitutional(value)) {
                        return 'Sólamente se permiten correos institucionales (edu/uni)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) return 'Ingresa una contraseña';
                      if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authVM.isLoading ? null : _submit,
                      child: authVM.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Registrar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}