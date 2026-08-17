import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zbang_royale/app.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/game/player_profile_controller.dart';

void main() {
  testWidgets('Home screen shows the play CTA and opens mode select', (tester) async {
    SharedPreferences.setMockInitialValues({});

    // Real asset/prefs I/O needs to run outside testWidgets' fake-async
    // zone, otherwise the awaited Future never resolves and the test hangs.
    final dictionary = await tester.runAsync(() => DictionaryRepository.load());
    final profile = await tester.runAsync(() => PlayerProfileController.load());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<DictionaryRepository>.value(value: dictionary!),
          ChangeNotifierProvider<PlayerProfileController>.value(value: profile!),
        ],
        child: const ZbangRoyaleApp(),
      ),
    );
    // Home's aurora background animates forever (ambient decoration), so
    // pumpAndSettle() never settles there - pump a bounded number of frames
    // instead of waiting for stillness that won't come.
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('זבאנג רויאל'), findsOneWidget);
    expect(find.text('משחק'), findsOneWidget);

    await tester.tap(find.text('משחק'));
    await tester.pump(); // let the tap's Navigator.push start the transition
    await tester.pump(const Duration(seconds: 1)); // fast-forward past it

    expect(find.text('שחקן יחיד'), findsOneWidget);
  });
}
