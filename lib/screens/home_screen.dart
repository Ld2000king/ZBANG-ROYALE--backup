import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/buttons/app_button.dart';
import '../widgets/buttons/menu_icon_button.dart';
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
    final curved = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PressableScale(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ShopScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.panelLight,
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppIcon('diamond', size: 18),
                          const SizedBox(width: 4),
                          Text('${profile.diamonds}', style: AppTextStyles.bodyEmphasis),
                          const SizedBox(width: 12),
                          const AppIcon('coin', size: 18),
                          const SizedBox(width: 4),
                          Text('${profile.coins}', style: AppTextStyles.bodyEmphasis),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: curved,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'זבאנג רויאל',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'מצא מילים בעברית על הלוח',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySecondary,
                        ),
                        const SizedBox(height: 40),
                        AppButton(
                          label: 'שחק',
                          color: AppButtonColor.green,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ModeSelectScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MenuIconButton(
                              iconName: 'shopBag',
                              label: 'חנות',
                              color: AppColors.gold,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ShopScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 28),
                            MenuIconButton(
                              iconName: 'profile',
                              label: 'פרופיל',
                              color: AppColors.blue,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
