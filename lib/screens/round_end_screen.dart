import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/battle_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/app_button.dart';

/// Ported from showRoundEnd() in game.js: standings for the round just
/// played, with the eliminated player/bot flagged, and a "next round" CTA.
class RoundEndScreen extends StatelessWidget {
  const RoundEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BattleController>();
    final result = controller.lastResult!;
    final standings = result.standings!;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${result.eliminatedName} הודח/ה מהסיבוב!', style: AppTextStyles.heading),
              const SizedBox(height: 24),
              ...standings.asMap().entries.map((entry) {
                final i = entry.key;
                final s = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: s.eliminated ? AppColors.red.withValues(alpha: 0.18) : AppColors.panelLight,
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Row(
                    children: [
                      Text('#${i + 1}', style: AppTextStyles.bodySecondary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(s.name, style: AppTextStyles.bodyEmphasis)),
                      Text('${s.score}', style: AppTextStyles.bodyEmphasis),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              AppButton(
                label: 'לסיבוב הבא',
                color: AppButtonColor.green,
                onPressed: () {
                  controller.nextRound();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
