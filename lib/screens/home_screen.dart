import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/avatars_data.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/buttons/app_button.dart';
import '../widgets/pressable_scale.dart';
import 'mode_select_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    // A quiet "rise-in" on load, ported from the web app's home-screen-rise
    // ambient animation - content settles in rather than just appearing.
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();
    final avatar = avatarById(profile.avatarId);
    final curved = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.05), end: Offset.zero).animate(curved),
              child: Column(
                children: [
                  Text('זבאנג רויאל', textAlign: TextAlign.center, style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  Text(
                    'מצא מילים בעברית על הלוח',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySecondary,
                  ),
                  const SizedBox(height: 24),
                  _StatsCard(profile: profile, avatar: avatar),
                  const Spacer(),
                  AppButton(
                    label: 'משחק',
                    color: AppButtonColor.green,
                    iconName: 'play',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ModeSelectScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'חנות',
                    color: AppButtonColor.gold,
                    iconName: 'shopBag',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ShopScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'פרופיל',
                    color: AppButtonColor.blue,
                    iconName: 'profile',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.profile, required this.avatar});

  final PlayerProfileController profile;
  final AvatarInfo avatar;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.panelLight,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatLine(iconName: 'coin', value: '${profile.coins}'),
                const SizedBox(height: 6),
                _StatLine(iconName: 'diamond', value: '${profile.diamonds}'),
              ],
            ),
            const Spacer(),
            AvatarCircle(avatar: avatar, size: 52),
          ],
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.iconName, required this.value});

  final String iconName;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.bodyEmphasis),
        const SizedBox(width: 6),
        AppIcon(iconName, size: 18),
      ],
    );
  }
}
