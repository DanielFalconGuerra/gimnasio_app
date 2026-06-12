import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/workouts_viewmodel.dart';
import '../models/workout.dart';

class WeeklyPlanView extends StatefulWidget {
  const WeeklyPlanView({super.key});

  @override
  State<WeeklyPlanView> createState() => _WeeklyPlanViewState();
}

class _WeeklyPlanViewState extends State<WeeklyPlanView> {
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
    final Color borderColor     = const Color(0xFFE2E8F0); // slate-200
    final Color successColor    = const Color(0xFF16A34A); // green-600

    return Consumer<WorkoutsViewModel>(
      builder: (context, vm, child) {
        final DateTime now = DateTime.now();
        final DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
        final List<DateTime> weekDays = List<DateTime>.generate(7, (int index) => weekStart.add(Duration(days: index)));

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
                'Plan Semanal',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
            ),
            body: SafeArea(
              child: vm.isLoadingHistory
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
                    const SizedBox(height: 16),
                    Text('Sincronizando calendario...', style: TextStyle(color: subtitleColor, fontSize: 14)),
                  ],
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: <Widget>[
                    // --- DESCRIPCIÓN SUPERIOR ---
                    Text(
                      'Visualiza tu semana de entrenamiento y revisa las rutinas guardadas por día.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: subtitleColor, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 20),

                    // --- LISTA SEMANAL ---
                    Expanded(
                      child: ListView.builder(
                        itemCount: weekDays.length,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemBuilder: (BuildContext context, int index) {
                          final DateTime day = weekDays[index];
                          final List<Workout> workouts = vm.workoutsForDate(day);
                          final bool isToday = DateTime(day.year, day.month, day.day) == DateTime(now.year, now.month, now.day);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              // Destacamos el día de "Hoy" con un anillo/borde de la marca (ring-2 en Tailwind)
                              border: Border.all(
                                color: isToday ? primaryColor : borderColor,
                                width: isToday ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isToday ? primaryColor.withOpacity(0.04) : Colors.black.withOpacity(0.01),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // --- ENCABEZADO DEL DÍA ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${_dayLabel(day.weekday)} ${day.day}/${day.month}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isToday ? primaryColor : textColor,
                                        ),
                                      ),
                                      if (isToday)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'Hoy',
                                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // --- ESTADO 1: SIN ENTRENAMIENTOS ---
                                  if (workouts.isEmpty)
                                    Text(
                                      'No hay rutinas programadas para este día.',
                                      style: TextStyle(color: subtitleColor.withOpacity(0.7), fontSize: 13),
                                    ),

                                  // --- ESTADO 2: CON ENTRENAMIENTOS ---
                                  if (workouts.isNotEmpty)
                                    ...workouts.map((Workout workout) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC), // slate-50 sutil interno
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: borderColor),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      workout.title,
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.fitness_center_rounded, size: 12, color: subtitleColor),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          '${workout.entries.length} ejercicios completados',
                                                          style: TextStyle(fontSize: 12, color: subtitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFDCFCE7), // green-100 badge
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.check_rounded, color: successColor, size: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- BOTÓN INFERIOR ACCIÓN ---
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/select_exercises'),
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
                            Icon(Icons.add_rounded, size: 22),
                            SizedBox(width: 6),
                            Text(
                              'Crear nueva rutina',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
        },
    );
  }

  String _dayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Lunes';
      case DateTime.tuesday: return 'Martes';
      case DateTime.wednesday: return 'Miércoles';
      case DateTime.thursday: return 'Jueves';
      case DateTime.friday: return 'Viernes';
      case DateTime.saturday: return 'Sábado';
      case DateTime.sunday: return 'Domingo';
      default: return '';
    }
  }
}