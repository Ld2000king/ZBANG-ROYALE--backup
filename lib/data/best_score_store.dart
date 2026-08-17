import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence for the single-player best score - the Phase 1
/// equivalent of the original's localStorage-backed personal best.
class BestScoreStore {
  static const _key = 'zbang_best_score';

  Future<int> getBest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  /// Returns true if [score] became the new best.
  Future<bool> submit(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key) ?? 0;
    if (score > current) {
      await prefs.setInt(_key, score);
      return true;
    }
    return false;
  }
}
