import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key, required this.secondsLeft, this.frozen = false});

  final int secondsLeft;
  final bool frozen;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('זמן', style: AppTextStyles.bodySecondary),
        Text(
          '$secondsLeft',
          style: AppTextStyles.timer.copyWith(
            color: frozen ? AppColors.blue : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
