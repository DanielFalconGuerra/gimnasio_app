import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/exercise.dart';
import '../models/profile.dart';
import '../models/routine.dart';
import '../models/safety.dart';
import '../models/workout.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =============== USERS ===============

  /// Inicializa la estructura del usuario en Firestore
  /// Se llama cuando el usuario se registra
  Future<void> initializeUser({required String uid, required String email}) async {
    final DocumentReference<Map<String, dynamic>> userDocRef = _db.collection('users').doc(uid);

    // Verifica si el usuario ya existe
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await userDocRef.get();

    if (!snapshot.exists) {
      // Crea el documento de usuario con los datos iniciales de forma segura
      await userDocRef.set(<String, dynamic>{
        'email': email,
        'age': null,
        'weight': null,
        'height': null,
        'level': 'Principiante',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    }
  }

  /// Guarda o actualiza el perfil del usuario en users/{uid}
  Future<void> saveProfile(Profile p, {required String uid}) async {
    final DocumentReference<Map<String, dynamic>> userDocRef = _db.collection('users').doc(uid);

    // 🔑 Fusión segura: crea el documento si está vacío o actualiza campos si ya existe
    await userDocRef.set(<String, dynamic>{
      'email': p.email,
      'age': p.age,
      'weight': p.weight,
      'height': p.height,
      'level': p.level,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  /// Carga el perfil del usuario desde users/{uid}
  Future<Profile?> loadProfile({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('users').doc(uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        return Profile.fromMap(snapshot.data()!);
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
    return null;
  }

  // =============== WORKOUTS ===============

  /// Guarda un entrenamiento en users/{uid}/workouts/{workoutId}
  Future<void> saveWorkout(Workout workout, {required String uid}) async {
    final DocumentReference<Map<String, dynamic>> docRef = _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(workout.id);

    // 🔑 Modificado a .set con merge para evitar errores de documento inexistente
    await docRef.set(workout.toMap(), SetOptions(merge: true));
  }

  /// Carga todos los entrenamientos del usuario ordenados por fecha descendente
  Future<List<Workout>> loadWorkouts({required String uid}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Workout.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading workouts: $e');
      return <Workout>[];
    }
  }

  /// Obtiene un entrenamiento específico por su ID
  Future<Workout?> getWorkout({required String uid, required String workoutId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return Workout.fromMap(snapshot.data()!);
      }
    } catch (e) {
      debugPrint('Error getting workout: $e');
    }
    return null;
  }

  /// Elimina un entrenamiento por su ID
  Future<void> deleteWorkout({required String uid, required String workoutId}) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting workout: $e');
    }
  }

  // =============== EXERCISES ===============

  /// Guarda un ejercicio global en la colección exercises
  Future<void> saveExercise(Exercise exercise) async {
    try {
      await _db.collection('exercises').doc(exercise.id).set(<String, dynamic>{
        'id': exercise.id,
        'name': exercise.name,
        'group': exercise.group,
        'description': exercise.description,
        'createdAt': Timestamp.now(),
      }, SetOptions(merge: true)); // 🔑 Agregado merge para robustecer el sembrado global
    } catch (e) {
      debugPrint('Error saving exercise: $e');
    }
  }

  /// Carga todos los ejercicios disponibles
  Future<List<Exercise>> loadAllExercises() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('exercises').get();

      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Exercise.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading exercises: $e');
      return <Exercise>[];
    }
  }

  /// Carga ejercicios filtrados por grupo muscular
  Future<List<Exercise>> getExercisesByGroup(String group) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('exercises')
          .where('group', isEqualTo: group)
          .get();

      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Exercise.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading exercises by group: $e');
      return <Exercise>[];
    }
  }

  // =============== ROUTINES ===============

  /// Guarda una rutina predefinida en la colección routines
  Future<void> saveRoutine(Routine routine) async {
    try {
      await _db.collection('routines').doc(routine.id).set(<String, dynamic>{
        'id': routine.id,
        'title': routine.title,
        'type': routine.type.toString().split('.').last,
        'exercises': routine.exercises,
        'durationMinutes': routine.durationMinutes,
        'createdAt': Timestamp.now(),
      }, SetOptions(merge: true)); // 🔑 Agregado merge para robustecer el sembrado global
    } catch (e) {
      debugPrint('Error saving routine: $e');
    }
  }

  /// Carga todas las rutinas predefinidas
  Future<List<Routine>> loadAllRoutines() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('routines').get();

      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Routine.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading routines: $e');
      return <Routine>[];
    }
  }

  /// Carga rutinas filtradas por tipo
  Future<List<Routine>> getRoutinesByType(RoutineType type) async {
    try {
      final String typeStr = type.toString().split('.').last;
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('routines')
          .where('type', isEqualTo: typeStr)
          .get();

      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => Routine.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading routines by type: $e');
      return <Routine>[];
    }
  }

  // =============== SAFETY ===============

  /// Guarda el perfil de seguridad del usuario en users/{uid}/safety
  Future<void> saveSafetyProfile(SafetyProfile safety, {required String uid}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef = _db
          .collection('users')
          .doc(uid)
          .collection('safety')
          .doc('profile');

      // 🔑 Modificado a .set con merge para evitar excepciones nativas
      await docRef.set(safety.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving safety profile: $e');
    }
  }

  /// Carga el perfil de seguridad del usuario
  Future<SafetyProfile?> loadSafetyProfile({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('safety')
          .doc('profile')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic> data = snapshot.data()!;
        return SafetyProfile(
          userId: data['userId'] as String? ?? '',
          legalAgreed: data['legalAgreed'] as bool? ?? false,
          totalWorkouts: data['totalWorkouts'] as int? ?? 0,
          injuryIncidents: data['injuryIncidents'] as int? ?? 0,
        );
      }
    } catch (e) {
      debugPrint('Error loading safety profile: $e');
    }
    return null;
  }

  /// Guarda un acuerdo legal aceptado en users/{uid}/legalAgreements
  Future<void> saveLegalAgreement(LegalAgreement agreement, {required String uid}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef = _db
          .collection('users')
          .doc(uid)
          .collection('legalAgreements')
          .doc(agreement.id);

      // 🔑 Modificado a .set con merge
      await docRef.set(<String, dynamic>{
        'id': agreement.id,
        'title': agreement.title,
        'accepted': agreement.accepted,
        'acceptedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving legal agreement: $e');
    }
  }

  /// Carga los acuerdos legales aceptados por el usuario
  Future<List<LegalAgreement>> loadLegalAgreements({required String uid}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('legalAgreements')
          .where('accepted', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => LegalAgreement.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading legal agreements: $e');
      return <LegalAgreement>[];
    }
  }

  // =============== WEEKLY PLAN ===============

  /// Guarda el plan semanal del usuario en users/{uid}/weeklyPlan
  Future<void> saveWeeklyPlan(Map<String, dynamic> weeklyPlan, {required String uid}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef = _db
          .collection('users')
          .doc(uid)
          .collection('plans')
          .doc('weekly');

      // 🔑 Modificado a .set con merge
      await docRef.set(<String, dynamic>{
        ...weeklyPlan,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving weekly plan: $e');
    }
  }

  /// Carga el plan semanal del usuario
  Future<Map<String, dynamic>?> loadWeeklyPlan({required String uid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('plans')
          .doc('weekly')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data();
      }
    } catch (e) {
      debugPrint('Error loading weekly plan: $e');
    }
    return null;
  }

  // =============== GLOBAL SEED DATA ===============

  /// Inicializa la base de datos con ejercicios y rutinas predefinidas
  /// Se llama una sola vez al iniciar la app (si no existen)
  Future<void> initializeSeedData() async {
    try {
      // Verifica si la colección exercises ya existe
      final QuerySnapshot<Map<String, dynamic>> exercisesSnap =
      await _db.collection('exercises').limit(1).get();

      if (exercisesSnap.docs.isEmpty) {
        // Crea ejercicios predefinidos
        final List<Exercise> defaultExercises = <Exercise>[
          const Exercise(
            id: 'ex_1',
            name: 'Sentadillas',
            group: 'Piernas',
            description: 'Ejercicio fundamental para piernas',
          ),
          const Exercise(
            id: 'ex_2',
            name: 'Press de pecho con banda',
            group: 'Pecho',
            description: 'Presión de pecho con banda elástica',
          ),
          const Exercise(
            id: 'ex_3',
            name: 'Remo con banda',
            group: 'Espalda',
            description: 'Remada con banda para espalda',
          ),
          const Exercise(
            id: 'ex_4',
            name: 'Burpees',
            group: 'Cardio',
            description: 'Ejercicio de cardio completo',
          ),
          const Exercise(
            id: 'ex_5',
            name: 'Plancha',
            group: 'Core',
            description: 'Ejercicio de estabilidad core',
          ),
          const Exercise(
            id: 'ex_6',
            name: 'Saltos laterales',
            group: 'Agilidad',
            description: 'Ejercicio de agilidad y explosividad',
          ),
        ];

        for (final Exercise ex in defaultExercises) {
          await saveExercise(ex);
        }
        debugPrint('Ejercicios predefinidos creados');
      }

      // Verifica si la colección routines ya existe
      final QuerySnapshot<Map<String, dynamic>> routinesSnap =
      await _db.collection('routines').limit(1).get();

      if (routinesSnap.docs.isEmpty) {
        // Crea rutinas predefinidas
        final List<Routine> defaultRoutines = <Routine>[
          Routine(
            id: 'r_1',
            title: 'Circuito de Fuerza - Principiantes',
            type: RoutineType.fuerza,
            exercises: <String>['Sentadillas', 'Press de pecho con banda', 'Remo con banda'],
            durationMinutes: 20,
          ),
          Routine(
            id: 'r_2',
            title: 'Cardio Resistencia - Corto',
            type: RoutineType.resistencia,
            exercises: <String>['Calentamiento 5 min', 'Intervalos 10x (30s/30s)'],
            durationMinutes: 15,
          ),
          Routine(
            id: 'r_3',
            title: 'Acondicionamiento General',
            type: RoutineType.acondicionamiento,
            exercises: <String>['Burpees', 'Plancha', 'Saltos laterales'],
            durationMinutes: 12,
          ),
        ];

        for (final Routine routine in defaultRoutines) {
          await saveRoutine(routine);
        }
        debugPrint('Rutinas predefinidas creadas');
      }
    } catch (e) {
      debugPrint('Error initializing seed data: $e');
    }
  }
}