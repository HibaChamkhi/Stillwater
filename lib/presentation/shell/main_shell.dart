import 'package:flutter/material.dart';

import '../../core/ui/styles/colors.dart';
import '../../core/ui/styles/typography.dart';
import '../breathe/pages/breathe_page.dart';
import '../journal/pages/journal_page.dart';
import '../library/pages/library_page.dart';
import '../stats/pages/stats_page.dart';
import '../today/pages/today_page.dart';

/// Owns the bottom navigation. Pages are rebuilt on tab change so each
/// feature bloc reloads fresh data from the repository (e.g. Stats reflects a
/// breathing session you just finished).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  bool _breatheAutostart = false;

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

  void _go(int index, {bool autostart = false}) {
    setState(() {
      _index = index;
      _breatheAutostart = autostart;
    });
  }

  Widget _pageFor(int index) {
    switch (index) {
      case 0:
        return TodayPage(
          onBegin: () => _go(1, autostart: true),
          onOpenJournal: () => _go(3),
        );
      case 1:
        return BreathePage(autostart: _breatheAutostart);
      case 2:
        return LibraryPage(onBegin: () => _go(1, autostart: true));
      case 3:
        return const JournalPage();
      case 4:
      default:
        return const StatsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgrounds[_index],
      body: _pageFor(_index),
      bottomNavigationBar: _BottomBar(
        items: _items,
        currentIndex: _index,
        onTap: (i) => _go(i),
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
  const _BarButton({required this.item, required this.selected, required this.onTap});

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
