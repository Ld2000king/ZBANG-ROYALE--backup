import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_palette.dart';

class FoundWordsPanel extends StatelessWidget {
  const FoundWordsPanel({
    super.key,
    required this.foundWords,
    required this.pointsFor,
  });

  final List<String> foundWords;
  final int Function(String word) pointsFor;

  @override
  Widget build(BuildContext context) {
    if (foundWords.isEmpty) {
      return Text('עוד לא מצאת מילים', style: context.palette.secondaryText);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: foundWords.map((word) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.palette.surface2,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(word, style: AppTextStyles.bodyEmphasis),
              const SizedBox(width: 6),
              Text(
                '+${pointsFor(word)}',
                style: context.palette.secondaryText.copyWith(color: AppColors.gold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
