import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zbang_royale/app.dart';
import 'package:zbang_royale/data/dictionary/dictionary_repository.dart';
import 'package:zbang_royale/game/player_profile_controller.dart';

void main() {
  testWidgets('Home tab shows the mode grid and opens single player', (tester) async {
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
    // The shell's aurora background animates forever, so pumpAndSettle()
    // never settles here - pump a bounded span instead.
    await tester.pump(const Duration(seconds: 1));

    // A fresh profile has never claimed a daily reward, so the shell
    // auto-opens that screen (pushed from a post-frame callback) on top of
    // Home - dismiss it before asserting on Home's own content. The push's
    // slide-in transition needs real time to reach the screen before it's
    // tappable, not just an extra frame. pageBack() looks for an English
    // "Back" tooltip or a Cupertino back button, neither of which exists in
    // this Hebrew-only app - the AppBar's auto-added back arrow is its one
    // IconButton.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Home tab content.
    expect(find.text('זבאנג רויאל'), findsOneWidget);
    expect(find.text('שחקן יחיד'), findsOneWidget);
    expect(find.text('באטל רויאל'), findsOneWidget);

    // The bottom nav is present, with the two "coming soon" modes disabled
    // rather than removed.
    expect(find.text('בית'), findsOneWidget);
    expect(find.text('חנות'), findsOneWidget);
    expect(find.text('פרופיל'), findsOneWidget);
    expect(find.text('בקרוב'), findsNWidgets(2));

    // A mode card launches straight into that mode's setup.
    await tester.tap(find.text('שחקן יחיד'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('בחר משך זמן'), findsOneWidget);
  });

  testWidgets('bottom nav switches between Home, Shop and Profile', (tester) async {
    SharedPreferences.setMockInitialValues({});
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
    await tester.pump(const Duration(seconds: 1));

    // Dismiss the auto-opened daily reward (see the first test) before
    // exercising the bottom nav.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('חנות'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('עזרים למשחק'), findsOneWidget);

    await tester.tap(find.text('פרופיל'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('תמונות פרופיל'), findsOneWidget);
  });
}
