import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_palette.dart';

/// Ported from the accessibility statement (showAccessibilityStatement in
/// game.js) - bilingual, same wording as the web app and privacy.html/
/// terms.html.
class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  static const _hebrew =
      'אנו עושים מאמצים להנגיש את המשחק לכלל המשתמשים. עם זאת, בשל אופיו כמשחק מולטיפלייר אינטראקטיבי בזמן אמת, ייתכן שחלק מהאלמנטים אינם נגישים באופן מלא לקוראי מסך. אם מצאתם רכיב שאינו נגיש, אנא פנו אלינו לכתובת המייל: liavdimri12@gmail.com ואנו נשתדל לתקן זאת בהקדם האפשרי בהתאם לחוק.';

  static const _english =
      'We make every effort to ensure our game is accessible to all users. However, due to its interactive, real-time multiplayer nature, some elements might not be fully accessible to screen readers. If you encounter any accessibility issues, please contact us at: liavdimri12@gmail.com and we will do our best to address and resolve the issue as soon as possible in accordance with the law.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('נגישות / Accessibility', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('עברית', style: AppTextStyles.bodyEmphasis),
            const SizedBox(height: 8),
            Text(_hebrew, style: AppTextStyles.body),
            const SizedBox(height: 20),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text('English', style: AppTextStyles.bodyEmphasis, textAlign: TextAlign.left),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(_english, style: AppTextStyles.body, textAlign: TextAlign.left),
            ),
          ],
        ),
      ),
    );
  }
}
