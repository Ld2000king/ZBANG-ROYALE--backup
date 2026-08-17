/// Ported from SHOP_ITEMS in game.js. Every power-up is bought into a
/// per-item inventory slot; using one spends from inventory first, then coins.
class ShopItem {
  const ShopItem({required this.key, required this.name, required this.desc, required this.cost});

  final String key;
  final String name;
  final String desc;
  final int cost;
}

const List<ShopItem> kShopItems = [
  ShopItem(key: 'hint', name: 'רמז', desc: 'מסמן בלוח מילה שעוד לא מצאת', cost: 50),
  ShopItem(key: 'shuffle', name: 'ערבב לוח', desc: 'מחליף את אותיות הלוח', cost: 20),
  ShopItem(key: 'freeze', name: 'הקפא זמן', desc: 'מקפיא את השעון ל-5 שניות', cost: 20),
  ShopItem(
    key: 'freezeOpponents',
    name: 'הקפא יריבים',
    desc: 'באטל רויאל: מקפיא את הבוטים ל-8 שניות',
    cost: 20,
  ),
  ShopItem(key: 'tornado', name: 'ערבב ליריבים', desc: 'באטל רויאל: חותך את ניקוד הבוטים בחצי', cost: 20),
];

/// Coins granted by the mock "watch a video" reward - no real ad SDK wired
/// up yet, matches the original's placeholder behavior.
const int kAdRewardCoins = 50;
