import 'package:flutter/material.dart';

import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/today_screen.dart';
import 'screens/breathe_screen.dart';
import 'screens/library_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const StillwaterApp());
}

class StillwaterApp extends StatelessWidget {
  const StillwaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stillwater',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.pageBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.sage,
          surface: AppColors.pageBg,
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final AppState _state = AppState();
  int _index = 0;

  static const _screens = [
    TodayScreen(),
    BreatheScreen(),
    LibraryScreen(),
    JournalScreen(),
    StatsScreen(),
  ];

  static const _backgrounds = [
    AppColors.pageBg,
    AppColors.breatheBg,
    AppColors.surface,
    AppColors.journalBg,
    AppColors.pageBg,
  ];

  static const _items = <_NavItem>[
    _NavItem('Today', Icons.wb_sunny_outlined),
    _NavItem('Breathe', Icons.air),
    _NavItem('Library', Icons.menu_book_outlined),
    _NavItem('Journal', Icons.edit_outlined),
    _NavItem('Stats', Icons.insights_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _state.navigateTo = (i) {
      if (mounted) setState(() => _index = i);
    };
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: Scaffold(
        backgroundColor: _backgrounds[_index],
        body: IndexedStack(index: _index, children: _screens),
        bottomNavigationBar: _BottomBar(
          items: _items,
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BarButton(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.forest : AppColors.inkSoft;
    return InkResponse(
      onTap: onTap,
      radius: 36,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppText.sans(
                size: 11,
                weight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
