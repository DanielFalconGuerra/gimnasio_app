import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutEntry {
  WorkoutEntry({
    required this.exerciseId,
    required this.exerciseName,
    this.sets = 3,
    this.reps = 10,
    this.weight = 0.0,
  });

  final String exerciseId;
  final String exerciseName;
  int sets;
  int reps;
  double weight;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'sets': sets,
        'reps': reps,
        'weight': weight,
      };

  factory WorkoutEntry.fromMap(Map<String, dynamic> map) => WorkoutEntry(
        exerciseId: map['exerciseId'] as String? ?? '',
        exerciseName: map['exerciseName'] as String? ?? '',
        sets: map['sets'] as int? ?? 3,
        reps: map['reps'] as int? ?? 10,
        weight: (map['weight'] is num) ? (map['weight'] as num).toDouble() : 0.0,
      );
}

class Workout {
  Workout({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.entries,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final List<WorkoutEntry> entries;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'createdAt': Timestamp.fromDate(createdAt),
        'entries': entries.map((WorkoutEntry e) => e.toMap()).toList(),
      };

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
        id: map['id'] as String? ?? '',
        title: map['title'] as String? ?? '',
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        entries: (map['entries'] as List<dynamic>?)
                ?.map((dynamic item) => WorkoutEntry.fromMap(item as Map<String, dynamic>))
                .toList() ??
            <WorkoutEntry>[],
      );
}
