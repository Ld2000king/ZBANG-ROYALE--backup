import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../game/battle_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/feedback/toast_banner.dart';
import '../widgets/hud/player_status_row.dart';
import '../widgets/hud/power_up_bar.dart';
import '../widgets/hud/timer_display.dart';
import '../widgets/letter_grid.dart';
import '../widgets/pressable_scale.dart';
import 'battle_result_screen.dart';
import 'round_end_screen.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    context.read<BattleController>().addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final controller = context.read<BattleController>();
    final result = controller.lastResult;
    if (result != null && !_navigated) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        switch (result.type) {
          case BattleOutcomeType.roundEnd:
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: controller,
                      child: const RoundEndScreen(),
                    ),
                  ),
                )
                .then((_) => _navigated = false);
          case BattleOutcomeType.victory:
          case BattleOutcomeType.defeat:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => BattleResultScreen(result: result)),
            );
        }
      });
    }
  }

  @override
  void dispose() {
    context.read<BattleController>().removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Consumer<BattleController>(
          builder: (context, controller, _) {
            final diffName = kBotDifficultyTiers[controller.difficulty]!.displayName;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'סיבוב ${controller.currentRound}/$kBattleTotalRounds · $diffName',
                        style: AppTextStyles.bodySecondary,
                      ),
                      PressableScale(
                        onTap: controller.togglePause,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: AppIcon(
                            controller.isPaused ? 'play' : 'pause',
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  PlayerStatusRow(playerScore: controller.playerScore, bots: controller.bots),
                  const SizedBox(height: 12),
                  TimerDisplay(secondsLeft: controller.timeLeft),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 28,
                    child: Center(
                      child: Text(controller.currentWord, style: AppTextStyles.heading),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ToastBanner(controller: controller),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: LetterGrid(controller: controller),
                        ),
                        if (controller.isPaused)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.bgDeep.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(AppRadii.card),
                            ),
                            child: Center(
                              child: Text('מושהה', style: AppTextStyles.heading),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PowerUpBar(
                    items: [
                      PowerUpSpec(itemKey: 'hint', onUse: controller.useHint),
                      PowerUpSpec(
                        itemKey: 'shuffle',
                        onUse: () {
                          controller.useShuffle();
                          return true;
                        },
                      ),
                      PowerUpSpec(
                        itemKey: 'freezeOpponents',
                        onUse: () {
                          controller.useFreezeOpponents();
                          return true;
                        },
                      ),
                      PowerUpSpec(
                        itemKey: 'tornado',
                        onUse: () {
                          controller.useTornado();
                          return true;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
