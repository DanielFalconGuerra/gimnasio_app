import 'package:flutter/foundation.dart';
import '../models/routine.dart';

class RoutinesViewModel extends ChangeNotifier {
  final List<Routine> _routines = <Routine>[
    Routine(
      id: 'r1',
      title: 'Circuito de Fuerza - Principiantes',
      type: RoutineType.fuerza,
      exercises: <String>['Sentadillas', 'Press de pecho con banda', 'Remo con banda'],
      durationMinutes: 20,
    ),
    Routine(
      id: 'r2',
      title: 'Cardio Resistencia - Corto',
      type: RoutineType.resistencia,
      exercises: <String>['Calentamiento 5 min', 'Intervalos 10x (30s/30s)'],
      durationMinutes: 15,
    ),
    Routine(
      id: 'r3',
      title: 'Acondicionamiento General',
      type: RoutineType.acondicionamiento,
      exercises: <String>['Burpees', 'Plancha', 'Saltos laterales'],
      durationMinutes: 12,
    ),
  ];

  List<Routine> get all => List.unmodifiable(_routines);

  List<Routine> byType(RoutineType type) => _routines.where((Routine r) => r.type == type).toList();

  Routine? findById(String id) {
    try {
      return _routines.firstWhere((Routine r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
