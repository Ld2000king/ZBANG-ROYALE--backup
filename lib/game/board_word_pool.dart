import '../data/dictionary/dictionary_repository.dart';

class BoardWordEntry {
  const BoardWordEntry(this.word, this.points);

  final String word;
  final int points;
}

/// Ported from collectBoardWords() in game.js: every dictionary word
/// currently placed on the board, with its point value. This is the pool
/// bots draw from when they "find" a word in Battle Royale, so a bot's
/// score reflects real board words (right length/value distribution)
/// instead of arbitrary increments.
class BoardWordPool {
  BoardWordPool(this._dictionary);

  final DictionaryRepository _dictionary;

  List<BoardWordEntry> collect({required List<String> board, required int size}) {
    final boardLetters = board.toSet();
    final seen = <String>{};
    final words = <BoardWordEntry>[];

    for (final word in _dictionary.allWords) {
      if (word.length < 3 || word.length > size || seen.contains(word)) continue;
      if (word.split('').any((c) => !boardLetters.contains(c))) continue;

      var onBoard = false;
      for (var r = 0; r < size && !onBoard; r++) {
        for (var c = 0; c <= size - word.length && !onBoard; c++) {
          var ok = true;
          for (var i = 0; i < word.length; i++) {
            if (board[r * size + c + i] != word[i]) {
              ok = false;
              break;
            }
          }
          if (ok) onBoard = true;
        }
      }
      for (var c = 0; c < size && !onBoard; c++) {
        for (var r = 0; r <= size - word.length && !onBoard; r++) {
          var ok = true;
          for (var i = 0; i < word.length; i++) {
            if (board[(r + i) * size + c] != word[i]) {
              ok = false;
              break;
            }
          }
          if (ok) onBoard = true;
        }
      }

      if (onBoard) {
        seen.add(word);
        words.add(BoardWordEntry(word, _dictionary.pointsFor(word)!));
      }
    }

    return words;
  }
}
