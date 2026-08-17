import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/avatars_data.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/mode_card.dart';
import '../widgets/player_header_card.dart';
import '../widgets/stat_chip.dart';
import 'battle_difficulty_screen.dart';
import 'home_shell.dart';
import 'profile_screen.dart';
import 'single_duration_screen.dart';
import '../theme/app_palette.dart';

/// The Home tab inside [HomeShell]: currency chips, the player card, and the
/// game-mode grid. Modes launch straight from here - there's no separate
/// mode-picker step.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openProfile(BuildContext context) {
    // Profile is a sibling tab, not a pushed route - switch the shell to it.
    // Falls back to a push if Home is ever shown outside the shell.
    final shell = HomeShellScope.maybeOf(context);
    if (shell != null) {
      shell.goToTab(HomeTab.profile);
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();
    final avatar = avatarById(profile.avatarId);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatChip(iconName: 'coin', value: '${profile.coins}'),
              StatChip(iconName: 'diamond', value: '${profile.diamonds}'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('זבאנג רויאל', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.xs),
          Text('מצא מילים בעברית על הלוח', style: context.palette.secondaryText),
          const SizedBox(height: AppSpacing.lg),
          PlayerHeaderCard(
            avatar: avatar,
            bestScore: profile.bestSingleScore,
            onTap: () => _openProfile(context),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('מצבי משחק', style: AppTextStyles.heading.copyWith(fontSize: 18)),
          const SizedBox(height: AppSpacing.md),
          const _ModeGrid(),
        ],
      ),
    );
  }
}

class _ModeGrid extends StatelessWidget {
  const _ModeGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Two columns on a phone; the cards keep a comfortable aspect ratio
        // rather than a fixed height, so long Hebrew subtitles still fit.
        const gap = AppSpacing.md;
        final cardWidth = (constraints.maxWidth - gap) / 2;

        Widget sized(Widget child) => SizedBox(width: cardWidth, child: child);

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            sized(
              ModeCard(
                iconName: 'timer',
                title: 'שחקן יחיד',
                subtitle: 'מרוץ נגד השעון',
                fill: AppColors.limeFill,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SingleDurationScreen()),
                ),
              ),
            ),
            sized(
              ModeCard(
                iconName: 'sword',
                title: 'באטל רויאל',
                subtitle: '5 סיבובים מול בוטים',
                fill: AppColors.amberFill,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BattleDifficultyScreen()),
                ),
              ),
            ),
            sized(
              ModeCard(
                iconName: 'users',
                title: 'מולטיפלייר',
                subtitle: 'נגד חברים בזמן אמת',
                fill: AppColors.violetFill,
                badge: 'בקרוב',
                badgeColor: context.palette.textSecondary,
                enabled: false,
              ),
            ),
            sized(
              ModeCard(
                iconName: 'versus',
                title: 'התאמה אקראית',
                subtitle: 'קרב 1 על 1',
                fill: AppColors.skyFill,
                badge: 'בקרוב',
                badgeColor: context.palette.textSecondary,
                enabled: false,
              ),
            ),
          ],
        );
      },
    );
  }
}
