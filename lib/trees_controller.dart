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
    "Cycling": 100,
    "Public transport": 300,
    "Sutainable diet": 200,
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
  void initState() {
    super.initState();
    currentHabits = List.of([
      GrowingTree(2, "Cycling", 100, migrateTree, addSavedC02),
      GrowingTree(4, "Public transport", 300, migrateTree, addSavedC02),
      GrowingTree(6, "Sustainable diet", 200, migrateTree, addSavedC02),
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
          Text(
            'Forest of completed tasks',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          // Grown trees
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
            padding: EdgeInsets.only(top: 54),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Daily tasks',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
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
              title: Text('Summary'),
              content: Container(
                width: 300, // Set your desired width
                height: 100, // Set your desired height
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily reduction of CO\u2082: '),
                        Text('${dailyTotalCO2Saved}g'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Other Cracow citizens average: '),
                        Text('${150} g'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('Summary'),
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
              title: Text('Pick habit'),
              content: Container(
                width: 300, // Set your desired width
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.5, // Set max height dynamically
                ),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 1.0, // Adjust spacing between columns
                      columns: const [
                        DataColumn(label: Text('Habit')),
                        DataColumn(label: Text('CO\u2082')),
                        DataColumn(label: Text('Add')),
                      ],
                      rows: availableHabits.entries
                          .map(
                            (entry) => DataRow(
                              cells: [
                                DataCell(Container(
                                  width:
                                      100, // Set a specific width for the cell
                                  child: Text(entry.key),
                                )),
                                DataCell(Container(
                                  width:
                                      60, // Set a specific width for the cell
                                  child: Text(entry.value.toString()),
                                )),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 10.0,
                                    ),
                                    child: SizedBox(
                                      width: 50,
                                      height:
                                          30, // Set a specific width for the button
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            if (currentHabits.length < 3) {
                                              currentHabits.add(
                                                GrowingTree(
                                                  0,
                                                  entry.key,
                                                  entry.value,
                                                  migrateTree,
                                                  addSavedC02,
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                      'Cannot track more than 3 habits'),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Text('Add habit'),
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
