import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importaciones de tus ViewModels
import 'models/routine.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/workouts_viewmodel.dart';
import 'viewmodels/routines_viewmodel.dart';
import 'viewmodels/safety_viewmodel.dart';

// Importaciones de tus Vistas
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/welcome_view.dart';
import 'views/workout_history_view.dart';
import 'firebase_options.dart';

import 'views/exercise_selection_view.dart';
import 'views/weekly_plan_view.dart';
import 'views/routines_list_view.dart';

import 'views/profile_view.dart';
import 'views/routine_detail_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // INYECTAMOS TODOS LOS VIEWMODELS EN EL TOPE DEL ÁRBOL
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => WorkoutsViewModel()),
        ChangeNotifierProvider(create: (_) => RoutinesViewModel()),
        ChangeNotifierProvider(create: (_) => SafetyViewModel()),
      ],
      child: MaterialApp(
        title: 'Gimnasio Universitario',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        // La app arranca siempre en el AuthGate para verificar sesión
        home: const AuthGate(),
        routes: {
          '/login': (_) => const LoginView(),
          '/register': (_) => const RegisterView(),
          '/home': (_) => const WelcomeView(),
          '/history': (_) => const WorkoutHistoryView(),
          // Agrega aquí tus otras rutas si las necesitas (e.g., /profile, /weekly_plan)
          '/select_exercises': (_) => const ExerciseSelectionView(),
          '/weekly_plan': (_) => const WeeklyPlanView(),
          '/routines': (_) => const RoutinesListView(),
          '/profile': (_) => const ProfileView(),
          '/routine_detail': (context) {
            final routine = ModalRoute.of(context)!.settings.arguments as Routine;
            return RoutineDetailView(routine: routine);
          },
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras Firebase responde, mostramos una pantalla de carga limpia
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si hay un usuario con sesión activa, lo mandamos al Home de forma segura
        if (snapshot.hasData) {
          return const WelcomeView();
        }

        // Si no está logueado, lo mandamos directo a iniciar sesión
        return const LoginView();
      },
    );
  }
}