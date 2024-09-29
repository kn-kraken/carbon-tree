// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// TODO: unignore

import 'package:flutter/material.dart';
import 'package:carbon_tree/growing_tree.dart';
import 'package:carbon_tree/grown_tree.dart';

class TreesController extends StatefulWidget {
  const TreesController({super.key});

  @override
  State<TreesController> createState() => _TreesControllerState();
}

class _TreesControllerState extends State<TreesController> {
  final rows = 2;
  int dailyTotalCO2Saved = 0;

  Map<String, int> availableHabits = {
    "Jazda na rowerze": 100,
    "Transport publiczny": 300,
    "Zrównoważone jedzenie": 200,
  };

  List<Widget> completedTrees = List.of([
    GrownTree(55.0),
    emptyTree,
    GrownTree(52.0),
    GrownTree(63.0),
    GrownTree(59.0),
    GrownTree(56.0),
    GrownTree(59.0),
    emptyTree,
    //
    emptyTree,
    GrownTree(55.0),
    GrownTree(56.0),
    GrownTree(63.0),
    emptyTree,
    emptyTree,
    GrownTree(55.0),
    GrownTree(59.0),
  ]);

  List<GrowingTree> currentHabits = List.of([]);

  @override
  initState() {
    super.initState();
    currentHabits = List.of([
      GrowingTree(2, "Jazda na rowerze", 100, migrateTree, addSavedC02),
      GrowingTree(4, "Transport publiczny", 300, migrateTree, addSavedC02),
      GrowingTree(6, "Zrównoważone jedzenie", 200, migrateTree, addSavedC02),
    ]);
  }

  void addSavedC02(int amount) {
    setState(() {
      dailyTotalCO2Saved += amount;
    });
  }

  void migrateTree(String habitName) {
    setState(() {
      var firstEmptyIndex =
          completedTrees.lastIndexWhere((el) => el is! GrownTree);
      completedTrees[firstEmptyIndex] = GrownTree(59.0);
      currentHabits.removeWhere((habit) => habit.habitName == habitName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Las wykonanych zadań'),
          // grown trees
          Wrap(
            spacing: -60,
            direction: Axis.vertical,
            children: completedTrees
                .customSlices((completedTrees.length / rows).ceil())
                .map(
                  (gtSublist) => Wrap(
                    spacing: -40,
                    children: gtSublist,
                  ),
                )
                .toList(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dziesiejsze zadania'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentHabits,
                ),
              ],
            ),
          ),
          addHabitButton(),
          summaryButton(),
        ],
      ),
    );
  }

  Widget summaryButton() {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  scrollable: true,
                  title: Text('Podsumowanie'),
                  content: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dzienna oszczędność CO2: '),
                          Text(dailyTotalCO2Saved.toString()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Średnia innych użytkowników: '),
                          Text(150.toString()),
                        ],
                      ),
                    ],
                  ));
            });
      },
      child: Text('Podsumowanie'),
    );
  }

  Widget addHabitButton() {
    return TextButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Wybierz nawyk'),
                content: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nawyk')),
                    DataColumn(label: Text('CO2')),
                    DataColumn(label: Text('Dodaj')),
                  ],
                  rows: availableHabits.entries
                      .map(
                        (entry) => DataRow(
                          cells: [
                            DataCell(Text(entry.key)),
                            DataCell(Text(entry.value.toString())),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    currentHabits.add(
                                      GrowingTree(
                                        0,
                                        entry.key,
                                        entry.value,
                                        migrateTree,
                                        addSavedC02,
                                      ),
                                    );
                                  });
                                },
                                child: Text('+'),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              );
            });
      },
      child: Text('Dodaj nawyk'),
    );
  }
}

const emptyTree = SizedBox(
  height: 100,
  width: 80,
  child: Row(),
);

extension CustomIterableExtension<T> on Iterable<T> {
  Iterable<List<T>> customSlices(int length) sync* {
    if (length < 1) throw RangeError.range(length, 1, null, 'length');

    var iterator = this.iterator;
    while (iterator.moveNext()) {
      var slice = [iterator.current];
      for (var i = 1; i < length && iterator.moveNext(); i++) {
        slice.add(iterator.current);
      }
      yield slice;
    }
  }
}
