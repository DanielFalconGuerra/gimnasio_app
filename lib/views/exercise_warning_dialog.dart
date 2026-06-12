import 'package:flutter/material.dart';
import '../models/exercise_warning.dart';
import '../widgets/video_player_widget.dart'; // Importación del nuevo widget de video

class ExerciseWarningDialog extends StatelessWidget {
  final ExerciseWarning warning;
  final VoidCallback? onAcknowledged;

  const ExerciseWarningDialog({
    super.key,
    required this.warning,
    this.onAcknowledged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Guía de Seguridad: ${warning.exerciseName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: ScaffoldWithFullScreenPlayer(warning: warning), // Contenedor optimizado
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onAcknowledged?.call();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Entendido'),
        ),
      ],
    );
  }
}

class ScaffoldWithFullScreenPlayer extends StatelessWidget {
  final ExerciseWarning warning;
  const ScaffoldWithFullScreenPlayer({super.key, required this.warning});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= SECCIÓN MULTIMEDIA OBLIGATORIA =================
          const Text(
            'DEMOSTRACIÓN EN VIDEO:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
          ),
          const SizedBox(height: 8),
          if (warning.videoUrl.isNotEmpty)
            VideoPlayerWidget(videoUrl: warning.videoUrl)
          else
            const Text('No se cargó video demostrativo.', style: TextStyle(fontStyle: FontStyle.italic)),

          const SizedBox(height: 16),
          // ==================================================================

          const Text(
            'TÉCNICA CORRECTA:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
          ),
          const SizedBox(height: 6),
          Text(warning.correctTechnique, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 12),

          const Text(
            'ERRORES COMUNES:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.redAccent),
          ),
          const SizedBox(height: 6),
          ...warning.commonMistakes.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                Expanded(child: Text(e, style: const TextStyle(fontSize: 12))),
              ],
            ),
          )),
          const SizedBox(height: 12),

          const Text(
            'CONSEJOS DE SEGURIDAD:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green),
          ),
          const SizedBox(height: 6),
          ...warning.safetyTips.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, size: 14, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(child: Text(e, style: const TextStyle(fontSize: 12))),
              ],
            ),
          )),
          const SizedBox(height: 12),

          const Text(
            'MÚSCULOS TRABAJADOS:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: -4,
            children: warning.musclesWorked
                .map((m) => Chip(
              label: Text(m, style: const TextStyle(fontSize: 11)),
              backgroundColor: Colors.blue.shade50,
              side: BorderSide.none,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}