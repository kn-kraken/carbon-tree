import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class GrownTree extends StatefulWidget {
  final double finalProgress;

  const GrownTree(this.finalProgress, {super.key});

  @override
  State<GrownTree> createState() => _GrownTreeState(finalProgress);
}

class _GrownTreeState extends State<GrownTree> {
  StateMachineController? controller;
  SMIInput<double>? inputValue;
  final double grownTreeProgressPercent;

  _GrownTreeState(this.grownTreeProgressPercent);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 80,
      child: RiveAnimation.asset(
        "assets/tree_transparent.riv",
        fit: BoxFit.contain,
        onInit: (artboard) {
          controller = StateMachineController.fromArtboard(
            artboard,
            "State Machine 1",
          );

          if (controller != null) {
            artboard.addController(controller!);
            inputValue = controller?.findInput("input");
            inputValue?.change(grownTreeProgressPercent);
          }
        },
      ),
    );
  }
}
