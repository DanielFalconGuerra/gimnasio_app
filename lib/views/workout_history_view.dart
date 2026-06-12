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
    // LE DECIMOS A FLUTTER QUE JALE EL HISTORIAL DE FIRESTORE
    // JUSTO DESPUÉS DE QUE TERMINA DE DIBUJAR LA UI DE FORMA SEGURA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutsViewModel>(context, listen: false).loadHistory(); //
    });
  }

  @override
  Widget build(BuildContext context) {
    // ENVOLVEMOS LA UI EN UN CONSUMER PARA MANEJAR EL CONTEXTO CORRECTAMENTE
    return Consumer<WorkoutsViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Historial de Entrenamientos')),
          body: vm.isLoadingHistory //
              ? const Center(child: CircularProgressIndicator()) // Muestra carga mientras descarga de Firebase
              : vm.history.isEmpty //
              ? const Center(
            child: Text(
              'Aún no has registrado ningún entrenamiento.\n¡Comienza hoy!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
              : ListView.builder(
            itemCount: vm.history.length, //
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final Workout workout = vm.history[index]; //
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  title: Text(
                    workout.title, //
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${workout.createdAt.day}/${workout.createdAt.month}/${workout.createdAt.year} • ${workout.entries.length} ejercicios', //
                  ),
                  leading: const Icon(Icons.history_toggle_off, color: Colors.blue),
                  children: workout.entries.map((entry) { //
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              entry.exerciseName, //
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            '${entry.sets} x ${entry.reps} • ${entry.weight} kg', //
                            style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}