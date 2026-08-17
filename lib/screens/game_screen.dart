import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../game/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_icon.dart';
import '../widgets/feedback/toast_banner.dart';
import '../widgets/hud/found_words_panel.dart';
import '../widgets/hud/power_up_bar.dart';
import '../widgets/hud/score_display.dart';
import '../widgets/hud/timer_display.dart';
import '../widgets/letter_grid.dart';
import '../widgets/pressable_scale.dart';
import 'result_screen.dart';
import '../theme/app_palette.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.duration});

  final SingleDuration duration;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _navigatedToResult = false;

  @override
  void initState() {
    super.initState();
    context.read<GameController>().addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final controller = context.read<GameController>();
    if (!controller.gameActive && controller.timeLeft <= 0 && !_navigatedToResult) {
      _navigatedToResult = true;
      final score = controller.score;
      final wordsFound = controller.foundWords.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              score: score,
              wordsFound: wordsFound,
              duration: widget.duration,
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    context.read<GameController>().removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (context, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  _StatusCard(controller: controller),
                  const SizedBox(height: AppSpacing.md),
                  _CurrentWordPill(word: controller.currentWord),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ToastBanner(controller: controller),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    flex: 5,
                    child: _BoardCard(controller: controller),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PowerUpsCard(controller: controller),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    flex: 2,
                    child: _FoundWordsCard(controller: controller),
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

/// Timer / pause / score, grouped into one elevated status card instead of
/// three elements floating loose on the background.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: context.palette.shadowSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TimerDisplay(secondsLeft: controller.timeLeft, frozen: controller.freezeLeft > 0),
          PressableScale(
            onTap: controller.togglePause,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.palette.surface2,
                shape: BoxShape.circle,
              ),
              child: AppIcon(
                controller.isPaused ? 'play' : 'pause',
                color: context.palette.textPrimary,
                size: 20,
              ),
            ),
          ),
          ScoreDisplay(score: controller.score),
        ],
      ),
    );
  }
}

/// The word currently being dragged out, as a pill above the board - only
/// takes visual weight once there's actually something to show.
class _CurrentWordPill extends StatelessWidget {
  const _CurrentWordPill({required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Center(
        child: AnimatedOpacity(
          opacity: word.isEmpty ? 0 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.palette.surface2,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(word.isEmpty ? ' ' : word, style: AppTextStyles.heading),
          ),
        ),
      ),
    );
  }
}

/// The letter grid framed in its own elevated card, giving it the visual
/// weight of being the screen's centerpiece rather than one element among
/// equals.
class _BoardCard extends StatelessWidget {
  const _BoardCard({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.palette.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: context.palette.shadowMd,
      ),
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
                color: context.palette.bgDeep.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Center(
                child: Text('מושהה', style: AppTextStyles.heading),
              ),
            ),
        ],
      ),
    );
  }
}

class _PowerUpsCard extends StatelessWidget {
  const _PowerUpsCard({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.palette.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: context.palette.shadowSm,
      ),
      child: PowerUpBar(
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
            itemKey: 'freeze',
            onUse: () {
              controller.useFreeze();
              return true;
            },
          ),
        ],
      ),
    );
  }
}

class _FoundWordsCard extends StatelessWidget {
  const _FoundWordsCard({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.palette.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: context.palette.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'מילים שנמצאו (${controller.foundWords.length})',
            style: context.palette.secondaryText,
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: SingleChildScrollView(
              child: FoundWordsPanel(
                foundWords: controller.foundWords.toList(),
                pointsFor: controller.pointsFor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
