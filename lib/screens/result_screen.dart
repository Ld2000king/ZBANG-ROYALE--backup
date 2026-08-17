import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/dictionary/dictionary_repository.dart';
import '../game/game_controller.dart';
import '../game/player_profile_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/app_button.dart';
import 'game_screen.dart';
import 'home_shell.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.wordsFound,
    required this.duration,
  });

  final int score;
  final int wordsFound;
  final SingleDuration duration;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isNewBest = false;
  int _coinsEarned = 0;

  @override
  void initState() {
    super.initState();
    final profile = context.read<PlayerProfileController>();
    _coinsEarned = widget.score ~/ 10;
    _isNewBest = profile.submitSingleScore(widget.score);
    profile.addCoins(_coinsEarned);
  }

  void _playAgain(BuildContext context) {
    final dictionary = context.read<DictionaryRepository>();
    final controller = GameController(dictionary: dictionary)..startGame(widget.duration);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => controller,
          child: GameScreen(duration: widget.duration),
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('הסיבוב הסתיים!', style: AppTextStyles.title.copyWith(fontSize: 28)),
              const SizedBox(height: 24),
              Text('${widget.score}', style: AppTextStyles.title),
              Text('ניקוד', style: AppTextStyles.bodySecondary),
              if (_isNewBest) ...[
                const SizedBox(height: 8),
                Text('שיא חדש!', style: AppTextStyles.bodyEmphasis.copyWith(color: AppColors.gold)),
              ],
              const SizedBox(height: 24),
              Text('${widget.wordsFound} מילים נמצאו · $_coinsEarned מטבעות', style: AppTextStyles.body),
              const SizedBox(height: 48),
              AppButton(
                label: 'שחק שוב',
                color: AppButtonColor.green,
                onPressed: () => _playAgain(context),
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
