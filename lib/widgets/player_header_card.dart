import 'package:flutter/material.dart';

import '../core/avatars_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'avatar_circle.dart';
import 'pressable_scale.dart';
import '../theme/app_palette.dart';

/// The home screen's identity card: current avatar, its name, the player's
/// personal best, and a bar showing how far that best is toward the next
/// 500-point milestone.
///
/// The bar is a presentation of the real `bestSingleScore` only - there is
/// no XP or level system behind it, and its caption says exactly what it
/// measures rather than implying one.
class PlayerHeaderCard extends StatelessWidget {
  const PlayerHeaderCard({
    super.key,
    required this.avatar,
    required this.bestScore,
    required this.onTap,
  });

  final AvatarInfo avatar;
  final int bestScore;
  final VoidCallback onTap;

  static const int _milestoneStep = 500;

  @override
  Widget build(BuildContext context) {
    final nextMilestone = (bestScore ~/ _milestoneStep + 1) * _milestoneStep;
    final progress = (bestScore % _milestoneStep) / _milestoneStep;
    final remaining = nextMilestone - bestScore;

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: appCardDecoration(context),
        child: Row(
          children: [
            AvatarCircle(avatar: avatar, size: 56),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(avatar.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(
                    'שיא אישי: $bestScore',
                    style: context.palette.secondaryText.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: context.palette.surface3,
                      valueColor: const AlwaysStoppedAnimation(AppColors.green),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'עוד $remaining נק׳ עד $nextMilestone',
                    style: context.palette.secondaryText.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.palette.surface2,
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: AppIcon('pencil', size: 16, color: context.palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
