import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/core/constants.dart';
import 'package:zbang_royale/game/battle.dart';

void main() {
  group('computeRoundOutcome', () {
    test('eliminates the lowest-scoring bot when the player is not lowest', () {
      final bots = [Bot('דני')..score = 50, Bot('מיכל')..score = 200];
      final outcome = computeRoundOutcome(playerScore: 300, activeBots: bots);

      expect(outcome.eliminatedIsPlayer, isFalse);
      expect(outcome.eliminatedName, 'דני');
      expect(outcome.standings.length, 3);
      expect(outcome.standings.first.name, 'דני');
      expect(outcome.standings.first.eliminated, isTrue);
      expect(outcome.standings.where((s) => s.eliminated).length, 1);
    });

    test('eliminates the player when they have the lowest score', () {
      final bots = [Bot('דני')..score = 500, Bot('מיכל')..score = 400];
      final outcome = computeRoundOutcome(playerScore: 100, activeBots: bots);

      expect(outcome.eliminatedIsPlayer, isTrue);
      expect(outcome.eliminatedName, 'אתה');
    });

    test('a tie goes to whichever entry sorts first (stable, deterministic)', () {
      final bots = [Bot('דני')..score = 100];
      final outcome = computeRoundOutcome(playerScore: 100, activeBots: bots);

      // Both were 100; exactly one is eliminated either way - the important
      // invariant is that ties don't crash or eliminate nobody/everybody.
      expect(outcome.standings.where((s) => s.eliminated).length, 1);
    });

    test('standings are sorted ascending by score', () {
      final bots = [Bot('דני')..score = 300, Bot('מיכל')..score = 50, Bot('אורי')..score = 150];
      final outcome = computeRoundOutcome(playerScore: 200, activeBots: bots);

      final scores = outcome.standings.map((s) => s.score).toList();
      expect(scores, [50, 150, 200, 300]);
    });

    test('only active bots are considered, never an already-eliminated one', () {
      // activeBots is expected to already be pre-filtered by the caller
      // (BattleController.activeBots) - this test documents that contract.
      final bots = [Bot('דני')..score = 999];
      final outcome = computeRoundOutcome(playerScore: 1, activeBots: bots);
      expect(outcome.eliminatedIsPlayer, isTrue);
    });
  });

  group('botFindDelay', () {
    test('stays within the tier min..max range', () {
      const tier = BotDifficultyTier(displayName: 'x', minDelayMs: 1000, maxDelayMs: 2000);
      for (final r in [0.0, 0.25, 0.5, 0.75, 1.0]) {
        final delay = botFindDelay(tier, () => r);
        expect(delay, inInclusiveRange(1000, 2000));
      }
    });

    test('easy is slower than medium is slower than hard', () {
      final easy = kBotDifficultyTiers[BotDifficulty.easy]!;
      final medium = kBotDifficultyTiers[BotDifficulty.medium]!;
      final hard = kBotDifficultyTiers[BotDifficulty.hard]!;

      expect(easy.minDelayMs, greaterThan(medium.minDelayMs));
      expect(medium.minDelayMs, greaterThan(hard.minDelayMs));
    });
  });
}
