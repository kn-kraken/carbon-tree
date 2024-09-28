import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class AnimatedTreeIndicator extends StatefulWidget {
  const AnimatedTreeIndicator({super.key});

  @override
  State<AnimatedTreeIndicator> createState() => _AnimatedTreeIndicatorState();
}

class StumpClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return parseSvgPath(
        "M 36.717 90 h 17.786 c -3.688 -3.683 -3.603 -9.403 -3.627 -15.108 l 0 0 c 0.223 -6.449 2.375 -13.838 3.337 -21.428 l -2.278 -0.206 c -0.421 3.709 -1.478 7.201 -2.758 10.155 c -1.933 -4.69 -3.368 -7.247 -3.516 -12.666 h -1.608 c -0.749 4.365 -0.278 8.941 1.608 13.76 c -2.931 -4.097 -6.019 -7.1 -9.292 -8.813 l -1.659 1.674 c 4.013 2.908 7.848 8.641 7.499 15.218 C 42.208 80.466 41.172 85.438 36.717 90 z");
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class LeavesClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return parseSvgPath(
        "M 83.376 27.144 c 0 -3.078 -2.095 -5.66 -4.936 -6.415 c 0.003 -0.077 0.012 -0.153 0.012 -0.23 c 0 -3.67 -2.975 -6.646 -6.646 -6.646 c -0.605 0 -1.189 0.088 -1.746 0.24 c -0.25 -3.442 -3.115 -6.16 -6.621 -6.16 c -0.939 0 -1.831 0.197 -2.641 0.548 c -0.419 -3.267 -3.204 -5.795 -6.585 -5.795 c -1.575 0 -3.02 0.551 -4.159 1.466 C 48.972 1.712 46.546 0 43.704 0 c -2.863 0 -5.322 1.729 -6.392 4.199 c -0.189 -0.015 -0.379 -0.025 -0.571 -0.025 c -2.287 0 -4.316 1.102 -5.585 2.804 c -1.173 -0.9 -2.64 -1.436 -4.233 -1.436 c -3.846 0 -6.963 3.118 -6.963 6.963 c -3.846 0 -6.963 3.118 -6.963 6.963 c 0 0.849 0.152 1.662 0.431 2.414 c -3.718 0.476 -6.592 3.65 -6.592 7.497 c 0 2.284 1.014 4.33 2.615 5.716 c -0.843 1.219 -1.337 2.698 -1.337 4.292 c 0 0.86 0.146 1.686 0.411 2.457 c -1.18 1.334 -1.898 3.086 -1.898 5.007 c 0 4.176 3.385 7.561 7.561 7.561 c 1.692 0 3.254 -0.556 4.514 -1.495 c 0.826 3.28 3.795 5.708 7.331 5.708 c 1.967 0 3.758 -0.752 5.103 -1.983 c 1.231 1.966 3.415 3.274 5.905 3.274 c 3.846 0 6.963 -3.118 6.963 -6.963 c 0 -0.061 -0.003 -0.121 -0.005 -0.182 c 0.978 0.506 2.087 0.793 3.264 0.793 c 1.579 0 3.038 -0.515 4.219 -1.385 c 0.995 3.382 4.121 5.851 7.825 5.851 c 2.239 0 4.266 -0.902 5.741 -2.363 c 1.015 0.453 2.138 0.707 3.321 0.707 c 4.506 0 8.158 -3.652 8.158 -8.158 c 0 -1.258 -0.285 -2.449 -0.793 -3.512 c 3.278 -1.058 5.649 -4.133 5.649 -7.763 c 0 -1.52 -0.423 -2.938 -1.148 -4.157 C 82.117 31.611 83.376 29.527 83.376 27.144 z");
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TreeClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path.combine(
        PathOperation.union,
        parseSvgPath(
            "M 83.376 27.144 c 0 -3.078 -2.095 -5.66 -4.936 -6.415 c 0.003 -0.077 0.012 -0.153 0.012 -0.23 c 0 -3.67 -2.975 -6.646 -6.646 -6.646 c -0.605 0 -1.189 0.088 -1.746 0.24 c -0.25 -3.442 -3.115 -6.16 -6.621 -6.16 c -0.939 0 -1.831 0.197 -2.641 0.548 c -0.419 -3.267 -3.204 -5.795 -6.585 -5.795 c -1.575 0 -3.02 0.551 -4.159 1.466 C 48.972 1.712 46.546 0 43.704 0 c -2.863 0 -5.322 1.729 -6.392 4.199 c -0.189 -0.015 -0.379 -0.025 -0.571 -0.025 c -2.287 0 -4.316 1.102 -5.585 2.804 c -1.173 -0.9 -2.64 -1.436 -4.233 -1.436 c -3.846 0 -6.963 3.118 -6.963 6.963 c -3.846 0 -6.963 3.118 -6.963 6.963 c 0 0.849 0.152 1.662 0.431 2.414 c -3.718 0.476 -6.592 3.65 -6.592 7.497 c 0 2.284 1.014 4.33 2.615 5.716 c -0.843 1.219 -1.337 2.698 -1.337 4.292 c 0 0.86 0.146 1.686 0.411 2.457 c -1.18 1.334 -1.898 3.086 -1.898 5.007 c 0 4.176 3.385 7.561 7.561 7.561 c 1.692 0 3.254 -0.556 4.514 -1.495 c 0.826 3.28 3.795 5.708 7.331 5.708 c 1.967 0 3.758 -0.752 5.103 -1.983 c 1.231 1.966 3.415 3.274 5.905 3.274 c 3.846 0 6.963 -3.118 6.963 -6.963 c 0 -0.061 -0.003 -0.121 -0.005 -0.182 c 0.978 0.506 2.087 0.793 3.264 0.793 c 1.579 0 3.038 -0.515 4.219 -1.385 c 0.995 3.382 4.121 5.851 7.825 5.851 c 2.239 0 4.266 -0.902 5.741 -2.363 c 1.015 0.453 2.138 0.707 3.321 0.707 c 4.506 0 8.158 -3.652 8.158 -8.158 c 0 -1.258 -0.285 -2.449 -0.793 -3.512 c 3.278 -1.058 5.649 -4.133 5.649 -7.763 c 0 -1.52 -0.423 -2.938 -1.148 -4.157 C 82.117 31.611 83.376 29.527 83.376 27.144 z"),
        parseSvgPath(
            "M 36.717 90 h 17.786 c -3.688 -3.683 -3.603 -9.403 -3.627 -15.108 l 0 0 c 0.223 -6.449 2.375 -13.838 3.337 -21.428 l -2.278 -0.206 c -0.421 3.709 -1.478 7.201 -2.758 10.155 c -1.933 -4.69 -3.368 -7.247 -3.516 -12.666 h -1.608 c -0.749 4.365 -0.278 8.941 1.608 13.76 c -2.931 -4.097 -6.019 -7.1 -9.292 -8.813 l -1.659 1.674 c 4.013 2.908 7.848 8.641 7.499 15.218 C 42.208 80.466 41.172 85.438 36.717 90 z"));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class LoadUpClipPath extends CustomClipper<Rect> {
  final double fraction;

  LoadUpClipPath(this.fraction);

  @override
  Rect getClip(Size size) {
    double height = size.height * fraction;

    return Rect.fromLTWH(0, size.height - height, size.width, height);
  }

  @override
  bool shouldReclip(covariant LoadUpClipPath oldClipper) =>
      oldClipper.fraction != fraction;
}

class _AnimatedTreeIndicatorState extends State<AnimatedTreeIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'CO\u2082',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            TreeIndicator(animation.value, scale: 0.4,),
          ],
    );
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() => setState(() {}));
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class TreeIndicator extends StatelessWidget {
  final double fraction;
  final double scale;

  const TreeIndicator(this.fraction, {super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 90 * scale,
        height: 90 * scale,
        child: FittedBox(
          child: SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              children: [
                ClipPath(
                  clipper: TreeClipPath(),
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                ClipRect(
                  clipper: LoadUpClipPath(fraction),
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: StumpClipPath(),
                        child: Container(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      ClipPath(
                        clipper: LeavesClipPath(),
                        child: Container(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
