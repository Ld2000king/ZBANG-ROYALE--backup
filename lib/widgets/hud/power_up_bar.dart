import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/shop_data.dart';
import '../../game/player_profile_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_text_styles.dart';
import '../app_icon.dart';
import '../pressable_scale.dart';
import '../../theme/app_palette.dart';

class PowerUpSpec {
  const PowerUpSpec({required this.itemKey, required this.onUse});

  /// Also the AppIcon name - every shop item key matches its icon in
  /// icons.js (hint/shuffle/freeze/freezeOpponents/tornado).
  final String itemKey;

  /// Applies the power-up's effect and returns whether it actually
  /// happened (e.g. a hint found a word) - payment is only charged when
  /// this returns true, mirroring canPayForItem()/consumeItemPayment() in
  /// game.js.
  final bool Function() onUse;
}

/// A row of power-up buttons, each showing its owned-inventory count (or
/// its coin cost when the inventory is empty). Tapping applies the
/// power-up's effect and, only if it actually took effect, charges the
/// player - inventory first, then coins.
class PowerUpBar extends StatelessWidget {
  const PowerUpBar({super.key, required this.items});

  final List<PowerUpSpec> items;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final spec in items) ...[
          _PowerUpButton(spec: spec, profile: profile),
          const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _PowerUpButton extends StatelessWidget {
  const _PowerUpButton({required this.spec, required this.profile});

  final PowerUpSpec spec;
  final PlayerProfileController profile;

  ShopItem get _item => kShopItems.firstWhere((i) => i.key == spec.itemKey);

  void _handleTap(BuildContext context) {
    if (!profile.canAfford(spec.itemKey)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('אין מספיק מטבעות! (${_item.name} עולה ${_item.cost})')),
      );
      return;
    }
    if (spec.onUse()) profile.consumePowerUp(spec.itemKey);
  }

  @override
  Widget build(BuildContext context) {
    final count = profile.inventoryCount(spec.itemKey);
    return PressableScale(
      onTap: () => _handleTap(context),
      child: Container(
        width: 52,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: context.palette.surface2,
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(spec.itemKey, size: 20, color: context.palette.textPrimary),
            const SizedBox(height: 2),
            Text(
              count > 0 ? '$count' : '${_item.cost}',
              style: context.palette.secondaryText.copyWith(
                color: count > 0 ? AppColors.green : AppColors.gold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
