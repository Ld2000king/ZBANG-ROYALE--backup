import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_text_styles.dart';
import '../app_icon.dart';
import '../pressable_scale.dart';

enum AppButtonColor { green, gold, blue, orange, purple, red }

const Map<AppButtonColor, Color> _colorMap = {
  AppButtonColor.green: AppColors.green,
  AppButtonColor.gold: AppColors.gold,
  AppButtonColor.blue: AppColors.blue,
  AppButtonColor.orange: AppColors.orange,
  AppButtonColor.purple: AppColors.purple,
  AppButtonColor.red: AppColors.red,
};

/// The app's primary button: a saturated fill (one color per action), white
/// label, soft accent-tinted lift, and a spring press. Every fill here is a
/// saturated accent, so the label is always [AppColors.textLight].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppButtonColor.green,
    this.enabled = true,
    this.iconName,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonColor color;
  final bool enabled;

  /// Optional AppIcon name shown beside the label - in reading order (the
  /// app is RTL throughout, so this renders on the right, before the text,
  /// matching the web app's play/shop/profile buttons).
  final String? iconName;

  /// Tighter padding and a smaller label, for buttons that sit inside a
  /// narrow slot (a list row's trailing action) rather than spanning the
  /// screen.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final base = _colorMap[color]!;
    final active = enabled ? onPressed : null;

    return PressableScale(
      onTap: active,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.btn),
          boxShadow: active == null ? null : AppShadows.accent(base),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: active,
            style: ElevatedButton.styleFrom(
              backgroundColor: base,
              disabledBackgroundColor: AppColors.surface3,
              disabledForegroundColor: AppColors.textSecondary,
              foregroundColor: AppColors.textLight,
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 12 : 20,
                vertical: compact ? 12 : 18,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.btn),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconName != null) ...[
                  AppIcon(iconName!, size: compact ? 16 : 20, color: AppColors.textLight),
                  const SizedBox(width: 8),
                ],
                // Flexible + ellipsis so a long label in a narrow slot
                // shrinks instead of overflowing the row.
                Flexible(
                  child: Text(
                    label,
                    style: compact
                        ? AppTextStyles.button.copyWith(fontSize: 14)
                        : AppTextStyles.button,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
