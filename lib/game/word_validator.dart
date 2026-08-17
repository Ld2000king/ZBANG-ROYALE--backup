import '../core/hebrew_utils.dart';
import '../data/dictionary/dictionary_repository.dart';

enum WordOutcomeType { tooShort, unknown, alreadyFound, scored }

class WordOutcome {
  const WordOutcome(this.type, this.word, {this.points = 0});

  final WordOutcomeType type;
  final String word;
  final int points;
}

/// Ported from the scoring branch of endDrag() in game.js: normalizes the
/// dragged letters, then classifies the result exactly like the original
/// (too short / unknown / already found / scored).
class WordValidator {
  WordValidator(this._dictionary);

  final DictionaryRepository _dictionary;

  WordOutcome evaluate(String rawWord, Set<String> foundWords) {
    final word = normalizeFinals(rawWord);

    if (word.length < 3) {
      return WordOutcome(WordOutcomeType.tooShort, word);
    }

    final points = _dictionary.pointsFor(word);
    if (points == null) {
      return WordOutcome(WordOutcomeType.unknown, word);
    }

    if (foundWords.contains(word)) {
      return WordOutcome(WordOutcomeType.alreadyFound, word);
    }

    return WordOutcome(WordOutcomeType.scored, word, points: points);
  }
}
