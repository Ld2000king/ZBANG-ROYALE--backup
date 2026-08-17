import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_text_styles.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat.decimalPattern('he').format(score);
    return Column(
      children: [
        Text('ניקוד', style: AppTextStyles.bodySecondary),
        Text(formatted, style: AppTextStyles.score),
      ],
    );
  }
}
