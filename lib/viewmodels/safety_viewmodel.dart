import 'package:flutter/foundation.dart';
import '../models/safety.dart';
import '../models/exercise_warning.dart';

class SafetyViewModel extends ChangeNotifier {
  late SafetyProfile _safetyProfile;
  final List<LegalAgreement> _legalAgreements = [];
  bool _legalAgreedOnce = false;

  SafetyViewModel() {
    _initializeLegalAgreements();
    _safetyProfile = SafetyProfile(userId: 'demo_user');
  }

  SafetyProfile get safetyProfile => _safetyProfile;
  List<LegalAgreement> get legalAgreements => _legalAgreements;
  bool get legalAgreedOnce => _legalAgreedOnce;

  void _initializeLegalAgreements() {
    _legalAgreements.add(
      LegalAgreement(
        id: 'legal_001',
        title: 'Aviso Legal y Renuncia de Responsabilidad',
        content: '''
AVISO LEGAL IMPORTANTE

Esta aplicación es una guía de rutinas de ejercicio. NO reemplaza la supervisión de un entrenador calificado.

RIESGOS:
- Los ejercicios pueden causar lesiones si se realizan incorrectamente
- Consulta con un médico antes de iniciar cualquier programa de ejercicio
- Si experimentas dolor, detente inmediatamente

LIMITACIONES DE RESPONSABILIDAD:
La Universidad y sus desarrolladores no son responsables de:
- Lesiones durante o después del uso de la app
- Daños causados por ejercicio sin supervisión
- Consejos médicos no solicitados a través de la aplicación

ACEPTAS usar la app bajo TU PROPIO RIESGO.
        ''',
        version: 1,
      ),
    );
  }

  Future<bool> acceptLegalAgreement(String agreementId) async {
    try {
      final idx = _legalAgreements.indexWhere((a) => a.id == agreementId);
      if (idx >= 0) {
        _legalAgreements[idx].accepted = true;
        _legalAgreements[idx].acceptedAt = DateTime.now();
        _legalAgreedOnce = true;
        _safetyProfile.legalAgreed = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  ExerciseWarning? getWarningForExercise(String exerciseName) {
    try {
      return commonExerciseWarnings.firstWhere(
        (w) => w.exerciseName.toLowerCase() == exerciseName.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  void recordWorkout() {
    _safetyProfile.totalWorkouts++;
    notifyListeners();
  }

  void recordInjury() {
    _safetyProfile.injuryIncidents++;
    notifyListeners();
  }
}
