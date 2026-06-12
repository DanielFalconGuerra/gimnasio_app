import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/routine.dart';
import '../viewmodels/routines_viewmodel.dart';
import '../widgets/routine_card.dart';

class RoutinesListView extends StatefulWidget {
  const RoutinesListView({super.key});

  @override
  State<RoutinesListView> createState() => _RoutinesListViewState();
}

class _RoutinesListViewState extends State<RoutinesListView> {
  RoutineType _selected = RoutineType.fuerza;

  @override
  Widget build(BuildContext context) {
    // 🔑 ENVOLVEMOS EN UN CONSUMER:
    // Esto nos da un nuevo 'context' interno que está por debajo de MultiProvider en el árbol.
    return Consumer<RoutinesViewModel>(
      builder: (context, vm, child) {
        final List<Routine> list = vm.byType(_selected);

        return Scaffold(
          appBar: AppBar(title: const Text('Rutinarios Predefinidos')),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    isSelected: <bool>[
                      _selected == RoutineType.fuerza,
                      _selected == RoutineType.resistencia,
                      _selected == RoutineType.acondicionamiento,
                    ],
                    onPressed: (int i) => setState(() {
                      _selected = RoutineType.values[i];
                    }),
                    children: const <Widget>[
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Fuerza')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Resistencia')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Acondi.')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: list.isEmpty
                      ? const Center(
                    child: Text(
                      'No hay rutinarios predefinidos en esta categoría.',
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  )
                      : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, int i) => RoutineCard(
                      routine: list[i],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/routine_detail',
                          arguments: list[i],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}