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
    return AlertDialog(
      // 🔑 SOLUCIÓN AQUÍ: Envolvemos el título en un Row controlado con Expanded
      title: Row(
        children: const [
          Icon(Icons.local_fire_department, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Recordatorio de Calentamiento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rutina: $routineName',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const Text(
            'ANTES DE COMENZAR, REALIZA UN CALENTAMIENTO DE 5-10 MINUTOS:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✓ 2-3 min caminata ligera o trote suave', style: TextStyle(fontSize: 12)),
                SizedBox(height: 6),
                Text('✓ Rotaciones articulares (cuello, hombros, cadera)', style: TextStyle(fontSize: 12)),
                SizedBox(height: 6),
                Text('✓ Estiramientos dinámicos suave', style: TextStyle(fontSize: 12)),
                SizedBox(height: 6),
                Text('✓ 2-3 series de las activaciones del ejercicio sin peso', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'El calentamiento prepara tu cuerpo y REDUCE LESIONES.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onStarted?.call();
          },
          child: const Text('Ya me calenté, comenzar'),
        ),
      ],
    );
  }
}