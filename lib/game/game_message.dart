enum GameMessageType { error, warning, info, success }

/// A transient word-outcome / board-status message, mirroring
/// showBoardMessage() in game.js (e.g. "קצר מדי!", "כבר מצאת!").
class GameMessage {
  const GameMessage(this.text, this.type);

  final String text;
  final GameMessageType type;
}
