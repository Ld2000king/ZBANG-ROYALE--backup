import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/dictionary/dictionary_repository.dart';
import '../game/game_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/app_button.dart';
import 'game_screen.dart';
import '../theme/app_palette.dart';

class SingleDurationScreen extends StatelessWidget {
  const SingleDurationScreen({super.key});

  void _start(BuildContext context, SingleDuration duration) {
    final dictionary = context.read<DictionaryRepository>();
    final controller = GameController(dictionary: dictionary)..startGame(duration);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => controller,
          child: GameScreen(duration: duration),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('בחר משך זמן', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppButton(
                label: 'מהיר — 60 שניות',
                color: AppButtonColor.blue,
                onPressed: () => _start(context, SingleDuration.quick),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'מדויק — 120 שניות',
                color: AppButtonColor.purple,
                onPressed: () => _start(context, SingleDuration.precise),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
