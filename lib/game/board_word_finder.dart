import '../data/dictionary/dictionary_repository.dart';

/// Ported from findWordOnBoard() in game.js: scans the dictionary for a word
/// that (a) isn't already found, (b) fits the grid, (c) only uses letters
/// present on the board (a fast, repeat-ignoring prefilter), and (d) can
/// actually be placed horizontally or vertically at some position. Backs
/// both the "board exhausted -> reshuffle" check and the future hint power-up.
class BoardWordFinder {
  BoardWordFinder(this._dictionary);

  final DictionaryRepository _dictionary;

  /// Returns the board indices spelling a still-findable word, or an empty
  /// list if none remain.
  List<int> findWord({
    required List<String> board,
    required int size,
    required Set<String> foundWords,
  }) {
    final boardLetters = board.toSet();

    for (final word in _dictionary.allWords) {
      if (foundWords.contains(word)) continue;
      if (word.length > size || word.length < 3) continue;
      if (!_usesOnlyLetters(word, boardLetters)) continue;

      for (var r = 0; r < size; r++) {
        for (var c = 0; c <= size - word.length; c++) {
          final idxs = <int>[];
          var ok = true;
          for (var i = 0; i < word.length; i++) {
            final idx = r * size + c + i;
            if (board[idx] != word[i]) {
              ok = false;
              break;
            }
            idxs.add(idx);
          }
          if (ok) return idxs;
        }
      }

      for (var c = 0; c < size; c++) {
        for (var r = 0; r <= size - word.length; r++) {
          final idxs = <int>[];
          var ok = true;
          for (var i = 0; i < word.length; i++) {
            final idx = (r + i) * size + c;
            if (board[idx] != word[i]) {
              ok = false;
              break;
            }
            idxs.add(idx);
          }
          if (ok) return idxs;
        }
      }
    }

    return const [];
  }

  bool _usesOnlyLetters(String word, Set<String> letters) {
    for (var i = 0; i < word.length; i++) {
      if (!letters.contains(word[i])) return false;
    }
    return true;
  }
}
