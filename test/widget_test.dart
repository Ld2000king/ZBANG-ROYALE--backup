import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:zbang_royale/app.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';

void main() {
  testWidgets('Home screen shows the play CTA and opens mode select', (tester) async {
    // Real asset I/O needs to run outside testWidgets' fake-async zone,
    // otherwise the awaited Future never resolves and the test hangs.
    final dictionary = await tester.runAsync(() => DictionaryRepository.load());

    await tester.pumpWidget(
      Provider<DictionaryRepository>.value(
        value: dictionary!,
        child: const ZbangRoyaleApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('זבאנג רויאל'), findsOneWidget);
    expect(find.text('שחק'), findsOneWidget);

    await tester.tap(find.text('שחק'));
    await tester.pumpAndSettle();

    expect(find.text('שחקן יחיד'), findsOneWidget);
  });
}
