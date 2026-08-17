import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/core/constants.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/game/board_generator.dart';
import 'package:zbang_royale/game/board_word_finder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DictionaryRepository dictionary;

  setUpAll(() async {
    dictionary = await DictionaryRepository.load();
  });

  test('produces a fully-filled size x size board', () {
    final generator = BoardGenerator(random: Random(42));
    final board = generator.generate(dictionaryWords: dictionary.allWords);

    expect(board.length, kGridSize * kGridSize);
    for (final cell in board) {
      expect(cell.length, 1, reason: 'every cell should hold exactly one letter');
    }
  });

  test('a freshly generated board always has at least one findable word', () {
    final finder = BoardWordFinder(dictionary);

    for (final seed in [1, 2, 3, 4, 5]) {
      final board = BoardGenerator(random: Random(seed)).generate(
        dictionaryWords: dictionary.allWords,
      );
      final found = finder.findWord(board: board, size: kGridSize, foundWords: {});
      expect(
        found,
        isNotEmpty,
        reason: 'seed $seed produced a board with no findable word',
      );
    }
  });
}
