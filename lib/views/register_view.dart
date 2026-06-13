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
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(authVM.errorMessage ?? 'Error al crear cuenta')),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PALETA TAILWIND CONSISTENTE ---
    final Color primaryColor    = const Color(0xFF4F46E5); // indigo-600
    final Color backgroundColor = const Color(0xFFF8FAFC); // slate-50
    final Color textColor       = const Color(0xFF1E293B); // slate-800
    final Color subtitleColor   = const Color(0xFF64748B); // slate-500
    final Color hintColor       = const Color(0xFF94A3B8); // slate-400
    final Color borderColor     = const Color(0xFFE2E8F0); // slate-200

    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // <-- CORREGIDO AQUÍ
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // --- ENCABEZADO VISUAL ---
                      Text(
                        'Crea tu cuenta',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Únete a la plataforma institucional ingresando tus datos.',
                        style: TextStyle(
                          fontSize: 15,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // --- INPUT DE CORREO INSTITUCIONAL ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Correo Institucional',
                            style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Solo .edu / .uni',
                              style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: textColor),
                        decoration: _buildInputDecoration(
                          hintText: 'tu.nombre@universidad.edu',
                          prefixIcon: Icons.school_outlined, // <-- CORREGIDO AQUÍ
                          primaryColor: primaryColor,
                          hintColor: hintColor,
                          borderColor: borderColor,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) return 'Ingresa un correo';
                          if (!_authUtils.isInstitutional(value)) {
                            return 'Sólamente se permiten correos institucionales';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // --- INPUT DE CONTRASEÑA ---
                      Text(
                        'Contraseña',
                        style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: textColor),
                        decoration: _buildInputDecoration(
                          hintText: 'Mínimo 6 caracteres',
                          prefixIcon: Icons.lock_outline_rounded,
                          primaryColor: primaryColor,
                          hintColor: hintColor,
                          borderColor: borderColor,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) return 'Ingresa una contraseña';
                          if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // --- BOTÓN DE REGISTRO ---
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authVM.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: primaryColor.withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: authVM.isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Registrarse',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- VOLVER AL LOGIN ---
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(foregroundColor: primaryColor),
                          child: RichText(
                            text: TextSpan(
                              text: '¿Ya tienes una cuenta? ',
                              style: TextStyle(color: subtitleColor, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Inicia sesión',
                                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper Reutilizable para mantener consistencia en los inputs
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    required Color primaryColor,
    required Color hintColor,
    required Color borderColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: hintColor, size: 22),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}