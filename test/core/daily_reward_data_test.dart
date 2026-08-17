import 'package:flutter_test/flutter_test.dart';
import 'package:zbang_royale/core/daily_reward_data.dart';

void main() {
  group('dailyRewardForStreak', () {
    test('day 1 through 6 are coins-only, growing each day', () {
      expect(dailyRewardForStreak(1).coins, 50);
      expect(dailyRewardForStreak(1).diamonds, 0);
      expect(dailyRewardForStreak(6).coins, 300);
      expect(dailyRewardForStreak(6).diamonds, 0);
    });

    test('day 7 pays the big finish, coins and diamonds', () {
      final day7 = dailyRewardForStreak(7);
      expect(day7.coins, 400);
      expect(day7.diamonds, 15);
    });

    test('the cycle repeats every 7 days', () {
      expect(dailyRewardForStreak(8).coins, dailyRewardForStreak(1).coins);
      expect(dailyRewardForStreak(14).coins, dailyRewardForStreak(7).coins);
      expect(dailyRewardForStreak(14).diamonds, dailyRewardForStreak(7).diamonds);
    });
  });
}
