import 'package:flutter/material.dart';

import '../../game/battle.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_text_styles.dart';

/// Ported from updateBattleUI() in game.js: the player first, then every
/// still-active bot, each showing name + live score.
class PlayerStatusRow extends StatelessWidget {
  const PlayerStatusRow({super.key, required this.playerScore, required this.bots});

  final int playerScore;
  final List<Bot> bots;

  @override
  Widget build(BuildContext context) {
    final active = bots.where((b) => !b.eliminated).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _StatusChip(name: 'אתה', score: playerScore, highlighted: true),
          for (final bot in active) ...[
            const SizedBox(width: 8),
            _StatusChip(name: bot.name, score: bot.score, highlighted: false),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.name, required this.score, required this.highlighted});

  final String name;
  final int score;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.green.withValues(alpha: 0.18) : AppColors.surface2,
        border: Border.all(color: highlighted ? AppColors.green : AppColors.surface3),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: AppTextStyles.bodySecondary),
          Text('$score', style: AppTextStyles.bodyEmphasis),
        ],
      ),
    );
  }
}
