import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/exercise.dart';
import '../models/workout.dart';
import '../services/firestore_service.dart';

class WorkoutsViewModel extends ChangeNotifier {
  final List<Exercise> allExercises = const <Exercise>[
    Exercise(id: 'e1', name: 'Sentadillas', group: 'Pierna', description: 'Piernas y glúteos'),
    Exercise(id: 'e2', name: 'Press de pecho con banda', group: 'Pecho', description: 'Pecho y tríceps'),
    Exercise(id: 'e3', name: 'Remo con banda', group: 'Espalda', description: 'Espalda y bíceps'),
    Exercise(id: 'e4', name: 'Burpees', group: 'Cardio', description: 'Resistencia y coordinación'),
    Exercise(id: 'e5', name: 'Plancha', group: 'Core', description: 'Fuerza del core'),
    Exercise(id: 'e6', name: 'Saltos laterales', group: 'Cardio', description: 'Agilidad y resistencia'),
    Exercise(id: 'e7', name: 'Zancadas', group: 'Pierna', description: 'Piernas y equilibrio'),
    Exercise(id: 'e8', name: 'Curl de bíceps con banda', group: 'Brazos', description: 'Bíceps y antebrazo'),
    Exercise(id: 'e9', name: 'Press militar con banda', group: 'Hombros', description: 'Hombros y trapecio'),
    Exercise(id: 'e10', name: 'Remo sentado con banda', group: 'Espalda', description: 'Espalda media y alta'),
  ];

  final Map<String, WorkoutEntry> _selectedEntries = <String, WorkoutEntry>{};
  final List<Workout> _history = <Workout>[];
  bool _isSaving = false;
  bool _isLoadingHistory = false;

  bool get isSaving => _isSaving;
  bool get isLoadingHistory => _isLoadingHistory;
  List<Workout> get history => List.unmodifiable(_history);
  List<WorkoutEntry> get selectedEntries => List.unmodifiable(_selectedEntries.values);

  bool isSelected(String exerciseId) => _selectedEntries.containsKey(exerciseId);

  WorkoutEntry? entryFor(String exerciseId) => _selectedEntries[exerciseId];

  void toggleExerciseSelection(Exercise exercise) {
    if (isSelected(exercise.id)) {
      _selectedEntries.remove(exercise.id);
    } else {
      _selectedEntries[exercise.id] = WorkoutEntry(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
      );
    }
    notifyListeners();
  }

  void updateEntry({
    required String exerciseId,
    int? sets,
    int? reps,
    double? weight,
  }) {
    final WorkoutEntry? entry = _selectedEntries[exerciseId];
    if (entry == null) return;
    if (sets != null) entry.sets = sets;
    if (reps != null) entry.reps = reps;
    if (weight != null) entry.weight = weight;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoadingHistory = true;
    notifyListeners();

    try {
      final FirestoreService firestoreService = FirestoreService();
      final List<Workout> loaded = await firestoreService.loadWorkouts(uid: user.uid);
      _history
        ..clear()
        ..addAll(loaded);
    } catch (_) {
      // ignore errors for now
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<bool> saveWorkout(String title) async {
    if (_selectedEntries.isEmpty) return false;
    _isSaving = true;
    notifyListeners();

    final Workout workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Rutina personalizada' : title,
      createdAt: DateTime.now(),
      entries: selectedEntries,
    );

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final FirestoreService firestoreService = FirestoreService();
        await firestoreService.saveWorkout(workout, uid: user.uid);
      }
      _history.insert(0, workout);
      clearSelection();
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedEntries.clear();
    notifyListeners();
  }

  List<Workout> get workoutsThisWeek {
    final DateTime now = DateTime.now();
    final DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _history.where((Workout workout) => !workout.createdAt.isBefore(weekStart)).toList();
  }

  List<Workout> workoutsForDate(DateTime date) {
    return _history.where((Workout workout) {
      final DateTime w = DateTime(workout.createdAt.year, workout.createdAt.month, workout.createdAt.day);
      final DateTime d = DateTime(date.year, date.month, date.day);
      return w == d;
    }).toList();
  }
}
