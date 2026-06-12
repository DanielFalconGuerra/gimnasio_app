import 'package:flutter/material.dart';

class WarmupReminderDialog extends StatelessWidget {
  final String routineName;
  final VoidCallback? onStarted;

  const WarmupReminderDialog({
    super.key,
    required this.routineName,
    this.onStarted,
  });

  @override
  Widget build(BuildContext context) {
    // --- PALETA TAILWIND CONSISTENTE ---
    final Color primaryColor    = const Color(0xFF4F46E5); // indigo-600
    final Color textColor       = const Color(0xFF1E293B); // slate-800
    final Color subtitleColor   = const Color(0xFF64748B); // slate-500
    final Color warningColor    = const Color(0xFFD97706); // amber-600 (Más legible que el amarillo puro)
    final Color warningBg       = const Color(0xFFFEF3C7); // amber-100

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 0, // Evita las sombras duras de Material 2
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // rounded-2xl de Tailwind
      ),
      titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      actionsPadding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),

      // --- HEADER DEL MODAL ---
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2), // red-100 sutil
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEF4444), size: 24), // red-500
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Calentamiento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),

      // --- CUERPO DEL MODAL ---
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge sutil para el nombre de la rutina (Estilo Tailwind tag)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Rutina: $routineName',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Antes de comenzar, realiza una activación de 5 a 10 minutos para preparar tu cuerpo:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor, height: 1.4),
          ),
          const SizedBox(height: 14),

          // Contenedor de Advertencia / Tips (Simula un alert-warning de Bootstrap)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: warningBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: warningColor.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildListStep(icon: Icons.directions_walk_rounded, text: '2-3 min de caminata ligera o trote suave', color: warningColor),
                _buildListStep(icon: Icons.sync_rounded, text: 'Rotaciones articulares (cuello, hombros, cadera)', color: warningColor),
                _buildListStep(icon: Icons.accessibility_new_rounded, text: 'Estiramientos dinámicos suaves', color: warningColor),
                _buildListStep(icon: Icons.fitness_center_rounded, text: '2-3 series de aproximación sin peso', color: warningColor, isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.shield_outlined, color: subtitleColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Un buen calentamiento previene lesiones eficazmente.',
                  style: TextStyle(fontSize: 12, color: subtitleColor, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ],
      ),

      // --- ACCIONES DEL MODAL (Estilo botones de formulario web) ---
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFE2E8F0)), // border-slate-200
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: subtitleColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onStarted?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444), // Rojo fuego / motivación para arrancar
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  '¡Listo, empezar!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper para construir las viñetas del listado con iconos en lugar de caracteres planos
  Widget _buildListStep({
    required IconData icon,
    required String text,
    required Color color,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      // Nota: Para evitar errores de casteo en paddings usaremos la forma limpia estándar:
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF78350F), height: 1.3), // amber-900 para el texto interno
              ),
            ),
          ],
        ),
      ),
    );
  }
}