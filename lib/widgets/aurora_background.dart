import 'dart:ui';

import 'package:flutter/material.dart';

/// Ambient "aurora" glow ported from #homeScreen::before/::after in
/// game.css: two soft, heavily-blurred radial color pools drifting slowly
/// behind the content - pure decoration, the app stays flat/matte
/// everywhere else. Clips to the available space, same as #app's
/// overflow:hidden containing the CSS version.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground> with TickerProviderStateMixin {
  late final AnimationController _blue;
  late final AnimationController _pink;

  @override
  void initState() {
    super.initState();
    _blue = AnimationController(vsync: this, duration: const Duration(seconds: 14))
      ..repeat(reverse: true);
    _pink = AnimationController(vsync: this, duration: const Duration(seconds: 18))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blue.dispose();
    _pink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: _AuroraBlob(
              controller: _blue,
              colors: const [Color(0x996096FF), Color(0x1F6096FF), Colors.transparent],
              dx: 40,
            ),
          ),
          Positioned(
            bottom: -140,
            left: -120,
            child: _AuroraBlob(
              controller: _pink,
              colors: const [Color(0x8CCE58C4), Color(0x1FCE58C4), Colors.transparent],
              dx: -40,
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  const _AuroraBlob({required this.controller, required this.colors, required this.dx});

  final AnimationController controller;
  final List<Color> colors;
  final double dx;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(controller.value);
          return Transform.translate(
            offset: Offset(dx * t, 30 * t),
            child: Transform.scale(scale: 1 + 0.15 * t, child: child),
          );
        },
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 65, sigmaY: 65),
          child: Container(
            width: 460,
            height: 460,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: colors, stops: const [0, 0.55, 0.70]),
            ),
          ),
        ),
      ),
    );
  }
}
