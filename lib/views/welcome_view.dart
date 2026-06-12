import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      await Provider.of<ProfileViewModel>(context, listen: false).loadProfile(uid: user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // --- PALETA TAILWIND CONSISTENTE ---
    final Color primaryColor    = const Color(0xFF4F46E5); // indigo-600
    final Color backgroundColor = const Color(0xFFF8FAFC); // slate-50
    final Color textColor       = const Color(0xFF1E293B); // slate-800
    final Color subtitleColor   = const Color(0xFF64748B); // slate-500
    final Color borderColor     = const Color(0xFFE2E8F0); // slate-200

    return Consumer2<AuthViewModel, ProfileViewModel>(
      builder: (context, authVM, profileVM, child) {
        // Limpiamos el display quitando el dominio institucional para que se vea más estético el nombre
        final String rawEmail = profileVM.profile.email.isNotEmpty
            ? profileVM.profile.email
            : (user?.email ?? 'Usuario');
        final String displayName = rawEmail.split('@')[0];

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'Gimnasio Universitario',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: <Widget>[
              // Botón de logout sutil en la esquina superior
              IconButton(
                icon: Icon(Icons.logout_rounded, color: subtitleColor, size: 22),
                tooltip: 'Cerrar sesión',
                onPressed: () async {
                  await authVM.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
            // Línea divisoria muy fina, común en interfaces web minimalistas
            shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // --- SECCIÓN: BIENVENIDA AL USUARIO ---
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: Icon(Icons.person_outline_rounded, color: primaryColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Hola, $displayName! 👋',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '¿Qué vamos a entrenar hoy?',
                              style: TextStyle(fontSize: 14, color: subtitleColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- ENLACE DESTACADO PRINCIPAL ---
                  _buildMainBanner(
                    context: context,
                    primaryColor: primaryColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 24),

                  // --- SECCIÓN: ACCIONES / ACCESOS DIRECTOS ---
                  Text(
                    'Accesos Rápidos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 12),

                  // Implementación de Grid estilo Tailwind para las opciones secundarias
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      _buildGridCard(
                        context: context,
                        route: '/history',
                        icon: Icons.history_rounded,
                        title: 'Historial',
                        subtitle: 'Tus registros',
                        iconColor: Colors.amber.shade600,
                      ),
                      _buildGridCard(
                        context: context,
                        route: '/weekly_plan',
                        icon: Icons.calendar_view_week_rounded,
                        title: 'Plan Semanal',
                        subtitle: 'Organiza tus días',
                        iconColor: Colors.teal.shade600,
                      ),
                      _buildGridCard(
                        context: context,
                        route: '/profile',
                        icon: Icons.manage_accounts_rounded,
                        title: 'Mi Perfil',
                        subtitle: 'Ajustes de cuenta',
                        iconColor: Colors.blue.shade600,
                      ),
                      _buildGridCard(
                        context: context,
                        route: '/routines',
                        icon: Icons.format_list_bulleted_rounded,
                        title: 'Predefinidos',
                        subtitle: 'Rutinas base',
                        iconColor: Colors.purple.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget para la tarjeta principal destacada (Call To Action principal)
  Widget _buildMainBanner({
    required BuildContext context,
    required Color primaryColor,
    required Color textColor,
    required Color subtitleColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // CORREGIDO: Usamos Border.all para definir el color y grosor de forma limpia
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, '/select_exercises'),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.fitness_center_rounded, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleccionar Ejercicios',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Arma tu rutina diaria con series, repeticiones y peso.',
                        style: TextStyle(fontSize: 13, color: subtitleColor, height: 1.3),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: subtitleColor.withOpacity(0.5), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para las tarjetas secundarias del Grid
  Widget _buildGridCard({
    required BuildContext context,
    required String route,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: const Color(0xFF64748B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}