import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/dictionary/dictionary_repository.dart';
import 'game/player_profile_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dictionary = await DictionaryRepository.load();
  final profile = await PlayerProfileController.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<DictionaryRepository>.value(value: dictionary),
        ChangeNotifierProvider<PlayerProfileController>.value(value: profile),
      ],
      child: const ZbangRoyaleApp(),
    ),
  );
}
