import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/avatars_data.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/pressable_scale.dart';
import '../theme/app_palette.dart';

/// Ported from renderProfile()'s stats block + the avatar gallery.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();
    final currentAvatar = avatarById(profile.avatarId);

    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('פרופיל', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          // Extra bottom room so the last row clears the shell's
          // bottom nav bar instead of hiding behind it.
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Center(child: AvatarCircle(avatar: currentAvatar, size: 88)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: appCardDecoration(context),
              child: Column(
                children: [
                  _StatRow(iconName: 'coin', label: 'מטבעות', value: '${profile.coins}'),
                  const SizedBox(height: 10),
                  _StatRow(iconName: 'diamond', label: 'יהלומים', value: '${profile.diamonds}'),
                  const SizedBox(height: 10),
                  _StatRow(
                    iconName: 'trophy',
                    label: 'שיא שחקן יחיד',
                    value: '${profile.bestSingleScore}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('הגדרות', style: AppTextStyles.heading.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            _DarkModeRow(profile: profile),
            const SizedBox(height: 24),
            Text('תמונות פרופיל', style: AppTextStyles.heading.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kAvatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final avatar = kAvatars[index];
                final owned = profile.isAvatarOwned(avatar.id);
                final selected = avatar.id == profile.avatarId;

                return PressableScale(
                  onTap: () => _handleTap(context, profile, avatar, owned),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(color: AppColors.gold, width: 3)
                              : null,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: AvatarCircle(avatar: avatar, size: 52, locked: !owned),
                      ),
                      if (avatar.premium && !owned) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppIcon('diamond', size: 12),
                            const SizedBox(width: 2),
                            Text('$kAvatarDiamondCost', style: context.palette.secondaryText.copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(
    BuildContext context,
    PlayerProfileController profile,
    AvatarInfo avatar,
    bool owned,
  ) {
    if (owned) {
      profile.selectAvatar(avatar.id);
      return;
    }
    final bought = profile.buyAvatar(avatar.id);
    final message = bought
        ? 'התמונה "${avatar.name}" נוספה לאוסף!'
        : 'אין מספיק יהלומים! (עולה $kAvatarDiamondCost)';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    if (bought) profile.selectAvatar(avatar.id);
  }
}

/// The dark-mode switch. Flipping it persists the choice and rebuilds
/// MaterialApp with the other theme.
class _DarkModeRow extends StatelessWidget {
  const _DarkModeRow({required this.profile});

  final PlayerProfileController profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: appCardDecoration(context),
      child: Row(
        children: [
          AppIcon(profile.darkMode ? 'freeze' : 'hint', size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('מצב כהה', style: AppTextStyles.body),
                Text(
                  profile.darkMode ? 'העיצוב הכהה פעיל' : 'העיצוב הבהיר פעיל',
                  style: context.palette.secondaryText.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: profile.darkMode,
            onChanged: profile.setDarkMode,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.iconName, required this.label, required this.value});

  final String iconName;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(iconName, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Text(value, style: AppTextStyles.bodyEmphasis),
      ],
    );
  }
}
