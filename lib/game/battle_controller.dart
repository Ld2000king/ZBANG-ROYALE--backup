import 'dart:async';
import 'dart:math';

import '../core/constants.dart';
import '../data/dictionary/dictionary_repository.dart';
import 'battle.dart';
import 'board_generator.dart';
import 'board_word_finder.dart';
import 'board_word_pool.dart';
import 'draggable_board_controller.dart';
import 'game_message.dart';
import 'word_validator.dart';

export 'battle.dart';
export 'game_message.dart';

/// Owns one Battle Royale session vs. bots: shared board, timer, drag
/// selection/scoring (reusing the same word-validation/auto-reshuffle rules
/// as single-player), and the 5-round elimination + bot "thinking timer" AI.
/// Ported from battleState + startBattleRoyale/startBattleRound/startBotAI/
/// endBattleRound in game.js. Fully local - no networking.
class BattleController extends DraggableBoardController {
  BattleController({
    required DictionaryRepository dictionary,
    BoardGenerator? boardGenerator,
    Random? random,
  })  : _dictionary = dictionary,
        _boardGenerator = boardGenerator ?? BoardGenerator(),
        _wordValidator = WordValidator(dictionary),
        _boardWordFinder = BoardWordFinder(dictionary),
        _boardWordPool = BoardWordPool(dictionary),
        _random = random ?? Random();

  final DictionaryRepository _dictionary;
  final BoardGenerator _boardGenerator;
  final WordValidator _wordValidator;
  final BoardWordFinder _boardWordFinder;
  final BoardWordPool _boardWordPool;
  final Random _random;

  @override
  List<String> board = const [];
  @override
  final int gridSize = kGridSize;
  @override
  List<int> dragPath = [];

  final Set<String> foundWords = <String>{};
  int playerScore = 0;

  int timeLeft = 0;
  bool gameActive = false;
  bool isPaused = false;
  int botsFrozenSeconds = 0;

  late BotDifficulty difficulty;
  List<Bot> bots = [];
  int currentRound = 1;
  int totalCoinsEarned = 0;

  BattleRoundResult? lastResult;

  List<BoardWordEntry> _wordPoolCache = [];
  Timer? _roundTimer;
  Timer? _botTimer;

  List<Bot> get activeBots => bots.where((b) => !b.eliminated).toList();

  void startBattle(BotDifficulty difficulty) {
    this.difficulty = difficulty;
    currentRound = 1;
    totalCoinsEarned = 0;
    lastResult = null;
    bots = kBotNames.map(Bot.new).toList();
    _startRound();
  }

  void nextRound() {
    currentRound++;
    lastResult = null;
    _startRound();
  }

  void _startRound() {
    _roundTimer?.cancel();
    _botTimer?.cancel();

    board = _boardGenerator.generate(dictionaryWords: _dictionary.allWords);
    foundWords.clear();
    playerScore = 0;
    timeLeft = kBattleRoundSeconds;
    gameActive = true;
    isPaused = false;
    botsFrozenSeconds = 0;
    dragPath = [];
    message = null;
    for (final bot in bots) {
      if (!bot.eliminated) bot.score = 0;
    }

    _wordPoolCache = _boardWordPool.collect(board: board, size: gridSize);

    _startBotAI();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _roundTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isPaused) return;
      timeLeft--;
      if (timeLeft <= 0) {
        timeLeft = 0;
        gameActive = false;
        _roundTimer?.cancel();
        _botTimer?.cancel();
        _endRound();
      }
      notifyListeners();
    });
  }

  void _startBotAI() {
    final tier = kBotDifficultyTiers[difficulty]!;
    for (final bot in bots) {
      if (!bot.eliminated) {
        bot.nextFindInMs = botFindDelay(tier, _random.nextDouble) * (0.4 + _random.nextDouble() * 0.6);
      }
    }

    _botTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!gameActive || isPaused) return;

      if (botsFrozenSeconds > 0) {
        botsFrozenSeconds--;
        notifyListeners();
        return;
      }

      var changed = false;
      for (final bot in bots) {
        if (bot.eliminated) continue;
        bot.nextFindInMs -= 1000;
        if (bot.nextFindInMs <= 0) {
          bot.score += _wordPoolCache.isNotEmpty
              ? _wordPoolCache[_random.nextInt(_wordPoolCache.length)].points
              : 100;
          bot.nextFindInMs = botFindDelay(tier, _random.nextDouble);
          changed = true;
        }
      }
      if (changed) notifyListeners();
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
        playerScore += outcome.points;
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
      _wordPoolCache = _boardWordPool.collect(board: board, size: gridSize);
      setMessage('נגמרו המילים — הלוח עורבב!', GameMessageType.info);
    }
  }

  /// Ported from useBattleHint().
  bool useHint() {
    if (!gameActive || isPaused) return false;

    var indices = _boardWordFinder.findWord(board: board, size: gridSize, foundWords: foundWords);
    if (indices.isEmpty) {
      _autoShuffleIfExhausted();
      indices = _boardWordFinder.findWord(board: board, size: gridSize, foundWords: foundWords);
      if (indices.isEmpty) return false;
    }

    final word = indices.map((i) => board[i]).join();
    final points = _dictionary.pointsFor(word)!;
    foundWords.add(word);
    playerScore += points;
    setMessage('$word - כל הכבוד! +$points', GameMessageType.success);
    notifyListeners();
    return true;
  }

  /// Ported from useShuffle() (bots-mode branch: only the player's own board).
  void useShuffle() {
    if (!gameActive || isPaused) return;
    board = List<String>.from(board)..shuffle();
    _wordPoolCache = _boardWordPool.collect(board: board, size: gridSize);
    setMessage('הלוח עורבב!', GameMessageType.success);
    notifyListeners();
  }

  /// Ported from useBattleFreeze(): every active bot stops searching for
  /// 8 more seconds (stacks if used again while already frozen).
  void useFreezeOpponents() {
    if (!gameActive) return;
    botsFrozenSeconds += 8;
    setMessage('היריבים הוקפאו ל-8 שניות!', GameMessageType.info);
    notifyListeners();
  }

  /// Ported from useBattleShuffle() ("tornado" power-up): halves every
  /// active bot's score-so-far this round.
  void useTornado() {
    if (!gameActive) return;
    for (final bot in activeBots) {
      bot.score = (bot.score * 0.5).floor();
    }
    setMessage('הבוטים מבולבלים!', GameMessageType.success);
    notifyListeners();
  }

  /// Ported from endBattleRound(): the player + every still-active bot
  /// compete for the round's elimination (an already-eliminated bot's
  /// frozen score never re-enters the running).
  void _endRound() {
    final outcome = computeRoundOutcome(playerScore: playerScore, activeBots: activeBots);

    if (outcome.eliminatedIsPlayer) {
      lastResult = BattleRoundResult.defeat(round: currentRound, totalCoins: totalCoinsEarned);
    } else {
      for (final bot in bots) {
        if (bot.name == outcome.eliminatedName) bot.eliminated = true;
      }
      totalCoinsEarned += kBotEliminationCoins;

      if (currentRound >= kBattleTotalRounds) {
        totalCoinsEarned += kBattleVictoryCoins;
        lastResult = BattleRoundResult.victory(
          totalCoins: totalCoinsEarned,
          diamonds: kBattleVictoryDiamonds,
        );
      } else {
        lastResult = BattleRoundResult.roundEnd(
          standings: outcome.standings,
          eliminatedName: outcome.eliminatedName,
        );
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _roundTimer?.cancel();
    _botTimer?.cancel();
    super.dispose();
  }
}
