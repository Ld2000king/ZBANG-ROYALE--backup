import '../core/constants.dart';

/// A bot opponent in Battle Royale. Ported from the plain objects
/// battleState.players held in game.js (name/score/eliminated), plus a
/// per-bot "thinking timer" (nextFindInMs) used by BattleController's bot AI.
class Bot {
  Bot(this.name);

  final String name;
  int score = 0;
  bool eliminated = false;
  double nextFindInMs = 0;
}

/// One row of the round-end standings list.
class BattleStanding {
  const BattleStanding({
    required this.name,
    required this.score,
    required this.isPlayer,
    this.eliminated = false,
  });

  final String name;
  final int score;
  final bool isPlayer;
  final bool eliminated;

  BattleStanding copyWith({bool? eliminated}) => BattleStanding(
        name: name,
        score: score,
        isPlayer: isPlayer,
        eliminated: eliminated ?? this.eliminated,
      );
}

enum BattleOutcomeType { roundEnd, victory, defeat }

/// What happened at the end of a round - ported from the three branches of
/// endBattleRound() in game.js (player eliminated / bot eliminated+more
/// rounds left / bot eliminated+final round won).
class BattleRoundResult {
  const BattleRoundResult._({
    required this.type,
    this.standings,
    this.eliminatedName,
    this.round,
    this.totalCoins,
    this.diamonds,
  });

  factory BattleRoundResult.roundEnd({
    required List<BattleStanding> standings,
    required String eliminatedName,
  }) =>
      BattleRoundResult._(
        type: BattleOutcomeType.roundEnd,
        standings: standings,
        eliminatedName: eliminatedName,
      );

  factory BattleRoundResult.victory({required int totalCoins, required int diamonds}) =>
      BattleRoundResult._(
        type: BattleOutcomeType.victory,
        totalCoins: totalCoins,
        diamonds: diamonds,
      );

  factory BattleRoundResult.defeat({required int round, required int totalCoins}) =>
      BattleRoundResult._(
        type: BattleOutcomeType.defeat,
        round: round,
        totalCoins: totalCoins,
      );

  final BattleOutcomeType type;
  final List<BattleStanding>? standings;
  final String? eliminatedName;
  final int? round;
  final int? totalCoins;
  final int? diamonds;
}

/// Ported from botFindDelay() in game.js: randomized "thinking time" until a
/// bot's next find, within its tier's min..max range.
double botFindDelay(BotDifficultyTier tier, double Function() nextDouble) {
  return tier.minDelayMs + nextDouble() * (tier.maxDelayMs - tier.minDelayMs);
}

/// Who the round's elimination picks out, and the standings to show for it.
class RoundOutcome {
  const RoundOutcome({
    required this.standings,
    required this.eliminatedName,
    required this.eliminatedIsPlayer,
  });

  final List<BattleStanding> standings;
  final String eliminatedName;
  final bool eliminatedIsPlayer;
}

/// Pure port of the standings/elimination decision inside endBattleRound()
/// in game.js: the player plus every still-active bot compete on this
/// round's score alone, lowest is out. No side effects and no timers, so
/// this is directly unit-testable; BattleController applies the resulting
/// mutation (bot.eliminated, coin/diamond totals).
RoundOutcome computeRoundOutcome({required int playerScore, required List<Bot> activeBots}) {
  final standings = <BattleStanding>[
    BattleStanding(name: 'אתה', score: playerScore, isPlayer: true),
    for (final bot in activeBots) BattleStanding(name: bot.name, score: bot.score, isPlayer: false),
  ]..sort((a, b) => a.score.compareTo(b.score));

  final loser = standings.first;
  final marked = [for (final s in standings) s.copyWith(eliminated: s.name == loser.name)];

  return RoundOutcome(
    standings: marked,
    eliminatedName: loser.name,
    eliminatedIsPlayer: loser.isPlayer,
  );
}
