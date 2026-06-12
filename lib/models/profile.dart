class Profile {

  Profile({
    required this.email,
    this.age,
    this.weight,
    this.height,
    this.level = 'Principiante',
  });

  factory Profile.fromMap(Map<String, dynamic> m) => Profile(
        email: m['email'] ?? '',
        age: m['age'],
        weight: (m['weight'] is num) ? (m['weight'] as num).toDouble() : null,
        height: (m['height'] is num) ? (m['height'] as num).toDouble() : null,
        level: m['level'] ?? 'Principiante',
      );
  String email;
  int? age;
  double? weight;
  double? height;
  String level;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'email': email,
        'age': age,
        'weight': weight,
        'height': height,
        'level': level,
      };
}
