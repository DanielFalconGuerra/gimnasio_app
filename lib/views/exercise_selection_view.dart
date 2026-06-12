import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/workouts_viewmodel.dart';
import '../models/exercise.dart';

class ExerciseSelectionView extends StatefulWidget {
  const ExerciseSelectionView({super.key});

  @override
  State<ExerciseSelectionView> createState() => _ExerciseSelectionViewState();
}

class _ExerciseSelectionViewState extends State<ExerciseSelectionView> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutsViewModel vm = Provider.of<WorkoutsViewModel>(context);

    // --- PALETA TAILWIND CONSISTENTE ---
    final Color primaryColor    = const Color(0xFF4F46E5); // indigo-600
    final Color backgroundColor = const Color(0xFFF8FAFC); // slate-50
    final Color textColor       = const Color(0xFF1E293B); // slate-800
    final Color subtitleColor   = const Color(0xFF64748B); // slate-500
    final Color hintColor       = const Color(0xFF94A3B8); // slate-400
    final Color borderColor     = const Color(0xFFE2E8F0); // slate-200

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
          'Crear Nueva Rutina',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- ENCABEZADO: NOMBRE DE LA RUTINA ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre de la rutina',
                    style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Ej. Rutina de pierna / Empuje',
                      hintStyle: TextStyle(color: hintColor, fontSize: 14),
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
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Selecciona los ejercicios y ajusta tus cargas:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: subtitleColor, letterSpacing: 0.3),
              ),
            ),

            // --- LISTADO DE EJERCICIOS DISPONIBLES ---
            Expanded(
              child: ListView.builder(
                itemCount: vm.allExercises.length,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemBuilder: (BuildContext context, int index) {
                  final Exercise exercise = vm.allExercises[index];
                  final bool selected = vm.isSelected(exercise.id);
                  final selectedEntry = vm.entryFor(exercise.id);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      // Efecto anillo dinámico: cambia a color primario si está seleccionado
                      border: Border.all(
                        color: selected ? primaryColor : borderColor,
                        width: selected ? 2.0 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: selected ? primaryColor.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // RENGLÓN PRINCIPAL: Checkbox, Título e Icono
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: selected,
                                  activeColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (_) => vm.toggleExerciseSelection(exercise),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        exercise.name,
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)
                                    ),
                                    if (exercise.group.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                            exercise.group,
                                            style: TextStyle(color: subtitleColor, fontSize: 12, fontWeight: FontWeight.w500)
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                  Icons.fitness_center_rounded,
                                  color: selected ? primaryColor : hintColor.withOpacity(0.6),
                                  size: 20
                              ),
                            ],
                          ),

                          // PANEL DESPLEGABLE: Descripción e Inputs en Línea
                          if (selected && selectedEntry != null) ...<Widget>[
                            const SizedBox(height: 12),
                            Divider(color: borderColor, thickness: 1),
                            const SizedBox(height: 8),
                            Text(
                              exercise.description,
                              style: TextStyle(fontSize: 13, color: subtitleColor, height: 1.3),
                            ),
                            const SizedBox(height: 16),

                            // FORMULARIO EN LÍNEA COMPACTO (3 Columnas usando Row + Expanded)
                            Row(
                              children: <Widget>[
                                // Mini Input: Series
                                Expanded(
                                  child: _buildInlineInputField(
                                    labelText: 'Series',
                                    initialValue: selectedEntry.sets.toString(),
                                    primaryColor: primaryColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    onChanged: (String value) {
                                      final int? sets = int.tryParse(value);
                                      if (sets != null) vm.updateEntry(exerciseId: exercise.id, sets: sets);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Mini Input: Repeticiones
                                Expanded(
                                  child: _buildInlineInputField(
                                    labelText: 'Reps',
                                    initialValue: selectedEntry.reps.toString(),
                                    primaryColor: primaryColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    onChanged: (String value) {
                                      final int? reps = int.tryParse(value);
                                      if (reps != null) vm.updateEntry(exerciseId: exercise.id, reps: reps);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Mini Input: Peso
                                Expanded(
                                  child: _buildInlineInputField(
                                    labelText: 'Peso (kg)',
                                    initialValue: selectedEntry.weight.toString(),
                                    isDecimal: true,
                                    primaryColor: primaryColor,
                                    borderColor: borderColor,
                                    textColor: textColor,
                                    onChanged: (String value) {
                                      final double? weight = double.tryParse(value.replaceAll(',', '.'));
                                      if (weight != null) vm.updateEntry(exerciseId: exercise.id, weight: weight);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- BOTÓN DE ACCIÓN INFERIOR ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: vm.selectedEntries.isEmpty || vm.isSaving
                      ? null
                      : () async {
                    final bool success = await vm.saveWorkout(_titleController.text.trim());
                    if (!context.mounted) return;
                    final BuildContext safeContext = context;
                    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(safeContext);
                    if (success) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                              SizedBox(width: 10),
                              Text('Rutina guardada correctamente'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF059669), // Tailwind emerald-600
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      Navigator.pushReplacementNamed(safeContext, '/history');
                    } else {
                      messenger.showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.white),
                              SizedBox(width: 10),
                              Text('Error al guardar la rutina'),
                            ],
                          ),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryColor.withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: vm.isSaving
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : const Text('Guardar rutina', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper local para construir micro-inputs limpios y de altura uniforme para el Grid
  Widget _buildInlineInputField({
    required String labelText,
    required String initialValue,
    required Color primaryColor,
    required Color borderColor,
    required Color textColor,
    required ValueChanged<String> onChanged,
    bool isDecimal = false,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: isDecimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
      style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center, // Centrado de números estilo técnico
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        floatingLabelBehavior: FloatingLabelBehavior.always, // El label se queda fijo arriba de forma elegante
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        filled: true,
        fillColor: const Color(0xFFF8FAFC), // slate-50 de fondo interno
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}