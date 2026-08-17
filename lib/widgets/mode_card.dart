import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';
import 'pressable_scale.dart';
import '../theme/app_palette.dart';

/// One tile in the home screen's game-mode grid: a bright pastel card with
/// a white icon badge, a bold title, a one-line subtitle, and an optional
/// corner badge ("חדש" / "בקרוב").
///
/// The fill colors are the *Fill pastels, so all text on them is
/// [context.palette.textPrimary] - never white.
class ModeCard extends StatelessWidget {
  const ModeCard({
    super.key,
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.fill,
    this.onTap,
    this.badge,
    this.badgeColor,
    this.enabled = true,
  });

  final String iconName;
  final String title;
  final String subtitle;
  final Color fill;
  final VoidCallback? onTap;

  /// Corner label, e.g. "בקרוב" for a mode that isn't built yet.
  final String? badge;
  final Color? badgeColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // An enabled card sits on a fixed bright pastel, so its content is
    // always the fixed dark tone - the palette's textPrimary would go light
    // in dark mode and vanish against the lime. A disabled card drops the
    // pastel entirely and uses a palette surface, so it follows the theme.
    final effectiveFill = enabled ? fill : context.palette.surface2;
    final contentColor = enabled ? AppColors.onBrightFill : context.palette.textSecondary;

    final card = Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: effectiveFill,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: enabled ? context.palette.shadowSm : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              // White on the pastel in both themes, matching contentColor.
              color: enabled
                  ? AppColors.textLight.withValues(alpha: 0.85)
                  : context.palette.panelLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Center(child: AppIcon(iconName, size: 22, color: contentColor)),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(color: contentColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: context.palette.secondaryText.copyWith(
              color: contentColor.withValues(alpha: 0.75),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    final withBadge = badge == null
        ? card
        : Stack(
            clipBehavior: Clip.none,
            children: [
              card,
              PositionedDirectional(
                top: -8,
                start: -4,
                child: _CornerBadge(label: badge!, color: badgeColor ?? context.palette.textPrimary),
              ),
            ],
          );

    return PressableScale(onTap: enabled ? onTap : null, child: withBadge);
  }
}

class _CornerBadge extends StatelessWidget {
  const _CornerBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        boxShadow: context.palette.shadowSm,
      ),
      child: Text(label, style: AppTextStyles.badge.copyWith(color: AppColors.textLight)),
    );
  }
}
