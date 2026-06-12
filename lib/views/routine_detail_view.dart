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
          routine.title,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- METADATOS DE LA RUTINA (Duración en un Badge) ---
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule_rounded, color: subtitleColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Duración: ${routine.durationMinutes} min',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500, // Equivale a medium (w500)
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // --- SUBTÍTULO SECCIÓN ---
              Text(
                'Ejercicios Incluidos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Toca cualquier ejercicio para ver advertencias o recomendaciones de seguridad.',
                style: TextStyle(fontSize: 13, color: subtitleColor),
              ),
              const SizedBox(height: 16),

              // --- LISTADO INTERACTIVO DE EJERCICIOS ---
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: routine.exercises
                        .map((exercise) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12), // rounded-xl
                          border: Border.all(color: borderColor, width: 1.0),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
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
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.fitness_center_rounded, size: 18, color: primaryColor),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      exercise,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500, // w500
                                        color: textColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Icono informativo estilizado como indicador de acción secundaria
                                  Icon(Icons.info_outline_rounded, size: 18, color: hintColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- BOTÓN PRINCIPAL ACCIÓN (CTA) ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => WarmupReminderDialog(
                        routineName: routine.title,
                        onStarted: () {
                          safetyVM.recordWorkout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('¡Rutina registrada! Buena suerte.'),
                                ],
                              ),
                              backgroundColor: const Color(0xFF059669), // Tailwind emerald-600
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 22),
                      SizedBox(width: 6),
                      Text(
                        'Iniciar rutina',
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
  }
}