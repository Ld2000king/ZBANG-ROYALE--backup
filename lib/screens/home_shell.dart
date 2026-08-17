import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import '../widgets/aurora_background.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';
import '../theme/app_palette.dart';

/// Lets anything inside the shell switch tabs - e.g. the Home tab's player
/// card jumping to Profile - without pushing a route or rebuilding the shell.
class HomeShellScope extends InheritedWidget {
  const HomeShellScope({super.key, required this.goToTab, required super.child});

  final ValueChanged<int> goToTab;

  static HomeShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeShellScope>();

  @override
  bool updateShouldNotify(HomeShellScope oldWidget) => goToTab != oldWidget.goToTab;
}

/// Tab indices within [HomeShell].
abstract final class HomeTab {
  static const int home = 0;
  static const int shop = 1;
  static const int profile = 2;
}

/// The app's persistent tab shell: Home / Shop / Profile behind one bottom
/// nav, so those three never push over each other and the bar stays put.
/// Everything below them (mode setup, gameplay, results) is still pushed as
/// a normal route on top of the shell.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = HomeTab.home});

  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    BottomNavItem(iconName: 'home', label: 'בית'),
    BottomNavItem(iconName: 'shopBag', label: 'חנות'),
    BottomNavItem(iconName: 'profile', label: 'פרופיל'),
  ];

  void _goToTab(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return HomeShellScope(
      goToTab: _goToTab,
      child: Scaffold(
        backgroundColor: context.palette.bgDeep,
        // The ambient glow sits behind every tab so the shell reads as one
        // continuous surface. It's dialled down on the light theme, where
        // the same alpha that flatters dark surfaces turns the page muddy.
        body: AuroraBackground(
          strength: Theme.of(context).brightness == Brightness.dark ? 1.0 : 0.35,
          // IndexedStack keeps each tab's scroll position and state alive as
          // the player moves between them.
          child: IndexedStack(
            index: _index,
            children: const [HomeScreen(), ShopScreen(), ProfileScreen()],
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          items: _items,
          currentIndex: _index,
          onSelected: _goToTab,
        ),
      ),
    );
  }
}
