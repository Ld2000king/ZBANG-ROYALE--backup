import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zbang_royale/core/avatars_data.dart';
import 'package:zbang_royale/game/player_profile_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('a fresh profile starts with 100 coins, 0 diamonds, 3 free hints', () async {
    final profile = await PlayerProfileController.load();
    expect(profile.coins, 100);
    expect(profile.diamonds, 0);
    expect(profile.inventoryCount('hint'), 3);
    expect(profile.inventoryCount('shuffle'), 0);
    expect(profile.bestSingleScore, 0);
  });

  test('buyPowerUp spends coins and adds one to inventory', () async {
    final profile = await PlayerProfileController.load();
    final bought = profile.buyPowerUp('shuffle'); // costs 20
    expect(bought, isTrue);
    expect(profile.coins, 80);
    expect(profile.inventoryCount('shuffle'), 1);
  });

  test('buyPowerUp fails without enough coins and charges nothing', () async {
    final profile = await PlayerProfileController.load();
    for (var i = 0; i < 5; i++) {
      profile.buyPowerUp('shuffle'); // 5 * 20 = 100, drains starting coins
    }
    expect(profile.coins, 0);
    final bought = profile.buyPowerUp('shuffle');
    expect(bought, isFalse);
    expect(profile.coins, 0);
    expect(profile.inventoryCount('shuffle'), 5);
  });

  test('consumePowerUp spends from inventory before touching coins', () async {
    final profile = await PlayerProfileController.load();
    // starts with 3 free hints
    final paid = profile.consumePowerUp('hint');
    expect(paid, isTrue);
    expect(profile.inventoryCount('hint'), 2);
    expect(profile.coins, 100); // untouched - paid from inventory
  });

  test('consumePowerUp falls back to coins once inventory is empty', () async {
    final profile = await PlayerProfileController.load();
    for (var i = 0; i < 3; i++) {
      profile.consumePowerUp('hint');
    }
    expect(profile.inventoryCount('hint'), 0);

    final paid = profile.consumePowerUp('hint'); // costs 50 in coins
    expect(paid, isTrue);
    expect(profile.coins, 50);
  });

  test('consumePowerUp fails and charges nothing when unaffordable', () async {
    final profile = await PlayerProfileController.load();
    for (var i = 0; i < 3; i++) {
      profile.consumePowerUp('hint'); // drain the 3 free hints
    }
    for (var i = 0; i < 2; i++) {
      profile.consumePowerUp('hint'); // 100 coins / 50 cost = 2 more afford
    }
    expect(profile.coins, 0);

    final paid = profile.consumePowerUp('hint');
    expect(paid, isFalse);
    expect(profile.coins, 0);
  });

  test('submitSingleScore only updates on a genuine new best', () async {
    final profile = await PlayerProfileController.load();
    expect(profile.submitSingleScore(500), isTrue);
    expect(profile.bestSingleScore, 500);
    expect(profile.submitSingleScore(300), isFalse);
    expect(profile.bestSingleScore, 500);
    expect(profile.submitSingleScore(500), isFalse); // tie is not a new best
  });

  test('addCoins/addDiamonds accumulate', () async {
    final profile = await PlayerProfileController.load();
    profile.addCoins(50);
    profile.addDiamonds(5);
    expect(profile.coins, 150);
    expect(profile.diamonds, 5);
  });

  test('state persists across a reload from the same storage', () async {
    final profile = await PlayerProfileController.load();
    profile.addCoins(250);
    profile.buyPowerUp('freeze');
    profile.submitSingleScore(777);

    // Give the fire-and-forget persistence a turn to actually write.
    await Future<void>.delayed(Duration.zero);

    final reloaded = await PlayerProfileController.load();
    expect(reloaded.coins, 100 + 250 - 20);
    expect(reloaded.inventoryCount('freeze'), 1);
    expect(reloaded.bestSingleScore, 777);
  });

  test('a fresh profile is light, and the theme choice persists', () async {
    final profile = await PlayerProfileController.load();
    expect(profile.darkMode, isFalse);
    expect(profile.themeMode, ThemeMode.light);

    profile.setDarkMode(true);
    expect(profile.themeMode, ThemeMode.dark);

    // Give the fire-and-forget persistence a turn to actually write.
    await Future<void>.delayed(Duration.zero);

    final reloaded = await PlayerProfileController.load();
    expect(reloaded.darkMode, isTrue);
    expect(reloaded.themeMode, ThemeMode.dark);
  });

  test('a fresh profile owns every free avatar but no premium one', () async {
    final profile = await PlayerProfileController.load();
    for (final avatar in kAvatars.where((a) => !a.premium)) {
      expect(profile.isAvatarOwned(avatar.id), isTrue);
    }
    for (final avatar in kAvatars.where((a) => a.premium)) {
      expect(profile.isAvatarOwned(avatar.id), isFalse);
    }
    expect(profile.avatarId, kDefaultAvatarId);
  });

  test('selectAvatar switches to any owned (free) avatar', () async {
    final profile = await PlayerProfileController.load();
    final freeAvatar = kAvatars.firstWhere((a) => !a.premium && a.id != kDefaultAvatarId);
    expect(profile.selectAvatar(freeAvatar.id), isTrue);
    expect(profile.avatarId, freeAvatar.id);
  });

  test('selectAvatar refuses an unowned premium avatar', () async {
    final profile = await PlayerProfileController.load();
    final premiumAvatar = kAvatars.firstWhere((a) => a.premium);
    expect(profile.selectAvatar(premiumAvatar.id), isFalse);
    expect(profile.avatarId, kDefaultAvatarId);
  });

  test('buyAvatar spends diamonds and unlocks a premium avatar', () async {
    final profile = await PlayerProfileController.load();
    final premiumAvatar = kAvatars.firstWhere((a) => a.premium);
    profile.addDiamonds(kAvatarDiamondCost);

    final bought = profile.buyAvatar(premiumAvatar.id);
    expect(bought, isTrue);
    expect(profile.diamonds, 0);
    expect(profile.isAvatarOwned(premiumAvatar.id), isTrue);
    expect(profile.selectAvatar(premiumAvatar.id), isTrue);
  });

  test('buyAvatar fails without enough diamonds and charges nothing', () async {
    final profile = await PlayerProfileController.load();
    final premiumAvatar = kAvatars.firstWhere((a) => a.premium);

    final bought = profile.buyAvatar(premiumAvatar.id);
    expect(bought, isFalse);
    expect(profile.diamonds, 0);
    expect(profile.isAvatarOwned(premiumAvatar.id), isFalse);
  });
}
