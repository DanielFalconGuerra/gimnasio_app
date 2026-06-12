import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/workouts_viewmodel.dart';
import '../models/workout.dart';

class WorkoutHistoryView extends StatefulWidget {
  const WorkoutHistoryView({super.key});

  @override
  State<WorkoutHistoryView> createState() => _WorkoutHistoryViewState();
}

class _WorkoutHistoryViewState extends State<WorkoutHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutsViewModel>(context, listen: false).loadHistory();
    });
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

    return Consumer<WorkoutsViewModel>(
      builder: (context, vm, child) {
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
              'Historial de Entrenamientos',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          body: vm.isLoadingHistory
              ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          )
              : vm.history.isEmpty
              ? _buildEmptyState(subtitleColor: subtitleColor, textColor: textColor, primaryColor: primaryColor)
              : ListView.builder(
            itemCount: vm.history.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final Workout workout = vm.history[index];

              // Formateo manual limpio para la fecha string (ej: 12 / 06 / 2026)
              final String day = workout.createdAt.day.toString().padLeft(2, '0');
              final String month = workout.createdAt.month.toString().padLeft(2, '0');
              final String year = workout.createdAt.year.toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16), // rounded-2xl
                  border: Border.all(color: borderColor, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  // Limpiamos los bordes y líneas por defecto que genera el ExpansionTile nativo
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                    ),
                  ),
                  child: ExpansionTile(
                    iconColor: primaryColor,
                    collapsedIconColor: hintColor,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4), // green-50 sutil de éxito
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF16A34A), size: 22), // green-600
                    ),
                    title: Text(
                      workout.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '$day/$month/$year  •  ${workout.entries.length} ejercicios',
                        style: TextStyle(color: subtitleColor, fontSize: 13),
                      ),
                    ),
                    // --- CUERPO DESPLEGABLE (Ejercicios y Series) ---
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC), // slate-50 interno (Panel de datos)
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor.withOpacity(0.6)),
                        ),
                        child: Column(
                          children: workout.entries.map((entry) {
                            final bool isLast = workout.entries.last == entry;
                            return Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.fitness_center_rounded, size: 14, color: hintColor),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            entry.exerciseName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500, // w500 (medium)
                                              color: textColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Badge técnico para los pesos y repeticiones
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Text(
                                      '${entry.sets}×${entry.reps} • ${entry.weight} kg',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Componente Auxiliar para un Empty State Premium
  Widget _buildEmptyState({
    required Color subtitleColor,
    required Color textColor,
    required Color primaryColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history_toggle_off_rounded, size: 48, color: primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              'Historial vacío',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no has registrado ningún entrenamiento de tu plan semanal en el gimnasio. ¡Tu esfuerzo cuenta, comienza hoy mismo!',
              textAlign: TextAlign.center,
              style: TextStyle(color: subtitleColor, fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}