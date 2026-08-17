// ignore_for_file: prefer_initializing_formals
// (named constructor params read clearer than private-field param names here)

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/avatars_data.dart';
import '../core/shop_data.dart';

/// Persistent player economy - coins, diamonds, the power-up inventory, and
/// the single-player best score. Ported from gameState in game.js, saved as
/// one JSON blob (mirroring localStorage's 'zabangState' key) instead of
/// scattering separate SharedPreferences keys.
class PlayerProfileController extends ChangeNotifier {
  PlayerProfileController._({
    required int coins,
    required int diamonds,
    required Map<String, int> inventory,
    required int bestSingleScore,
    required String avatarId,
    required Set<String> ownedAvatars,
  })  : _coins = coins,
        _diamonds = diamonds,
        _inventory = inventory,
        _bestSingleScore = bestSingleScore,
        _avatarId = avatarId,
        _ownedAvatars = ownedAvatars;

  static const _prefsKey = 'zbang_player_profile';
  static const int _defaultCoins = 100;
  static const int _defaultHints = 3;

  static Future<PlayerProfileController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);

    if (raw == null) {
      final inventory = {for (final item in kShopItems) item.key: 0};
      inventory['hint'] = _defaultHints;
      return PlayerProfileController._(
        coins: _defaultCoins,
        diamonds: 0,
        inventory: inventory,
        bestSingleScore: 0,
        avatarId: kDefaultAvatarId,
        ownedAvatars: {},
      );
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final savedInventory = decoded['inventory'] as Map<String, dynamic>? ?? const {};
    final inventory = {
      for (final item in kShopItems) item.key: (savedInventory[item.key] as int?) ?? 0,
    };
    final savedOwnedAvatars = (decoded['ownedAvatars'] as List<dynamic>?) ?? const [];

    return PlayerProfileController._(
      coins: decoded['coins'] as int? ?? _defaultCoins,
      diamonds: decoded['diamonds'] as int? ?? 0,
      inventory: inventory,
      bestSingleScore: decoded['bestSingleScore'] as int? ?? 0,
      avatarId: decoded['avatarId'] as String? ?? kDefaultAvatarId,
      ownedAvatars: savedOwnedAvatars.cast<String>().toSet(),
    );
  }

  int _coins;
  int _diamonds;
  final Map<String, int> _inventory;
  int _bestSingleScore;
  String _avatarId;
  final Set<String> _ownedAvatars;

  int get coins => _coins;
  int get diamonds => _diamonds;
  int get bestSingleScore => _bestSingleScore;
  String get avatarId => _avatarId;

  int inventoryCount(String key) => _inventory[key] ?? 0;

  /// Ported from isAvatarOwned(): every free avatar is always available;
  /// a premium one needs to have been bought first.
  bool isAvatarOwned(String id) {
    final avatar = avatarById(id);
    return !avatar.premium || _ownedAvatars.contains(id);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode({
        'coins': _coins,
        'diamonds': _diamonds,
        'inventory': _inventory,
        'bestSingleScore': _bestSingleScore,
        'avatarId': _avatarId,
        'ownedAvatars': _ownedAvatars.toList(),
      }),
    );
  }

  void addCoins(int amount) {
    if (amount == 0) return;
    _coins += amount;
    notifyListeners();
    _persist();
  }

  void addDiamonds(int amount) {
    if (amount == 0) return;
    _diamonds += amount;
    notifyListeners();
    _persist();
  }

  /// Ported from the single-player result flow's best-score check. Returns
  /// true if this score became the new best.
  bool submitSingleScore(int score) {
    if (score > _bestSingleScore) {
      _bestSingleScore = score;
      notifyListeners();
      _persist();
      return true;
    }
    return false;
  }

  bool canAfford(String key) {
    final item = kShopItems.firstWhere((i) => i.key == key);
    return inventoryCount(key) > 0 || _coins >= item.cost;
  }

  /// Ported from buyItem(): spend coins up front to add one to inventory.
  bool buyPowerUp(String key) {
    final item = kShopItems.firstWhere((i) => i.key == key);
    if (_coins < item.cost) return false;
    _coins -= item.cost;
    _inventory[key] = inventoryCount(key) + 1;
    notifyListeners();
    _persist();
    return true;
  }

  /// Ported from canPayForItem()/consumeItemPayment(): call right before
  /// applying a power-up's effect. Returns false (nothing charged) if the
  /// player can afford neither an inventory item nor the coin cost.
  /// Inventory is spent before coins.
  bool consumePowerUp(String key) {
    if (!canAfford(key)) return false;
    if (inventoryCount(key) > 0) {
      _inventory[key] = inventoryCount(key) - 1;
    } else {
      final item = kShopItems.firstWhere((i) => i.key == key);
      _coins -= item.cost;
    }
    notifyListeners();
    _persist();
    return true;
  }

  /// Ported from buyAvatar(): premium avatars are bought with diamonds.
  bool buyAvatar(String id) {
    if (isAvatarOwned(id)) return true;
    if (_diamonds < kAvatarDiamondCost) return false;
    _diamonds -= kAvatarDiamondCost;
    _ownedAvatars.add(id);
    notifyListeners();
    _persist();
    return true;
  }

  /// Ported from selectAvatar(): only an owned avatar can be equipped.
  bool selectAvatar(String id) {
    if (!isAvatarOwned(id)) return false;
    _avatarId = id;
    notifyListeners();
    _persist();
    return true;
  }
}
