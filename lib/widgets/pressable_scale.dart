import 'package:flutter/widgets.dart';

/// The one spring curve that carries every tap in the app -
/// cubic-bezier(0.34, 1.56, 0.64, 1) - a small overshoot that reads as a
/// bouncy, physical press rather than a flat state change.
const Curve kSpringCurve = Cubic(0.34, 1.56, 0.64, 1);
const Duration kSpringDuration = Duration(milliseconds: 180);

/// Wraps any widget with a press-down scale (0.93-0.97) on the spring curve.
/// Purely a visual affordance - the actual tap handling (ripple, semantics)
/// stays with whatever [child] already provides; this only needs [onTap] to
/// know when to animate, and forwards taps that land on transparent/plain
/// children too.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: kSpringDuration,
        curve: kSpringCurve,
        child: widget.child,
      ),
    );
  }
}
