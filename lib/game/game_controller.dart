import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../data/dictionary/dictionary_repository.dart';
import 'board_generator.dart';
import 'board_word_finder.dart';
import 'word_validator.dart';

enum GameMessageType { error, warning, info, success }

class GameMessage {
  const GameMessage(this.text, this.type);

  final String text;
  final GameMessageType type;
}

/// Owns one single-player session: board, timer, drag selection, scoring and
/// found-words, and the auto-reshuffle-on-exhaustion rule. Ported from the
/// single-player slice of game.js's currentGame state + startSinglePlayer/
/// endDrag/startTimer/autoShuffleIfExhausted.
class GameController extends ChangeNotifier {
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

  List<String> board = const [];
  final int gridSize = kGridSize;

  final Set<String> foundWords = <String>{};
  int score = 0;

  int timeLeft = 0;
  int _totalDuration = 0;
  bool gameActive = false;
  bool isPaused = false;

  List<int> dragPath = [];

  GameMessage? message;
  int messageNonce = 0;

  Timer? _timer;

  String get currentWord => dragPath.map((i) => board[i]).join();

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
    dragPath = [];
    message = null;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isPaused) return;
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

  void pointerDownAt(int index) {
    if (!gameActive || isPaused) return;
    dragPath = [index];
    notifyListeners();
  }

  void pointerMoveTo(int index) {
    if (!gameActive || isPaused || dragPath.isEmpty) return;
    if (!dragPath.contains(index)) {
      dragPath = [...dragPath, index];
      notifyListeners();
    }
  }

  void cancelDrag() {
    if (dragPath.isEmpty) return;
    dragPath = [];
    notifyListeners();
  }

  void endDrag() {
    if (dragPath.isEmpty) return;

    final outcome = _wordValidator.evaluate(currentWord, foundWords);

    switch (outcome.type) {
      case WordOutcomeType.tooShort:
        _setMessage('קצר מדי!', GameMessageType.error);
      case WordOutcomeType.unknown:
        _setMessage('נשלח לבדיקה — תודה!', GameMessageType.success);
      case WordOutcomeType.alreadyFound:
        _setMessage('כבר מצאת!', GameMessageType.warning);
      case WordOutcomeType.scored:
        foundWords.add(outcome.word);
        score += outcome.points;
        _autoShuffleIfExhausted();
    }

    dragPath = [];
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
      _setMessage('נגמרו המילים — הלוח עורבב!', GameMessageType.info);
    }
  }

  void _setMessage(String text, GameMessageType type) {
    message = GameMessage(text, type);
    messageNonce++;
  }

  double get progress => _totalDuration == 0 ? 0 : timeLeft / _totalDuration;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
