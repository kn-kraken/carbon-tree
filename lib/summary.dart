import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class Summary extends StatefulWidget {
  final double co2;

  const Summary({super.key, required this.co2});

  @override
  State<Summary> createState() => _SummaryState();
}

abstract class GreenChoice {
  final String name;
  final double co2perTree;

  const GreenChoice(this.name, this.co2perTree);

  Widget getIndicator(double co2);
  String entityName();
}

class TreeChoice extends GreenChoice {
  const TreeChoice(super.name, super.co2perTree);

  @override
  String entityName() => 'trees';

  @override
  Widget getIndicator(double co2) {
    return AnimatedIndicators(
      value: co2 / co2perTree,
      getIndicator: ({required scale, required value}) {
        return TreeIndicator(value, scale: scale);
      },
    );
  }
}

class ParkChoice extends GreenChoice {
  const ParkChoice(super.name, super.co2perTree);

  @override
  String entityName() => 'of all trees in this park';

  @override
  Widget getIndicator(double co2) {
    return AnimatedIndicators(
      value: co2 / co2perTree,
      getIndicator: ({required scale, required value}) {
        return ParkIndicator(value, scale: scale * 0.4);
      },
    );
  }
}

const _choices = [
  TreeChoice('Large Trees', 9.0),
  TreeChoice('Medium Trees', 6.0),
  TreeChoice('Small Trees', 3.0),
  ParkChoice('Skałki Twardowskiego', 300.0)
];

class _SummaryState extends State<Summary> {
  GreenChoice _selectedChoice = _choices[0];

  double get co2 => widget.co2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Emission Summary'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'CO\u2082',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8),
              Text(
                '$co2 L released into the atmosphere',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              DropdownButton<GreenChoice>(
                isExpanded: true,
                value: _selectedChoice,
                hint: Text('Select an option'),
                onChanged: (GreenChoice? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedChoice = newValue;
                    });
                  }
                },
                items: _choices
                    .map<DropdownMenuItem<GreenChoice>>((GreenChoice choice) {
                  return DropdownMenuItem<GreenChoice>(
                    value: choice,
                    child: Text(choice.name),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              _selectedChoice.getIndicator(co2),
              SizedBox(height: 16),
              Flexible(
                child: Text(
                  'It would take ${(co2 / _selectedChoice.co2perTree).toStringAsPrecision(2)} ${_selectedChoice.entityName()} to consume this CO\u2082 in one day',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Dismiss'),
              ),
            ],
          ),
        ));
  }
}

class ParkClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return parseSvgPath(
        "M145.5 275.5L104.5 287L97.5 290C85.8333 286.167 81.5 264 55.5 295.5C38.3718 316.251 10.3411 318.201 6.5 315C3.5 312.5 -3.5 270.5 6.5 239.5C16.5 208.5 20 225 47.5 193.5C75 162 62 155 73.5 137C85 119 104.5 121 126.5 120C148.5 119 135 145 136.5 160.5C138 176 158.5 160.5 158.5 145C158.5 129.5 185 117 187.5 115.5C196.128 110.323 166 92.5 158.5 85.5C151 78.5 104.5 87 108.5 64.5C112.5 42 145.5 12 158.5 3.49999C171.5 -5.00003 194 12 205 17C216 22 223 55.5 239.5 68C256 80.5 252.441 58.4248 289.5 64.5C320 69.5 285 50.5 296 30C307.545 8.48362 322.5 12 329 12C345.919 12 359 21.5 365 27C371 32.5 379 87 377.5 107.5C376 128 351 149 351 156C351 163 392 170.5 402.5 177C413 183.5 380 229.5 369.5 236C359 242.5 340 229 329 225C318 221 309 232.5 296.5 239.5C284 246.5 290.5 247 283.5 266.5C276.5 286 283.5 301 283.5 315C283.5 329 240.5 400 234 404.5C227.5 409 214.5 396 205 392C195.5 388 178 304.5 172 287C167.2 273 152.333 273.5 145.5 275.5Z");
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ParkIndicator extends StatelessWidget {
  final double fraction;
  final double scale;

  const ParkIndicator(this.fraction, {super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400 * scale,
        height: 400 * scale,
        child: FittedBox(
          child: SizedBox(
            height: 400,
            width: 400,
            child: Stack(
              children: [
                ClipPath(
                  clipper: ParkClipPath(),
                  child: Container(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                ClipRect(
                  clipper: LoadUpClipPath(fraction),
                  child: ClipPath(
                    clipper: ParkClipPath(),
                    child: Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

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
        TreeIndicator(
          animation.value,
          scale: 0.4,
        ),
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
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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

class AnimatedIndicators extends StatefulWidget {
  final double value;
  final Duration animationDuration;
  final double spacing;
  final double runSpacing;
  final Widget Function({required double value, required double scale})
      getIndicator;

  const AnimatedIndicators({
    Key? key,
    required this.value,
    required this.getIndicator,
    this.animationDuration = const Duration(milliseconds: 500),
    this.spacing = 4,
    this.runSpacing = 4,
  }) : super(key: key);

  @override
  _AnimatedIndicatorsState createState() => _AnimatedIndicatorsState();
}

class _AnimatedIndicatorsState extends State<AnimatedIndicators>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final int fullIndicators = widget.value.floor();
    final double fractionalPart = widget.value - fullIndicators;

    _controllers = List.generate(
      fullIndicators + 1,
      (index) => AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Set the last animation to the fractional part
    if (_animations.isNotEmpty) {
      _animations.last = Tween<double>(begin: 0, end: fractionalPart).animate(
        CurvedAnimation(parent: _controllers.last, curve: Curves.easeInOut),
      );
    }

    // Start animations sequentially
    _startAnimationsSequentially();
  }

  void _startAnimationsSequentially() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedIndicators oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // Dispose old controllers and reinitialize animations
      for (var controller in _controllers) {
        controller.dispose();
      }
      _initializeAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      alignment: WrapAlignment.center,
      children: List.generate(
        _animations.length,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return widget.getIndicator(
              value: _animations[index].value,
              scale: 0.5,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
