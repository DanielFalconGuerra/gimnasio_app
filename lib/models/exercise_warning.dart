class ExerciseWarning {
  final String exerciseName;
  final List<String> commonMistakes;
  final List<String> safetyTips;
  final List<String> musclesWorked;
  final String correctTechnique;
  final String videoUrl; // Placeholder para YouTube o asset

  ExerciseWarning({
    required this.exerciseName,
    required this.commonMistakes,
    required this.safetyTips,
    required this.musclesWorked,
    required this.correctTechnique,
    this.videoUrl = '',
  });
}

// Base de datos de advertencias para ejercicios comunes
final List<ExerciseWarning> commonExerciseWarnings = [
  ExerciseWarning(
    exerciseName: 'Sentadillas',
    commonMistakes: [
      'No bajar lo suficiente (ROM limitado)',
      'Rodillas por encima de los dedos del pie',
      'Espalda redondeada',
      'Peso hacia adelante',
    ],
    safetyTips: [
      'Mantén el pecho erguido',
      'Rodillas alineadas con los dedos del pie',
      'Baja lentamente controlando el movimiento',
      'Descansa 60-90 segundos entre series',
    ],
    musclesWorked: ['Cuádriceps', 'Glúteos', 'Espalda baja', 'Abdominales'],
    correctTechnique: 'Pies a ancho de hombros, baja controlado, rodillas a 90°, sin arquear la espalda',
    videoUrl: 'https://www.youtube.com/watch?v=sqWNqZI6Zus',
  ),
  ExerciseWarning(
    exerciseName: 'Press de pecho con banda',
    commonMistakes: [
      'Codos demasiado abiertos (> 90°)',
      'Banda sin tensión inicial',
      'Sin control en la fase excéntrica',
    ],
    safetyTips: [
      'Coloca la banda a la altura del pecho',
      'Mantén codos a 45°-60° de los costados',
      'Controla la vuelta en 3 segundos',
      'Posición sentado o de pie estable',
    ],
    musclesWorked: ['Pecho', 'Deltoides anterior', 'Tríceps'],
    correctTechnique: 'Banda tensa, codos semi-flexionados, empuje controlado',
    videoUrl: 'https://www.youtube.com/watch?v=E8_Ej4yFZro',
  ),
  ExerciseWarning(
    exerciseName: 'Remo con banda',
    commonMistakes: [
      'Hombros encorvados',
      'Falta de contracción en la espalda',
      'Movimiento de brazos en lugar de espalda',
    ],
    safetyTips: [
      'Mantén los hombros relajados',
      'Contrae escápulas al tirar',
      'Codos pegados al cuerpo',
      'Pausa 1-2 segundos al final',
    ],
    musclesWorked: ['Dorsal ancho', 'Bíceps', 'Espalda media'],
    correctTechnique: 'Posición derecha, tirar hacia el abdomen, escápulas retraídas',
    videoUrl: 'https://www.youtube.com/watch?v=Yl6-IU70f-Y',
  ),
];
