import 'package:flutter/material.dart';

import '../models/workout.dart';

class WorkoutDetailView extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailView({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Fecha: ${workout.createdAt.toLocal().toString().split('.').first}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Ejercicios realizados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: workout.entries.length,
                itemBuilder: (BuildContext context, int index) {
                  final entry = workout.entries[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(entry.exerciseName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('Series: ${entry.sets}   Reps: ${entry.reps}   Peso: ${entry.weight} kg'),
                              ],
                            ),
                          ),
                        ],
                      ),
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
