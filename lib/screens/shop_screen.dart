import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/shop_data.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons/app_button.dart';
import '../widgets/stat_chip.dart';
import '../theme/app_palette.dart';

/// Ported from renderShop()'s power-up section + the mock rewarded-ad card.
/// Coin IAP packages and premium avatars are left for a later polish pass.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();

    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('חנות', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          // Extra bottom room so the last row clears the shell's
          // bottom nav bar instead of hiding behind it.
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatChip(iconName: 'coin', value: '${profile.coins}'),
                StatChip(iconName: 'diamond', value: '${profile.diamonds}'),
              ],
            ),
            const SizedBox(height: 20),
            _AdCard(profile: profile),
            const SizedBox(height: 24),
            Text('עזרים למשחק', style: AppTextStyles.heading.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            for (final item in kShopItems) ...[
              _ShopItemRow(item: item, profile: profile),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  const _AdCard({required this.profile});

  final PlayerProfileController profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: appCardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('צפה בסרטון', style: AppTextStyles.bodyEmphasis),
                Text('קבל $kAdRewardCoins מטבעות חינם', style: context.palette.secondaryText),
              ],
            ),
          ),
          SizedBox(
            width: 104,
            child: AppButton(
              label: '+$kAdRewardCoins',
              color: AppButtonColor.green,
              compact: true,
              onPressed: () {
                profile.addCoins(kAdRewardCoins);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('קיבלת $kAdRewardCoins מטבעות!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopItemRow extends StatelessWidget {
  const _ShopItemRow({required this.item, required this.profile});

  final ShopItem item;
  final PlayerProfileController profile;

  @override
  Widget build(BuildContext context) {
    final owned = profile.inventoryCount(item.key);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: appCardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.name}  ·  במלאי: $owned', style: AppTextStyles.bodyEmphasis),
                Text(item.desc, style: context.palette.secondaryText),
              ],
            ),
          ),
          SizedBox(
            width: 104,
            child: AppButton(
              label: '${item.cost} קנה',
              color: AppButtonColor.gold,
              compact: true,
              onPressed: () {
                final bought = profile.buyPowerUp(item.key);
                final message = bought ? '${item.name} נוסף למלאי!' : 'אין מספיק מטבעות!';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
