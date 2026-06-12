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

  // Controladores alineados perfectamente con tu modelo Profile
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late String _selectedLevel;

  // Lista de opciones para el Dropdown de nivel escolar/entrenamiento
  final List<String> _levels = ['Principiante', 'Intermedio', 'Avanzado'];

  @override
  void initState() {
    super.initState();
    final profileVM = Provider.of<ProfileViewModel>(context, listen: false);
    final currentProfile = profileVM.profile;

    // Asignación segura de campos numéricos y opcionales
    _ageController = TextEditingController(
      text: currentProfile.age != null ? currentProfile.age.toString() : '',
    );
    _weightController = TextEditingController(
      text: currentProfile.weight != null ? currentProfile.weight.toString() : '',
    );
    _heightController = TextEditingController(
      text: currentProfile.height != null ? currentProfile.height.toString() : '',
    );

    // Validamos que el nivel actual exista en nuestra lista, si no, por defecto 'Principiante'
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

    // Inyección directa y segura respetando los tipos de datos del modelo
    currentProfile.age = int.tryParse(_ageController.text);
    currentProfile.weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    currentProfile.height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    currentProfile.level = _selectedLevel;

    // Disparamos la persistencia asíncrona hacia Firestore
    bool success = await vm.saveProfile();

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    final messenger = ScaffoldMessenger.of(context);
    if (success) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('¡Datos del alumno actualizados en Firestore!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Regresa en limpio al WelcomeView
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Error al guardar los datos en el servidor'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileVM, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil del Alumno'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Tarjeta superior informativa de la cuenta institucional
                  Card(
                    elevation: 0,
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.school, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cuenta de Acceso',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                ),
                                Text(
                                  profileVM.profile.email.isNotEmpty ? profileVM.profile.email : 'No disponible',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'COMPOSICIÓN FÍSICA Y CONTROL',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Campo: Edad
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Edad (Años)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa tu edad';
                      final val = int.tryParse(value);
                      if (val == null || val <= 0 || val > 90) return 'Ingresa una edad válida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Peso
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Peso Actual (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight_outlined),
                      hintText: 'Ej: 75.5',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa tu peso';
                      final val = double.tryParse(value.replaceAll(',', '.'));
                      if (val == null || val <= 10) return 'Ingresa un peso válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Estatura
                  TextFormField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Estatura (m)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.height),
                      hintText: 'Ej: 1.75',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa tu estatura';
                      final val = double.tryParse(value.replaceAll(',', '.'));
                      if (val == null || val <= 0.5 || val > 2.5) return 'Ingresa una estatura válida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Selector Dinámico: Nivel de Condición
                  DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    decoration: const InputDecoration(
                      labelText: 'Nivel de Condición Física',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
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
                  const SizedBox(height: 32),

                  // Botón de guardado
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: _isProcessing
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save),
                      label: Text(
                        _isProcessing ? 'Sincronizando...' : 'Guardar Cambios',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _isProcessing ? null : () => _submitData(profileVM),
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