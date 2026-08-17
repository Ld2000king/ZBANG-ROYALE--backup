import 'package:flutter/widgets.dart';

/// Ported from AVATARS in avatars.js. The original renders each as a
/// detailed inline SVG emblem (crown, sword, ninja mask, ...); this port
/// keeps the identity that matters for the shop/profile - id, name,
/// premium gating, and the gradient - as a simpler gradient-circle
/// placeholder. A full custom-icon-per-avatar pass is a later polish item.
class AvatarInfo {
  const AvatarInfo({
    required this.id,
    required this.name,
    required this.colors,
    this.premium = false,
  });

  final String id;
  final String name;
  final List<Color> colors;
  final bool premium;
}

const int kAvatarDiamondCost = 20;
const String kDefaultAvatarId = 'dan';

const List<AvatarInfo> kAvatars = [
  AvatarInfo(id: 'dan', name: 'דן', colors: [Color(0xFF5B8DEF), Color(0xFF2C4F94)]),
  AvatarInfo(id: 'maya', name: 'מאיה', colors: [Color(0xFFE86FB0), Color(0xFF8E44AD)]),
  AvatarInfo(id: 'tom', name: 'תום', colors: [Color(0xFF26C6C9), Color(0xFF1A7A8C)]),
  AvatarInfo(id: 'noa', name: 'נועה', colors: [Color(0xFF3DD68C), Color(0xFF159A63)]),
  AvatarInfo(id: 'ari', name: 'ארי', colors: [Color(0xFFF6A93B), Color(0xFFC9631A)]),
  AvatarInfo(id: 'shira', name: 'שירה', colors: [Color(0xFFA06BE8), Color(0xFF6A3FC0)]),
  AvatarInfo(id: 'cool', name: 'קול', colors: [Color(0xFF4A5568), Color(0xFF232A36)]),
  AvatarInfo(id: 'grandpa', name: 'סבא', colors: [Color(0xFF8FA1B3), Color(0xFF5A6B7D)]),
  AvatarInfo(id: 'ninja', name: 'נינג׳ה', colors: [Color(0xFF2B2F3A), Color(0xFF12141B)]),
  AvatarInfo(id: 'robot', name: 'רובוט', colors: [Color(0xFF38C6E8), Color(0xFF1E7FA8)]),
  AvatarInfo(id: 'cat', name: 'חתול', colors: [Color(0xFFFBB040), Color(0xFFE4761B)]),
  AvatarInfo(id: 'dog', name: 'חומי', colors: [Color(0xFFB97A56), Color(0xFF6D4C34)]),
  AvatarInfo(id: 'alien', name: 'חייזר', colors: [Color(0xFF7C4DFF), Color(0xFF4527A0)]),

  // Premium ("cooler") avatars - bought with diamonds.
  AvatarInfo(id: 'king', name: 'מלך', premium: true, colors: [Color(0xFF3B4CC0), Color(0xFF1A237E)]),
  AvatarInfo(id: 'cyber', name: 'סייבר', premium: true, colors: [Color(0xFF0FA3B1), Color(0xFF0B2A3A)]),
  AvatarInfo(id: 'flame', name: 'להבה', premium: true, colors: [Color(0xFF7A1B00), Color(0xFF3E0A00)]),
  AvatarInfo(id: 'hero', name: 'גיבור', premium: true, colors: [Color(0xFFC0392B), Color(0xFF1A237E)]),
  AvatarInfo(id: 'galaxy', name: 'גלקסי', premium: true, colors: [Color(0xFF3A2A80), Color(0xFF140A3A)]),
];

AvatarInfo avatarById(String id) => kAvatars.firstWhere(
      (a) => a.id == id,
      orElse: () => kAvatars.first,
    );
