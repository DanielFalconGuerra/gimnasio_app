import 'package:flutter/material.dart';
import '../models/routine.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({super.key, required this.routine, this.onTap});

  final Routine routine;
  final VoidCallback? onTap;

  String _typeLabel(RoutineType t) {
    switch (t) {
      case RoutineType.fuerza:
        return 'Fuerza';
      case RoutineType.resistencia:
        return 'Resistencia';
      case RoutineType.acondicionamiento:
        return 'Acondicionamiento';
    }
  }

  // Helper para asignar un color representativo a cada tipo de rutina (Estilo Tailwind)
  Color _getTypeColor(RoutineType t) {
    switch (t) {
      case RoutineType.fuerza:
        return const Color(0xFFEF4444); // red-500
      case RoutineType.resistencia:
        return const Color(0xFF3B82F6); // blue-500
      case RoutineType.acondicionamiento:
        return const Color(0xFF10B981); // emerald-500
    }
  }

  // Helper para asignar un icono a cada tipo de rutina
  IconData _getTypeIcon(RoutineType t) {
    switch (t) {
      case RoutineType.fuerza:
        return Icons.fitness_center_rounded;
      case RoutineType.resistencia:
        return Icons.bolt_rounded;
      case RoutineType.acondicionamiento:
        return Icons.accessibility_new_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PALETA DE COLORES LOCAL ---
    final Color textColor       = const Color(0xFF1E293B); // slate-800
    final Color subtitleColor   = const Color(0xFF64748B); // slate-500
    final Color borderColor     = const Color(0xFFE2E8F0); // slate-200
    final Color typeColor       = _getTypeColor(routine.type);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0), // Margen externo sutil entre tarjetas
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14), // Bordes rounded-xl
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Espaciado interno generoso (padding-4)
            child: Row(
              children: [
                // --- ICONO DE CATEGORÍA CON FONDO SUTIL ---
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getTypeIcon(routine.type),
                    color: typeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // --- CONTENIDO TEXTUAL (Título y Detalles) ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Fila inferior con el Badge y la Duración
                      Row(
                        children: [
                          // Badge del Tipo de Rutina (Estilo Tailwind px-2 py-0.5 text-xs)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _typeLabel(routine.type),
                              style: TextStyle(
                                color: typeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Indicador de Duración con Icono
                          Row(
                            children: [
                              Icon(Icons.schedule_rounded, color: subtitleColor.withOpacity(0.6), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${routine.durationMinutes} min',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- INDICADOR ACCIÓN (Chevron derecho estilizado) ---
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: subtitleColor.withOpacity(0.4),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}