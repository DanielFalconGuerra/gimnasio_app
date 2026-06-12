enum RoutineType { fuerza, resistencia, acondicionamiento }

class Routine {

  Routine({
    required this.id,
    required this.title,
    required this.type,
    required this.exercises,
    this.durationMinutes = 10,
  });
  final String id;
  final String title;
  final RoutineType type;
  final List<String> exercises; // simple list of exercise names for now
  final int durationMinutes;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'type': type.toString().split('.').last,
        'exercises': exercises,
        'durationMinutes': durationMinutes,
      };

  factory Routine.fromMap(Map<String, dynamic> map) {
    final String typeStr = map['type'] as String? ?? 'fuerza';
    final RoutineType routineType = RoutineType.values.byName(typeStr);
    
    return Routine(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      type: routineType,
      exercises: List<String>.from(map['exercises'] as List<dynamic>? ?? <String>[]),
      durationMinutes: map['durationMinutes'] as int? ?? 10,
    );
  }
}
