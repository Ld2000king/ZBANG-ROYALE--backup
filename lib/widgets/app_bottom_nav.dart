import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';
import 'pressable_scale.dart';
import '../theme/app_palette.dart';

class BottomNavItem {
  const BottomNavItem({required this.iconName, required this.label});

  final String iconName;
  final String label;
}

/// The app's tab bar: a white surface with a lime pill marking the active
/// tab, matching the rest of the light card system.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.panelLight,
        border: Border(top: BorderSide(color: context.palette.hairline)),
        boxShadow: context.palette.shadowSm,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < items.length; i++)
                _NavButton(
                  item: items[i],
                  selected: i == currentIndex,
                  onTap: () => onSelected(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected, required this.onTap});

  final BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // The active pill is a fixed bright lime in both themes, so its label
    // must use the fixed dark tone - the palette's textPrimary goes light
    // in dark mode and would disappear on it.
    final contentColor =
        selected ? AppColors.onBrightFill : context.palette.textSecondary;

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: PressableScale(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.limeFill : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(item.iconName, size: 22, color: contentColor),
              const SizedBox(height: 2),
              Text(item.label, style: AppTextStyles.badge.copyWith(color: contentColor)),
            ],
          ),
        ),
      ),
    );
  }
}
