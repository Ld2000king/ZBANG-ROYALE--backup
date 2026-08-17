import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/daily_reward_data.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/buttons/app_button.dart';
import '../theme/app_palette.dart';

/// Ported from the daily-reward modal (renderDailyReward/claimDailyReward in
/// game.js): a 7-day login-streak track, today's day highlighted, past days
/// marked done, and a claim button that pays out coins (and, on day 7,
/// diamonds).
class DailyRewardScreen extends StatelessWidget {
  const DailyRewardScreen({super.key});

  void _claim(BuildContext context) {
    final profile = context.read<PlayerProfileController>();
    final reward = profile.claimDailyReward();
    if (reward == null) return;

    var message = 'קיבלת ${reward.coins} מטבעות';
    if (reward.diamonds > 0) message += ' ו-${reward.diamonds} יהלומים';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message!')));
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PlayerProfileController>();
    final available = profile.dailyRewardAvailable;
    final pending = profile.pendingDailyStreak;
    // 1-based day-of-week within the current 7-day cycle: the highlighted
    // day while unclaimed, or the last claimed day once today's is done.
    final activeDay = ((pending - 1) % 7) + 1;
    final claimedDay = ((profile.dailyStreak - 1) % 7) + 1;

    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('בונוס יומי', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
              Text(
                available ? 'רצף התחברות: $pending ימים' : 'כבר קיבלת היום — חזור מחר!',
                style: context.palette.secondaryText,
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.4,
                children: [
                  for (var i = 0; i < kDailyRewards.length; i++)
                    _DailyDayTile(
                      day: i + 1,
                      reward: kDailyRewards[i],
                      isToday: available && i + 1 == activeDay,
                      isDone: available ? i + 1 < activeDay : i + 1 <= claimedDay,
                    ),
                ],
              ),
              const SizedBox(height: 24),
              if (available)
                AppButton(
                  label: 'קבל בונוס',
                  color: AppButtonColor.gold,
                  onPressed: () => _claim(context),
                ),
          ],
        ),
      ),
    );
  }
}

class _DailyDayTile extends StatelessWidget {
  const _DailyDayTile({
    required this.day,
    required this.reward,
    required this.isToday,
    required this.isDone,
  });

  final int day;
  final DailyReward reward;
  final bool isToday;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: appCardDecoration(
        context,
        radius: AppRadii.sm,
        border: !isToday,
      ).copyWith(
        border: isToday ? Border.all(color: AppColors.gold, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('יום $day', style: context.palette.secondaryText),
              if (isDone) ...[
                const SizedBox(width: 6),
                AppIcon('check', size: 12, color: context.palette.textSecondary),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(reward.diamonds > 0 ? 'diamond' : 'coin', size: 16),
              const SizedBox(width: 4),
              Text(
                '${reward.diamonds > 0 ? reward.diamonds : reward.coins}',
                style: AppTextStyles.bodyEmphasis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
