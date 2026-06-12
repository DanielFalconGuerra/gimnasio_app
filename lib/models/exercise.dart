class Exercise {
  final String id;
  final String name;
  final String group;
  final String description;

  const Exercise({
    required this.id,
    required this.name,
    this.group = '',
    this.description = '',
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'group': group,
        'description': description,
      };

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        group: map['group'] as String? ?? '',
        description: map['description'] as String? ?? '',
      );
}
