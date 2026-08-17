import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'game/player_profile_controller.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

class ZbangRoyaleApp extends StatelessWidget {
  const ZbangRoyaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watched so flipping the switch in Profile rebuilds MaterialApp with
    // the other themeMode; the theme change itself animates via
    // MaterialApp's built-in theme lerp (AppPalette implements lerp).
    final themeMode = context.watch<PlayerProfileController>().themeMode;

    return MaterialApp(
      title: 'זבאנג רויאל',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: const Locale('he'),
      supportedLocales: const [Locale('he')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomeShell(),
    );
  }
}
