import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../data/dictionary/dictionary_repository.dart';
import '../game/battle_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/buttons/app_button.dart';
import 'battle_screen.dart';
import '../theme/app_palette.dart';

class BattleDifficultyScreen extends StatelessWidget {
  const BattleDifficultyScreen({super.key});

  void _start(BuildContext context, BotDifficulty difficulty) {
    final dictionary = context.read<DictionaryRepository>();
    final controller = BattleController(dictionary: dictionary)..startBattle(difficulty);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => controller,
          child: const BattleScreen(),
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
        title: Text('בחר רמת קושי', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AppButton(
                label: kBotDifficultyTiers[BotDifficulty.easy]!.displayName,
                color: AppButtonColor.blue,
                onPressed: () => _start(context, BotDifficulty.easy),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: kBotDifficultyTiers[BotDifficulty.medium]!.displayName,
                color: AppButtonColor.purple,
                onPressed: () => _start(context, BotDifficulty.medium),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: kBotDifficultyTiers[BotDifficulty.hard]!.displayName,
                color: AppButtonColor.red,
                onPressed: () => _start(context, BotDifficulty.hard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
