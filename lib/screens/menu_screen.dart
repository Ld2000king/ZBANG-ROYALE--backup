import 'package:flutter/material.dart';

import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/pressable_scale.dart';
import 'accessibility_screen.dart';
import 'daily_reward_screen.dart';
import 'instructions_screen.dart';
import 'legal_screen.dart';
import 'word_bank_screen.dart';
import '../theme/app_palette.dart';

/// Ported from the hamburger menu (openMenu in game.js): links to the daily
/// bonus, the word bank, and the legal/accessibility pages. A pushed screen
/// rather than an overlay bubble, matching how every other secondary surface
/// in this app navigates.
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('תפריט', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _MenuRow(
              icon: 'help',
              label: 'הוראות משחק',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InstructionsScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _MenuRow(
              icon: 'gift',
              label: 'בונוס התחברות',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DailyRewardScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _MenuRow(
              icon: 'book',
              label: 'מאגר המילים',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WordBankScreen()),
              ),
            ),
            const SizedBox(height: 24),
            _MenuRow(
              label: 'נגישות / Accessibility',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AccessibilityScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _MenuRow(
              label: 'פרטיות / Privacy',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalScreen(
                    title: 'פרטיות / Privacy',
                    assetPath: 'assets/legal/privacy.txt',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _MenuRow(
              label: 'תנאים / Terms',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LegalScreen(
                    title: 'תנאים / Terms',
                    assetPath: 'assets/legal/terms.txt',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({this.icon, required this.label, required this.onTap});

  final String? icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: appCardDecoration(context, radius: AppRadii.sm),
        child: Row(
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 20, color: context.palette.textPrimary),
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(label, style: AppTextStyles.bodyEmphasis)),
            Text('‹', style: context.palette.secondaryText.copyWith(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
