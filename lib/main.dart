import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/dictionary/dictionary_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dictionary = await DictionaryRepository.load();

  runApp(
    Provider<DictionaryRepository>.value(
      value: dictionary,
      child: const ZbangRoyaleApp(),
    ),
  );
}
