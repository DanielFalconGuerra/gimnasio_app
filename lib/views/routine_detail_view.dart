import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/routine.dart';
import '../viewmodels/safety_viewmodel.dart';
import 'warmup_reminder_dialog.dart';
import 'exercise_warning_dialog.dart';

class RoutineDetailView extends StatelessWidget {
  final Routine routine;

  const RoutineDetailView({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final safetyVM = Provider.of<SafetyViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(routine.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duración: ${routine.durationMinutes} min', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            const Text('Ejercicios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: routine.exercises
                      .map((exercise) => GestureDetector(
                    onTap: () {
                      final warning = safetyVM.getWarningForExercise(exercise);
                      if (warning != null) {
                        showDialog(
                          context: context,
                          builder: (_) => ExerciseWarningDialog(warning: warning),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.fitness_center, size: 18),
                            const SizedBox(width: 8),
                            // El Expanded aquí previene cualquier overflow secundario
                            Expanded(
                              child: Text(
                                exercise,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar rutina'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => WarmupReminderDialog(
                      routineName: routine.title,
                      onStarted: () {
                        safetyVM.recordWorkout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Buena suerte con tu rutina!')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}