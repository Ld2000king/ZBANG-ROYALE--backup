import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/screens/word_bank_screen.dart';
import 'package:zbang_royale/theme/app_theme.dart';

void main() {
  testWidgets('lists dictionary words and filters as you type', (tester) async {
    final dictionary = await tester.runAsync(() => DictionaryRepository.load());

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          theme: AppTheme.light,
          home: Provider<DictionaryRepository>.value(
            value: dictionary!,
            child: const WordBankScreen(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('מאגר המילים'), findsOneWidget);
    expect(find.textContaining('מילים במאגר'), findsOneWidget);

    // Search narrows the list down to matching words only. findsWidgets
    // (not findsOneWidget) because the typed query itself echoes the same
    // text back in the search field.
    final sample = dictionary.allWords.first;
    await tester.enterText(find.byType(TextField), sample);
    await tester.pump();

    expect(find.text(sample), findsWidgets);
    expect(find.textContaining('מתוך'), findsOneWidget);

    // A query with no matches shows the empty state instead of a blank list.
    await tester.enterText(find.byType(TextField), 'קקקקקקקקקקקקקקק');
    await tester.pump();
    expect(find.text('לא נמצאו מילים'), findsOneWidget);
  });
}
