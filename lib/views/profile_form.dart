import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';
import '../widgets/custom_text_field.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();
  String _level = 'Principiante';

  @override
  void initState() {
    super.initState();
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null && userEmail.isNotEmpty) {
      _emailCtrl.text = userEmail;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  bool _isInstitutional(String email) {
    if (!email.contains('@')) return false;
    final String lower = email.toLowerCase();
    return lower.contains('edu') || lower.contains('uni');
  }

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel vm = context.read<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del alumno')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                label: 'Correo institucional',
                keyboardType: TextInputType.emailAddress,
                initialValue: _emailCtrl.text,
                onChanged: (String v) => _emailCtrl.text = v,
                validator: (String? v) {
                  if (v == null || v.isEmpty) return 'Ingrese correo institucional';
                  if (!_isInstitutional(v)) return 'Use su correo institucional (edu/uni)';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Edad',
                keyboardType: TextInputType.number,
                validator: (String? v) {
                  if (v == null || v.isEmpty) return 'Ingrese edad';
                  final int? n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Edad inválida';
                  return null;
                },
                onChanged: (String v) {},
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Peso (kg)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (String? v) {
                  if (v == null || v.isEmpty) return 'Ingrese peso';
                  final double? n = double.tryParse(v.replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Peso inválido';
                  return null;
                },
                onChanged: (String v) {},
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Estatura (cm)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (String? v) {
                  if (v == null || v.isEmpty) return 'Ingrese estatura';
                  final double? n = double.tryParse(v.replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Estatura inválida';
                  return null;
                },
                onChanged: (String v) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _level,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'Principiante', child: Text('Principiante')),
                  DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
                  DropdownMenuItem(value: 'Avanzado', child: Text('Avanzado')),
                ],
                onChanged: (String? v) => setState(() => _level = v ?? 'Principiante'),
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Nivel'),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final String email = _emailCtrl.text.isNotEmpty ? _emailCtrl.text : '';
                        vm.updateEmail(email);
                        vm.updateAge(int.tryParse(_ageCtrl.text));
                        vm.updateWeight(double.tryParse(_weightCtrl.text.replaceAll(',', '.')));
                        vm.updateHeight(double.tryParse(_heightCtrl.text.replaceAll(',', '.')));
                        vm.updateLevel(_level);

                        final bool ok = await vm.saveProfile();
                        if (!context.mounted) return;
                        final BuildContext safeContext = context;
                        final ScaffoldMessengerState messenger = ScaffoldMessenger.of(safeContext);
                        if (ok) {
                          messenger.showSnackBar(const SnackBar(content: Text('Perfil guardado')));
                          Navigator.pop(safeContext);
                        } else {
                          messenger.showSnackBar(const SnackBar(content: Text('Error al guardar')));
                        }
                      },
                      child: const Text('Guardar perfil'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
