import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../theme/app_text_styles.dart';
import '../theme/app_palette.dart';

/// Renders a bundled legal-text asset (assets/legal/*.txt, extracted
/// verbatim from privacy.html / terms.html so the wording stays a single
/// source of truth). A leading '# ' marks a title, '## ' a section heading,
/// '- ' a bullet, '> ' the closing disclaimer - everything else is a
/// paragraph.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.title, required this.assetPath});

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text(title, style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: rootBundle.loadString(assetPath),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final blocks = snapshot.data!.trim().split('\n\n');
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [for (final block in blocks) _LegalBlock(block)],
            );
          },
        ),
      ),
    );
  }
}

class _LegalBlock extends StatelessWidget {
  const _LegalBlock(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(text.substring(2), style: AppTextStyles.heading),
      );
    }
    if (text.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(text.substring(3), style: AppTextStyles.bodyEmphasis),
      );
    }
    if (text.startsWith('- ')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  ', style: AppTextStyles.body),
            Expanded(child: Text(text.substring(2), style: AppTextStyles.body)),
          ],
        ),
      );
    }
    if (text.startsWith('> ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          text.substring(2),
          style: context.palette.secondaryText.copyWith(fontStyle: FontStyle.italic),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: AppTextStyles.body),
    );
  }
}
