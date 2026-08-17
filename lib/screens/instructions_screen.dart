import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_palette.dart';

/// Ported from the instructions modal (showInstructions in game.js) - the
/// same rules text, opened from Home's help button.
class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  static const _rules = [
    'גרור אצבע על אותיות סמוכות בלוח כדי לחבר מילה בעברית.',
    'מילה תקפה מזכה בניקוד לפי אורכה - ככל שהמילה ארוכה יותר, כך הניקוד גבוה יותר.',
    'משחק יחיד: מרוץ נגד השעון למצוא כמה שיותר מילים בלוח.',
    'באטל רויאל: 5 סיבובים נגד בוטים - בכל סיבוב מודח מי שצבר הכי מעט ניקוד.',
    'עזרים (רמז, ערבוב לוח, הקפאה) נקנים במטבעות תוך כדי משחק.',
    'אם נגמרות המילים האפשריות בלוח, הוא מתערבב אוטומטית כדי שתוכלו להמשיך לשחק.',
    'מטבעות מרוויחים דרך משחק וניתן להשתמש בהם בחנות ולקנות עזרים.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('הוראות משחק', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final rule in _rules)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•  ', style: AppTextStyles.bodyEmphasis),
                    Expanded(child: Text(rule, style: AppTextStyles.body)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
