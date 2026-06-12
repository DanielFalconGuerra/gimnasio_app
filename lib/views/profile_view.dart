import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late String _selectedLevel;

  final List<String> _levels = ['Principiante', 'Intermedio', 'Avanzado'];

  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final currentProfile = profileVM.profile;

    _ageController = TextEditingController(
      text: currentProfile.age != null ? currentProfile.age.toString() : '',
    );
    _weightController = TextEditingController(
      text: currentProfile.weight != null ? currentProfile.weight.toString() : '',
    );
    _heightController = TextEditingController(
      text: currentProfile.height != null ? currentProfile.height.toString() : '',
    );

    _selectedLevel = _levels.contains(currentProfile.level)
        ? currentProfile.level
        : 'Principiante';
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _submitData(ProfileViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    final currentProfile = vm.profile;

    currentProfile.age = int.tryParse(_ageController.text);
    currentProfile.weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    currentProfile.height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    currentProfile.level = _selectedLevel;

    bool success = await vm.saveProfile();

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    final messenger = ScaffoldMessenger.of(context);
    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('¡Perfil actualizado con éxito!'),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Error al guardar los datos en el servidor'),
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

    return Consumer<ProfileViewModel>(
      builder: (context, profileVM, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Perfil del Alumno',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // --- TARJETA DE CUENTA (Estilo Banner Minimalista) ---
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Icon(Icons.school_outlined, color: primaryColor, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CUENTA INSTITUCIONAL',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subtitleColor, letterSpacing: 0.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profileVM.profile.email.isNotEmpty ? profileVM.profile.email : 'No disponible',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- SECCIÓN: COMPOSICIÓN FÍSICA ---
                  Text(
                    'COMPOSICIÓN FÍSICA Y CONTROL',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: subtitleColor, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: borderColor, thickness: 1),
                  const SizedBox(height: 16),

                  // Fila de dos columnas para optimizar espacio (Edad y Peso)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subcampo: Edad
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Edad (Años)', style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 13)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: textColor),
                              decoration: _buildInputDecoration(hintText: 'Ej: 21', prefixIcon: Icons.cake_outlined, hintColor: hintColor, borderColor: borderColor, primaryColor: primaryColor),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Requerido';
                                final val = int.tryParse(value);
                                if (val == null || val <= 0 || val > 90) return 'Inválido';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Subcampo: Peso
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Peso (kg)', style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 13)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _weightController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: TextStyle(color: textColor),
                              decoration: _buildInputDecoration(hintText: 'Ej: 72.5', prefixIcon: Icons.monitor_weight_outlined, hintColor: hintColor, borderColor: borderColor, primaryColor: primaryColor),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Requerido';
                                final val = double.tryParse(value.replaceAll(',', '.'));
                                if (val == null || val <= 10) return 'Inválido';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Campo: Estatura
                  Text('Estatura (Metros)', style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: textColor),
                    decoration: _buildInputDecoration(hintText: 'Ej: 1.75', prefixIcon: Icons.height_rounded, hintColor: hintColor, borderColor: borderColor, primaryColor: primaryColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa tu estatura';
                      final val = double.tryParse(value.replaceAll(',', '.'));
                      if (val == null || val <= 0.5 || val > 2.5) return 'Ingresa una estatura válida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Selector: Nivel de Condición
                  Text('Nivel de Condición Física', style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 13)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    style: TextStyle(color: textColor, fontSize: 15),
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: hintColor),
                    decoration: _buildInputDecoration(hintText: '', prefixIcon: Icons.fitness_center_rounded, hintColor: hintColor, borderColor: borderColor, primaryColor: primaryColor),
                    items: _levels.map((String level) {
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLevel = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 36),

                  // --- BOTÓN PRINCIPAL DE GUARDADO ---
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : () => _submitData(profileVM),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: primaryColor.withOpacity(0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Guardar Cambios',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

  // Helper de diseño unificado para Inputs
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
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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