import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/core/constants.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/game/board_generator.dart';
import 'package:zbang_royale/game/board_word_pool.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DictionaryRepository dictionary;

  setUpAll(() async {
    dictionary = await DictionaryRepository.load();
  });

  test('collects a non-empty pool of real, correctly-scored board words', () {
    final board = BoardGenerator(random: Random(3)).generate(dictionaryWords: dictionary.allWords);
    final pool = BoardWordPool(dictionary).collect(board: board, size: kGridSize);

    expect(pool, isNotEmpty);
    for (final entry in pool) {
      expect(dictionary.contains(entry.word), isTrue);
      expect(entry.points, dictionary.pointsFor(entry.word));
      expect(entry.word.length, inInclusiveRange(3, kGridSize));
    }
  });

  test('every pooled word is actually placeable on the board (no false positives)', () {
    final board = BoardGenerator(random: Random(11)).generate(dictionaryWords: dictionary.allWords);
    final pool = BoardWordPool(dictionary).collect(board: board, size: kGridSize);

    bool placeable(String word) {
      for (var r = 0; r < kGridSize; r++) {
        for (var c = 0; c <= kGridSize - word.length; c++) {
          if (List.generate(word.length, (i) => board[r * kGridSize + c + i]).join() == word) return true;
        }
      }
      for (var c = 0; c < kGridSize; c++) {
        for (var r = 0; r <= kGridSize - word.length; r++) {
          if (List.generate(word.length, (i) => board[(r + i) * kGridSize + c]).join() == word) return true;
        }
      }
      return false;
    }

    for (final entry in pool) {
      expect(placeable(entry.word), isTrue, reason: '"${entry.word}" was pooled but is not on the board');
    }
  });
}
