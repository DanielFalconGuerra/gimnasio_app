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

    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar ejercicios')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de la rutina',
                hintText: 'Ej. Rutina de pierna',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vm.allExercises.length,
              itemBuilder: (BuildContext context, int index) {
                final Exercise exercise = vm.allExercises[index];
                final bool selected = vm.isSelected(exercise.id);
                final selectedEntry = vm.entryFor(exercise.id);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: selected,
                              onChanged: (_) => vm.toggleExerciseSelection(exercise),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(exercise.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  if (exercise.group.isNotEmpty) Text(exercise.group, style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.fitness_center, color: Colors.blue),
                          ],
                        ),
                        if (selected && selectedEntry != null) ...<Widget>[
                          const SizedBox(height: 12),
                          Text(exercise.description),
                          const SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  initialValue: selectedEntry.sets.toString(),
                                  decoration: const InputDecoration(labelText: 'Series', border: OutlineInputBorder()),
                                  keyboardType: TextInputType.number,
                                  onChanged: (String value) {
                                    final int? sets = int.tryParse(value);
                                    if (sets != null) vm.updateEntry(exerciseId: exercise.id, sets: sets);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  initialValue: selectedEntry.reps.toString(),
                                  decoration: const InputDecoration(labelText: 'Reps', border: OutlineInputBorder()),
                                  keyboardType: TextInputType.number,
                                  onChanged: (String value) {
                                    final int? reps = int.tryParse(value);
                                    if (reps != null) vm.updateEntry(exerciseId: exercise.id, reps: reps);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: selectedEntry.weight.toString(),
                            decoration: const InputDecoration(labelText: 'Peso (kg)', border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (String value) {
                              final double? weight = double.tryParse(value.replaceAll(',', '.'));
                              if (weight != null) vm.updateEntry(exerciseId: exercise.id, weight: weight);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: vm.selectedEntries.isEmpty || vm.isSaving
                        ? null
                        : () async {
                            final bool success = await vm.saveWorkout(_titleController.text.trim());
                            if (!context.mounted) return;
                            final BuildContext safeContext = context;
                            final ScaffoldMessengerState messenger = ScaffoldMessenger.of(safeContext);
                            if (success) {
                              messenger.showSnackBar(const SnackBar(content: Text('Rutina guardada correctamente')));
                              Navigator.pushReplacementNamed(safeContext, '/history');
                            } else {
                              messenger.showSnackBar(const SnackBar(content: Text('Error al guardar la rutina')));
                            }
                          },
                    child: vm.isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Guardar rutina'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
