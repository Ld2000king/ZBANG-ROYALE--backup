/// Route name constants for the argument-less screens. Screens that carry
/// typed data (chosen duration, final score) navigate via direct
/// Navigator.push(MaterialPageRoute) instead, to avoid untyped argument
/// casting - see single_duration_screen.dart and game_screen.dart.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String modeSelect = '/mode-select';
}
