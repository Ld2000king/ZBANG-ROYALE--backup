import 'package:flutter/foundation.dart';

import 'game_message.dart';

/// Shared contract for any controller that drives a letter grid via the
/// document-level drag-select gesture (see widgets/letter_grid.dart) - both
/// single-player (GameController) and battle royale (BattleController)
/// implement this, so the grid widget and the toast feedback banner work
/// against either one without knowing which mode is active.
abstract class DraggableBoardController extends ChangeNotifier {
  List<String> get board;
  int get gridSize;
  List<int> get dragPath;

  void pointerDownAt(int index);
  void pointerMoveTo(int index);
  void endDrag();
  void cancelDrag();

  GameMessage? message;
  int messageNonce = 0;

  String get currentWord => dragPath.map((i) => board[i]).join();

  @protected
  void setMessage(String text, GameMessageType type) {
    message = GameMessage(text, type);
    messageNonce++;
  }
}
