import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zbang_royale/core/avatars_data.dart';
import 'package:zbang_royale/core/daily_reward_data.dart';
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

  test('a fresh profile has a daily reward available on day 1', () async {
    final profile = await PlayerProfileController.load();
    expect(profile.dailyRewardAvailable, isTrue);
    expect(profile.pendingDailyStreak, 1);
    expect(profile.dailyStreak, 0);
  });

  test('claimDailyReward pays day 1 and blocks a second claim same day', () async {
    final profile = await PlayerProfileController.load();
    final reward = profile.claimDailyReward();

    expect(reward, isNotNull);
    expect(reward!.coins, 50);
    expect(reward.diamonds, 0);
    expect(profile.coins, 150);
    expect(profile.dailyStreak, 1);
    expect(profile.dailyRewardAvailable, isFalse);

    expect(profile.claimDailyReward(), isNull);
    expect(profile.coins, 150); // unchanged - the second claim paid nothing
  });

  test('day 7 of the streak also pays diamonds, then the cycle repeats', () async {
    // pendingDailyStreak only continues when the last claim was exactly
    // yesterday - dailyStreak just carries how many consecutive days that
    // run already covers. Six days already banked, last one yesterday,
    // means today resumes the streak at day 7.
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final key = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-'
        '${yesterday.day.toString().padLeft(2, '0')}';
    SharedPreferences.setMockInitialValues({
      'zbang_player_profile':
          '{"coins":100,"diamonds":0,"inventory":{},"bestSingleScore":0,'
              '"avatarId":"dan","ownedAvatars":[],"darkMode":false,'
              '"lastDailyClaim":"$key","dailyStreak":6}',
    });
    final profile = await PlayerProfileController.load();
    expect(profile.pendingDailyStreak, 7);

    final reward = profile.claimDailyReward();
    expect(reward!.coins, 400);
    expect(reward.diamonds, 15);
    expect(profile.dailyStreak, 7);

    // Day 8 wraps back to the day-1 reward.
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    SharedPreferences.setMockInitialValues({
      'zbang_player_profile':
          '{"coins":100,"diamonds":0,"inventory":{},"bestSingleScore":0,'
              '"avatarId":"dan","ownedAvatars":[],"darkMode":false,'
              '"lastDailyClaim":"$todayKey","dailyStreak":7}',
    });
    // Fast-forward "tomorrow" isn't directly simulatable without a clock
    // dependency, so this just checks the cycling math itself.
    expect(dailyRewardForStreak(8).coins, dailyRewardForStreak(1).coins);
  });

  test('missing a day resets the streak back to day 1', () async {
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
    final key = '${twoDaysAgo.year}-${twoDaysAgo.month.toString().padLeft(2, '0')}-'
        '${twoDaysAgo.day.toString().padLeft(2, '0')}';
    SharedPreferences.setMockInitialValues({
      'zbang_player_profile':
          '{"coins":100,"diamonds":0,"inventory":{},"bestSingleScore":0,'
              '"avatarId":"dan","ownedAvatars":[],"darkMode":false,'
              '"lastDailyClaim":"$key","dailyStreak":4}',
    });
    final profile = await PlayerProfileController.load();
    expect(profile.pendingDailyStreak, 1); // the gap breaks the streak
    final reward = profile.claimDailyReward();
    expect(reward!.coins, 50); // day-1 reward, not a continuation of day 5
  });
}
