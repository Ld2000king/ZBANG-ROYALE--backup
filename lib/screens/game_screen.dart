import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../game/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../widgets/feedback/toast_banner.dart';
import '../widgets/hud/found_words_panel.dart';
import '../widgets/hud/score_display.dart';
import '../widgets/hud/timer_display.dart';
import '../widgets/letter_grid.dart';
import 'result_screen.dart';

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
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (context, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TimerDisplay(secondsLeft: controller.timeLeft),
                      IconButton(
                        onPressed: controller.togglePause,
                        icon: Icon(
                          controller.isPaused ? Icons.play_arrow : Icons.pause,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      ScoreDisplay(score: controller.score),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 28,
                    child: Center(
                      child: Text(
                        controller.currentWord,
                        style: AppTextStyles.heading,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ToastBanner(controller: controller),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 5,
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
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 2,
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
          },
        ),
      ),
    );
  }
}
