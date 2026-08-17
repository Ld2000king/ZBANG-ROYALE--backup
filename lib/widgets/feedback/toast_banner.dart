import 'dart:async';

import 'package:flutter/material.dart';

import '../../game/draggable_board_controller.dart';
import '../../game/game_message.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_text_styles.dart';

const Map<GameMessageType, Color> _typeColors = {
  GameMessageType.error: AppColors.red,
  GameMessageType.warning: AppColors.gold,
  GameMessageType.info: AppColors.blue,
  GameMessageType.success: AppColors.green,
};

/// Shows GameController's transient word-outcome / reshuffle messages just
/// above the board for ~1s, mirroring showBoardMessage() in game.js.
class ToastBanner extends StatefulWidget {
  const ToastBanner({super.key, required this.controller});

  final DraggableBoardController controller;

  @override
  State<ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<ToastBanner> {
  int _lastNonce = 0;
  bool _visible = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final nonce = widget.controller.messageNonce;
    if (nonce != _lastNonce) {
      _lastNonce = nonce;
      _hideTimer?.cancel();
      setState(() => _visible = true);
      _hideTimer = Timer(const Duration(milliseconds: 1100), () {
        if (mounted) setState(() => _visible = false);
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.controller.message;
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _visible && message != null ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        child: message == null
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _typeColors[message.type]!.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Text(
                  message.text,
                  style: AppTextStyles.bodyEmphasis.copyWith(color: AppColors.textLight),
                ),
              ),
      ),
    );
  }
}
