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
