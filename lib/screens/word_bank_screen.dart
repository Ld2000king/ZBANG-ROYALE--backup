import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/hebrew_utils.dart';
import '../data/dictionary/dictionary_repository.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../theme/app_palette.dart';

/// Ported from the word-bank screen (openWordBank/renderWordBank in
/// game.js): browse and search the full dictionary. The web version's admin
/// add/remove tools are left out - they sign in through Firebase, which this
/// build doesn't connect to.
class WordBankScreen extends StatefulWidget {
  const WordBankScreen({super.key});

  @override
  State<WordBankScreen> createState() => _WordBankScreenState();
}

class _WordBankScreenState extends State<WordBankScreen> {
  late final List<String> _allWords;
  String _query = '';

  @override
  void initState() {
    super.initState();
    final dictionary = context.read<DictionaryRepository>();
    _allWords = dictionary.allWords.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final dictionary = context.read<DictionaryRepository>();
    final query = normalizeFinals(_query.trim());
    final matches = query.isEmpty
        ? _allWords
        : _allWords.where((w) => w.contains(query)).toList();

    return Scaffold(
      backgroundColor: context.palette.bgDeep,
      appBar: AppBar(
        backgroundColor: context.palette.bgDeep,
        title: Text('מאגר המילים', style: AppTextStyles.heading),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(hintText: 'חיפוש מילה...'),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 10),
              Text(
                query.isEmpty
                    ? '${matches.length} מילים במאגר'
                    : '${matches.length} מילים מתוך ${_allWords.length}',
                style: context.palette.secondaryText,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: matches.isEmpty
                    ? Center(child: Text('לא נמצאו מילים', style: context.palette.secondaryText))
                    : ListView.separated(
                        itemCount: matches.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final word = matches[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: appCardDecoration(context, radius: AppRadii.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(word, style: AppTextStyles.bodyEmphasis),
                                Text(
                                  '+${dictionary.pointsFor(word)}',
                                  style: context.palette.secondaryText,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
