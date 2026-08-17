import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../game/game_controller.dart';
import 'letter_tile.dart';

/// Drag-select gesture, ported from game.js's board drag handling.
///
/// The original binds pointermove/pointerup at `document` level - not per
/// tile - specifically because touch devices capture the pointer on the
/// first-touched element, which would prevent later tiles under the same
/// drag from ever seeing move events. A single [Listener] wrapping the whole
/// grid reproduces that: it keeps receiving pointer events for the drag
/// regardless of which tile is currently under the finger. Each tile is
/// then hit-tested by checking whether the pointer is within
/// [kTileHitRadiusFactor] of that tile's center (ported from
/// detectTileAt's center-radius check), not a plain bounding-box test.
class LetterGrid extends StatefulWidget {
  const LetterGrid({super.key, required this.controller});

  final GameController controller;

  @override
  State<LetterGrid> createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  List<GlobalKey> _tileKeys = [];

  @override
  void initState() {
    super.initState();
    _syncKeys();
  }

  @override
  void didUpdateWidget(covariant LetterGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncKeys();
  }

  void _syncKeys() {
    final length = widget.controller.board.length;
    if (_tileKeys.length != length) {
      _tileKeys = List.generate(length, (_) => GlobalKey());
    }
  }

  int? _hitTestTile(Offset globalPosition) {
    for (var i = 0; i < _tileKeys.length; i++) {
      final ctx = _tileKeys[i].currentContext;
      final box = ctx?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;

      final topLeft = box.localToGlobal(Offset.zero);
      final size = box.size;
      final center = topLeft + Offset(size.width / 2, size.height / 2);
      final radius = math.min(size.width, size.height) * kTileHitRadiusFactor;

      if ((globalPosition.dx - center.dx).abs() <= radius &&
          (globalPosition.dy - center.dy).abs() <= radius) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    _syncKeys();

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        final idx = _hitTestTile(event.position);
        if (idx != null) controller.pointerDownAt(idx);
      },
      onPointerMove: (event) {
        final idx = _hitTestTile(event.position);
        if (idx != null) controller.pointerMoveTo(idx);
      },
      onPointerUp: (_) => controller.endDrag(),
      onPointerCancel: (_) => controller.cancelDrag(),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.board.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.gridSize,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          return LetterTile(
            key: _tileKeys[index],
            letter: controller.board[index],
            selected: controller.dragPath.contains(index),
          );
        },
      ),
    );
  }
}
