/// Board dimensions and single-player timer options, ported from
/// currentGame.gridSize (5) and SINGLE_DURATIONS in the original game.js.
const int kGridSize = 5;

enum SingleDuration { quick, precise }

const Map<SingleDuration, int> kSingleDurationSeconds = {
  SingleDuration.quick: 60,
  SingleDuration.precise: 120,
};

/// Weighted random letter distribution used to fill the board, ported
/// verbatim from generateBoard()'s `weights` table.
const Map<String, int> kLetterWeights = {
  'א': 8,
  'ב': 3,
  'ג': 2,
  'ד': 3,
  'ה': 8,
  'ו': 4,
  'ז': 1,
  'ח': 2,
  'י': 8,
  'ל': 6,
  'מ': 5,
  'נ': 5,
  'ס': 1,
  'ע': 1,
  'פ': 1,
  'ק': 1,
  'ר': 8,
  'ש': 6,
  'ת': 4,
};

const int kWordsPlantedPerBoard = 5;
const int kPlantAttemptsPerWord = 20;

/// Fraction of a tile's half-size the pointer must stay within for a drag
/// to register that tile - ported from detectTileAt's `radius = ... * 0.42`.
const double kTileHitRadiusFactor = 0.42;

/// Battle Royale vs. bots, ported from battleState/BOT_NAMES/BOT_DIFFICULTY
/// in game.js.
const List<String> kBotNames = ['דני', 'מיכל', 'אורי', 'נועה', 'יוסי'];
const int kBattleTotalRounds = 5;
const int kBattleRoundSeconds = 60;
const int kBotEliminationCoins = 25;
const int kBattleVictoryCoins = 100;
const int kBattleVictoryDiamonds = 5;

enum BotDifficulty { easy, medium, hard }

class BotDifficultyTier {
  const BotDifficultyTier({
    required this.displayName,
    required this.minDelayMs,
    required this.maxDelayMs,
  });

  final String displayName;
  final int minDelayMs;
  final int maxDelayMs;
}

const Map<BotDifficulty, BotDifficultyTier> kBotDifficultyTiers = {
  BotDifficulty.easy: BotDifficultyTier(
    displayName: 'זבאנג התחלתי',
    minDelayMs: 7000,
    maxDelayMs: 13000,
  ),
  BotDifficulty.medium: BotDifficultyTier(
    displayName: 'זבאנג קלאסי',
    minDelayMs: 4000,
    maxDelayMs: 7500,
  ),
  BotDifficulty.hard: BotDifficultyTier(
    displayName: 'זבאנג מלכותי',
    minDelayMs: 2200,
    maxDelayMs: 4500,
  ),
};
