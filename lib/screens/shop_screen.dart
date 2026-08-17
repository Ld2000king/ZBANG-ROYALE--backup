import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/shop_data.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/app_button.dart';

/// Ported from renderShop()'s power-up section + the mock rewarded-ad card.
/// Coin IAP packages and premium avatars are left for a later polish pass.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text('חנות', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on, color: AppColors.gold, size: 20),
                const SizedBox(width: 6),
                Text('${profile.coins}', style: AppTextStyles.bodyEmphasis),
                const SizedBox(width: 20),
                Icon(Icons.diamond, color: AppColors.blue, size: 20),
                const SizedBox(width: 6),
                Text('${profile.diamonds}', style: AppTextStyles.bodyEmphasis),
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
      decoration: BoxDecoration(
        color: AppColors.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('צפה בסרטון', style: AppTextStyles.bodyEmphasis),
                Text('קבל $kAdRewardCoins מטבעות חינם', style: AppTextStyles.bodySecondary),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            child: AppButton(
              label: '+$kAdRewardCoins',
              color: AppButtonColor.green,
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
      decoration: BoxDecoration(
        color: AppColors.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.name}  ·  במלאי: $owned', style: AppTextStyles.bodyEmphasis),
                Text(item.desc, style: AppTextStyles.bodySecondary),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            child: AppButton(
              label: '${item.cost} קנה',
              color: AppButtonColor.gold,
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
