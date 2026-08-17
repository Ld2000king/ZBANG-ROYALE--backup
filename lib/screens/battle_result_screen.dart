import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/battle.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/app_button.dart';
import 'battle_difficulty_screen.dart';
import 'home_screen.dart';

/// Ported from the two endBattleRound() outcomes that end the run: player
/// eliminated (defeat) or the final round won (victory + coin/diamond bonus).
class BattleResultScreen extends StatefulWidget {
  const BattleResultScreen({super.key, required this.result});

  final BattleRoundResult result;

  @override
  State<BattleResultScreen> createState() => _BattleResultScreenState();
}

class _BattleResultScreenState extends State<BattleResultScreen> {
  @override
  void initState() {
    super.initState();
    final profile = context.read<PlayerProfileController>();
    final result = widget.result;
    profile.addCoins(result.totalCoins ?? 0);
    if (result.type == BattleOutcomeType.victory) {
      profile.addDiamonds(result.diamonds ?? 0);
    }
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _newChallenge(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BattleDifficultyScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final isVictory = result.type == BattleOutcomeType.victory;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isVictory ? 'ניצחת!' : 'הודחת!',
                style: AppTextStyles.title.copyWith(
                  color: isVictory ? AppColors.gold : AppColors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isVictory
                    ? 'שרדת את כל 5 הסיבובים!'
                    : 'הודחת בסיבוב ${result.round} מתוך 5',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 24),
              if (isVictory) ...[
                Text('+${result.diamonds} יהלומים', style: AppTextStyles.bodyEmphasis),
                const SizedBox(height: 4),
              ],
              Text('סה"כ: ${result.totalCoins} מטבעות', style: AppTextStyles.bodyEmphasis),
              const SizedBox(height: 48),
              AppButton(
                label: 'אתגר חדש',
                color: AppButtonColor.green,
                onPressed: () => _newChallenge(context),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'מסך הבית',
                color: AppButtonColor.blue,
                onPressed: () => _goHome(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
