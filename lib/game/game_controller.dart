import 'dart:async';

import '../core/constants.dart';
import '../data/dictionary/dictionary_repository.dart';
import 'board_generator.dart';
import 'board_word_finder.dart';
import 'draggable_board_controller.dart';
import 'game_message.dart';
import 'word_validator.dart';

export 'game_message.dart';

/// Owns one single-player session: board, timer, drag selection, scoring and
/// found-words, and the auto-reshuffle-on-exhaustion rule. Ported from the
/// single-player slice of game.js's currentGame state + startSinglePlayer/
/// endDrag/startTimer/autoShuffleIfExhausted.
class GameController extends DraggableBoardController {
  GameController({
    required DictionaryRepository dictionary,
    BoardGenerator? boardGenerator,
  })  : _dictionary = dictionary,
        _boardGenerator = boardGenerator ?? BoardGenerator(),
        _wordValidator = WordValidator(dictionary),
        _boardWordFinder = BoardWordFinder(dictionary);

  final DictionaryRepository _dictionary;
  final BoardGenerator _boardGenerator;
  final WordValidator _wordValidator;
  final BoardWordFinder _boardWordFinder;

  @override
  List<String> board = const [];
  @override
  final int gridSize = kGridSize;
  @override
  List<int> dragPath = [];

  final Set<String> foundWords = <String>{};
  int score = 0;

  int timeLeft = 0;
  int _totalDuration = 0;
  bool gameActive = false;
  bool isPaused = false;
  int freezeLeft = 0;

  Timer? _timer;

  int pointsFor(String word) => _dictionary.pointsFor(word) ?? 0;

  bool get isRoundOver => !gameActive && timeLeft <= 0;

  void startGame(SingleDuration duration) {
    _timer?.cancel();

    final seconds = kSingleDurationSeconds[duration]!;
    board = _boardGenerator.generate(dictionaryWords: _dictionary.allWords);
    foundWords.clear();
    score = 0;
    timeLeft = seconds;
    _totalDuration = seconds;
    gameActive = true;
    isPaused = false;
    freezeLeft = 0;
    dragPath = [];
    message = null;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isPaused) return;
      if (freezeLeft > 0) {
        freezeLeft--;
        notifyListeners();
        return;
      }
      timeLeft--;
      if (timeLeft <= 0) {
        timeLeft = 0;
        gameActive = false;
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  void togglePause() {
    if (!gameActive) return;
    isPaused = !isPaused;
    notifyListeners();
  }

  @override
  void pointerDownAt(int index) {
    if (!gameActive || isPaused) return;
    dragPath = [index];
    notifyListeners();
  }

  @override
  void pointerMoveTo(int index) {
    if (!gameActive || isPaused || dragPath.isEmpty) return;
    if (!dragPath.contains(index)) {
      dragPath = [...dragPath, index];
      notifyListeners();
    }
  }

  @override
  void cancelDrag() {
    if (dragPath.isEmpty) return;
    dragPath = [];
    notifyListeners();
  }

  @override
  void endDrag() {
    if (dragPath.isEmpty) return;

    final outcome = _wordValidator.evaluate(currentWord, foundWords);

    switch (outcome.type) {
      case WordOutcomeType.tooShort:
        setMessage('קצר מדי!', GameMessageType.error);
      case WordOutcomeType.unknown:
        setMessage('נשלח לבדיקה — תודה!', GameMessageType.success);
      case WordOutcomeType.alreadyFound:
        setMessage('כבר מצאת!', GameMessageType.warning);
      case WordOutcomeType.scored:
        foundWords.add(outcome.word);
        score += outcome.points;
        _autoShuffleIfExhausted();
    }

    dragPath = [];
    notifyListeners();
  }

  /// Ported from useHint(): finds a still-unfound board word (reshuffling
  /// first if the board is exhausted) and scores it as if the player had
  /// dragged it. Returns false (no charge should be applied by the caller)
  /// if no word could be found even after a reshuffle.
  bool useHint() {
    if (!gameActive || isPaused) return false;

    var indices = _boardWordFinder.findWord(board: board, size: gridSize, foundWords: foundWords);
    if (indices.isEmpty) {
      _autoShuffleIfExhausted();
      indices = _boardWordFinder.findWord(board: board, size: gridSize, foundWords: foundWords);
      if (indices.isEmpty) return false;
    }

    final word = indices.map((i) => board[i]).join();
    final points = pointsFor(word);
    foundWords.add(word);
    score += points;
    setMessage('$word - כל הכבוד! +$points', GameMessageType.success);
    notifyListeners();
    return true;
  }

  /// Ported from useShuffle().
  void useShuffle() {
    if (!gameActive || isPaused) return;
    board = List<String>.from(board)..shuffle();
    setMessage('הלוח עורבב!', GameMessageType.success);
    notifyListeners();
  }

  /// Ported from useFreeze(): the clock stops advancing for 5 more seconds
  /// (stacks if used again while already frozen).
  void useFreeze() {
    if (!gameActive) return;
    freezeLeft += 5;
    setMessage('הזמן הוקפא ל-5 שניות!', GameMessageType.info);
    notifyListeners();
  }

  void _autoShuffleIfExhausted() {
    final remaining = _boardWordFinder.findWord(
      board: board,
      size: gridSize,
      foundWords: foundWords,
    );
    if (remaining.isEmpty) {
      board = List<String>.from(board)..shuffle();
      setMessage('נגמרו המילים — הלוח עורבב!', GameMessageType.info);
    }
  }

  double get progress => _totalDuration == 0 ? 0 : timeLeft / _totalDuration;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
