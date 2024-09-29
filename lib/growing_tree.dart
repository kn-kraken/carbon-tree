import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class GrowingTree extends StatefulWidget {
  final int initialProgress;
  final String habitName;
  final int co2;
  final Function(String) migrateTree;
  final Function(int) addSavedC02;

  const GrowingTree(
    this.initialProgress,
    this.habitName,
    this.co2,
    this.migrateTree,
    this.addSavedC02, {
    super.key,
  });

  @override
  State<GrowingTree> createState() => _GrowingTreeState();
}

class _GrowingTreeState extends State<GrowingTree> {
  StateMachineController? controller;
  SMIInput<double>? inputValue;
  int currentProgress = 0; // days, initialized in `onInit`
  bool isCheckedToday = false;
  final int maxProgress = 7; // days

  // the used animation has unevenly distributed animation points
  // because of that below is a manually set progress point map
  final Map<int, double> progressPoints = {
    0: 0.0,
    1: 10.0,
    2: 20.0,
    3: 25.0,
    4: 30.0,
    5: 45.0,
    6: 49.0,
    7: 55.0,
  };

  void increaseProgress(_) {
    widget.addSavedC02(widget.co2);
    setState(() {
      isCheckedToday = true;
      ++currentProgress;
      Future.delayed(const Duration(milliseconds: 600), () {
        if (currentProgress >= maxProgress) {
          widget.migrateTree(widget.habitName);
        }
      });
    });

    var progressPercent = getProgressPercent();
    inputValue?.change(progressPercent);
  }

  double getProgressPercent() => progressPoints[currentProgress] ?? 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        treeWidget(),
        textWidget(),
        countWidget(),
        markCompleteWidget(),
      ],
    );
  }

  Widget treeWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / 3,
      child: RiveAnimation.asset(
        "assets/tree_transparent.riv",
        fit: BoxFit.fitWidth,
        onInit: (artboard) {
          controller = StateMachineController.fromArtboard(
            artboard,
            "State Machine 1",
          );

          if (controller != null) {
            artboard.addController(controller!);
            inputValue = controller?.findInput("input");
            setState(() {
              currentProgress = widget.initialProgress;
            });
            inputValue?.change(getProgressPercent());
          }
        },
      ),
    );
  }

  Widget textWidget() {
    return SizedBox(
      width: 110,
      child: Text(
        widget.habitName,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget countWidget() {
    return Text(
      '$currentProgress/$maxProgress',
    );
  }

  Widget markCompleteWidget() {
    return Checkbox(
      value: isCheckedToday,
      onChanged: isCheckedToday ? null : increaseProgress,
    );
  }
}
