import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import 'single_duration_screen.dart';

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text('בחר מצב משחק', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _ModeTile(
              title: 'שחקן יחיד',
              subtitle: 'מצא כמה שיותר מילים לפני שנגמר הזמן',
              enabled: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SingleDurationScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            const _ModeTile(
              title: 'באטל רויאל',
              subtitle: 'חמישה סיבובים מול בוטים',
              enabled: false,
            ),
            const SizedBox(height: 12),
            const _ModeTile(
              title: 'מולטיפלייר',
              subtitle: 'שחק נגד חברים בזמן אמת',
              enabled: false,
            ),
            const SizedBox(height: 12),
            const _ModeTile(
              title: 'התאמה אקראית',
              subtitle: 'קרב 1 על 1 מול שחקן אקראי',
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: AppColors.panelLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.heading.copyWith(fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ),
                if (!enabled)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface3,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('בקרוב', style: AppTextStyles.bodySecondary),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
