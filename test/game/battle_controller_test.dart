import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/core/constants.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/game/battle_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DictionaryRepository dictionary;

  setUpAll(() async {
    dictionary = await DictionaryRepository.load();
  });

  test('a full battle runs to completion within 5 rounds, eliminating exactly one per round', () {
    fakeAsync((async) {
      final controller = BattleController(dictionary: dictionary, random: Random(1));
      controller.startBattle(BotDifficulty.hard); // fastest bots -> fewest ticks needed

      var roundsPlayed = 0;
      var activeBefore = controller.bots.length;

      while (true) {
        // Run the round out (60s of round timer + bot AI ticks).
        async.elapse(const Duration(seconds: 61));

        final result = controller.lastResult;
        expect(result, isNotNull, reason: 'round should have resolved after 61s');
        roundsPlayed++;
        expect(roundsPlayed, lessThanOrEqualTo(kBattleTotalRounds));

        if (result!.type == BattleOutcomeType.victory) {
          expect(controller.bots.every((b) => b.eliminated), isTrue);
          break;
        }
        if (result.type == BattleOutcomeType.defeat) {
          expect(result.round, roundsPlayed);
          break;
        }

        // roundEnd: exactly one previously-active bot got eliminated this round.
        final activeAfter = controller.bots.where((b) => !b.eliminated).length;
        expect(activeAfter, activeBefore - 1);
        activeBefore = activeAfter;

        controller.nextRound();
      }

      controller.dispose();
    });
  });

  test('difficulty affects how many bot ticks land before a round ends', () {
    // Not a scoring assertion (bot scoring is randomized) - just proves the
    // tier constants actually differ, which is what makes difficulty matter.
    final easy = kBotDifficultyTiers[BotDifficulty.easy]!;
    final hard = kBotDifficultyTiers[BotDifficulty.hard]!;
    expect(hard.maxDelayMs, lessThan(easy.minDelayMs));
  });
}
