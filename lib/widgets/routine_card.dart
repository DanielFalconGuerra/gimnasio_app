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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(routine.title),
        subtitle: Text('${_typeLabel(routine.type)} • ${routine.durationMinutes} min'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
