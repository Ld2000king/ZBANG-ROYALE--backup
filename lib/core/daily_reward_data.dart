/// Ported from DAILY_REWARDS in game.js. A 7-day login-streak cycle: the
/// coin bonus grows each day, and day 7 pays a big finish plus diamonds.
/// Missing a day resets the streak back to day 1.
class DailyReward {
  const DailyReward({required this.coins, this.diamonds = 0});

  final int coins;
  final int diamonds;
}

const List<DailyReward> kDailyRewards = [
  DailyReward(coins: 50),
  DailyReward(coins: 100),
  DailyReward(coins: 150),
  DailyReward(coins: 200),
  DailyReward(coins: 250),
  DailyReward(coins: 300),
  DailyReward(coins: 400, diamonds: 15),
];

/// Reward for a given 1-based streak day, cycling every 7 days.
DailyReward dailyRewardForStreak(int streak) =>
    kDailyRewards[(streak - 1) % kDailyRewards.length];
