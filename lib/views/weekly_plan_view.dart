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
    // 🛠️ CANDADO ASÍNCRONO SEGURO:
    // Forzamos la descarga del historial de entrenamientos de Firestore
    // inmediatamente después de que se dibuja el primer frame de la UI.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutsViewModel>(context, listen: false).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos todo en un Consumer para que la UI reaccione de inmediato
    // en cuanto Firebase termine de responder.
    return Consumer<WorkoutsViewModel>(
      builder: (context, vm, child) {
        final DateTime now = DateTime.now();
        // Calculamos el inicio de la semana actual (Lunes)
        final DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
        final List<DateTime> weekDays = List<DateTime>.generate(7, (int index) => weekStart.add(Duration(days: index)));

        return Scaffold(
          appBar: AppBar(title: const Text('Plan Semanal')),
          body: vm.isLoadingHistory // 🔄 Estado de carga centralizado
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Sincronizando calendario con Firestore...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const Text(
                  'Visualiza tu semana de entrenamiento y revisa las rutinas guardadas por día.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: weekDays.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DateTime day = weekDays[index];
                      final List<Workout> workouts = vm.workoutsForDate(day);
                      final bool isToday = DateTime(day.year, day.month, day.day) == DateTime(now.year, now.month, now.day);

                      return Card(
                        color: isToday ? Colors.blue.shade50 : null,
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: isToday ? 2 : 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${_dayLabel(day.weekday)} ${day.day}/${day.month}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isToday ? Colors.blue.shade900 : null,
                                    ),
                                  ),
                                  if (isToday)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('Hoy', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (workouts.isEmpty)
                                const Text(
                                  'Aún no hay rutinas programadas para este día.',
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              if (workouts.isNotEmpty)
                                ...workouts.map((Workout workout) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey.shade200),
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
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  '${workout.entries.length} ejercicios realizados',
                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Crear nueva rutina', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.pushNamed(context, '/select_exercises'),
                  ),
                ),
              ],
            ),
          ),
        );
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