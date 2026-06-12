import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart'; // Añadimos el AuthViewModel para manejar el logout limpio

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    // Ejecutamos de manera segura post-renderizado para evitar crasheos de Scope y Contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      // Cargamos el perfil de Firestore de forma asíncrona y segura
      await Provider.of<ProfileViewModel>(context, listen: false).loadProfile(uid: user.uid); //
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Si el perfil ya cargó su información en Firestore, usamos sus datos, si no, el correo de la cuenta
    return Consumer2<AuthViewModel, ProfileViewModel>( //
      builder: (context, authVM, profileVM, child) { //

        final String displayEmail = profileVM.profile.email.isNotEmpty //
            ? profileVM.profile.email //
            : (user?.email ?? 'usuario');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gimnasio Universitario'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
                onPressed: () async {
                  // Consumimos el deslogueo centralizado del ViewModel
                  await authVM.logout();
                  if (context.mounted) {
                    // El AuthGate interceptará la salida y destruirá las pantallas de forma segura
                    Navigator.pushReplacementNamed(context, '/login'); //
                  }
                },
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Hola, $displayEmail',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecciona ejercicios, crea rutinas con series, repeticiones y peso, y guarda tu plan semanal.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fitness_center),
                    label: const Text('Seleccionar ejercicios'),
                    onPressed: () => Navigator.pushNamed(context, '/select_exercises'), //
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.history),
                    label: const Text('Historial de rutinas'),
                    onPressed: () => Navigator.pushNamed(context, '/history'), //
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_view_week),
                    label: const Text('Plan semanal'),
                    onPressed: () => Navigator.pushNamed(context, '/weekly_plan'), //
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('Perfil'),
                    onPressed: () => Navigator.pushNamed(context, '/profile'), //
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('Ver rutinarios predefinidos'),
                    onPressed: () => Navigator.pushNamed(context, '/routines'), //
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}