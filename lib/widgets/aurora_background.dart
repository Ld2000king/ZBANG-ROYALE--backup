import 'dart:ui';

import 'package:flutter/material.dart';

/// Ambient "aurora" glow ported from #homeScreen::before/::after in
/// game.css: two soft, heavily-blurred radial color pools - blue up top,
/// magenta down low - drifting slowly behind the content. This is what
/// keeps the dark theme from reading as flat charcoal.
///
/// [strength] scales the pools' opacity: the full glow reads well on the
/// dark surfaces it was designed for, and is dialled down on light ones
/// where the same alpha would turn the page muddy.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key, required this.child, this.strength = 1});

  final Widget child;

  /// 0 = no glow, 1 = the full strength the CSS uses on the dark theme.
  final double strength;

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
              base: const Color(0xFF6096FF),
              strength: widget.strength,
              dx: 40,
            ),
          ),
          Positioned(
            bottom: -140,
            left: -120,
            child: _AuroraBlob(
              controller: _pink,
              base: const Color(0xFFCE58C4),
              strength: widget.strength,
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
  const _AuroraBlob({
    required this.controller,
    required this.base,
    required this.strength,
    required this.dx,
  });

  final AnimationController controller;
  final Color base;
  final double strength;
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
              gradient: RadialGradient(
                colors: [
                  base.withValues(alpha: 0.60 * strength),
                  base.withValues(alpha: 0.12 * strength),
                  Colors.transparent,
                ],
                stops: const [0, 0.55, 0.70],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
