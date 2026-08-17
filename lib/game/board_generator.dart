import 'dart:math';

import '../core/constants.dart';

/// Ported from generateBoard() in game.js: plants a handful of dictionary
/// words horizontally/vertically into a size x size grid, then fills every
/// remaining cell with a weighted-random letter.
class BoardGenerator {
  BoardGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  List<String> generate({
    required Iterable<String> dictionaryWords,
    int size = kGridSize,
  }) {
    final board = List<String>.filled(size * size, '');

    final words = dictionaryWords.toList()..shuffle(_random);
    final wordsToPlant = words.take(kWordsPlantedPerBoard);

    for (final word in wordsToPlant) {
      _plantWord(board, word, size);
    }

    final letters = kLetterWeights.keys.toList();
    final totalWeight = kLetterWeights.values.fold<int>(0, (a, b) => a + b);
    for (var i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        board[i] = _weightedRandomLetter(letters, totalWeight);
      }
    }

    return board;
  }

  void _plantWord(List<String> board, String word, int size) {
    for (var attempt = 0; attempt < kPlantAttemptsPerWord; attempt++) {
      final horizontal = _random.nextDouble() > 0.5;
      final row = _random.nextInt(size);
      final col = _random.nextInt(size);

      if (horizontal && col + word.length <= size) {
        if (_tryPlace(board, word, (i) => row * size + col + i)) return;
      } else if (!horizontal && row + word.length <= size) {
        if (_tryPlace(board, word, (i) => (row + i) * size + col)) return;
      }
    }
  }

  bool _tryPlace(List<String> board, String word, int Function(int i) indexAt) {
    for (var i = 0; i < word.length; i++) {
      final idx = indexAt(i);
      final existing = board[idx];
      if (existing.isNotEmpty && existing != word[i]) return false;
    }
    for (var i = 0; i < word.length; i++) {
      board[indexAt(i)] = word[i];
    }
    return true;
  }

  String _weightedRandomLetter(List<String> letters, int totalWeight) {
    final rand = _random.nextDouble() * totalWeight;
    var sum = 0;
    for (final letter in letters) {
      sum += kLetterWeights[letter]!;
      if (rand < sum) return letter;
    }
    return letters.last;
  }
}
