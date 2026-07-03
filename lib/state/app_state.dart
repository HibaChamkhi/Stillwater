import 'package:flutter/material.dart';

/// A saved journal entry.
class JournalEntry {
  JournalEntry({required this.text, required this.mood, required this.at});

  final String text;
  final int? mood;
  final DateTime at;
}

/// Single source of truth for the app. In-memory only (no backend), but every
/// screen reads and writes it, so the app feels alive: breathing sessions add
/// to your total time, journal entries add pages, and the week fills in.
class AppState extends ChangeNotifier {
  String userName = 'Lena';

  int streakDays = 12;
  Duration totalTime = const Duration(hours: 4, minutes: 22);
  int pagesWritten = 38;

  /// Mon..Sun. Index 3 (Thu) is "today" in this demo.
  final List<bool> weekDone = [true, true, true, false, false, false, false];
  static const int todayIndex = 3;

  final List<JournalEntry> entries = [];
  int? selectedMood;
  bool teaDone = false;

  /// Set by the shell so any screen can switch tabs.
  void Function(int index)? navigateTo;

  /// Bumped when a breathing session should start (e.g. from "Begin").
  final ValueNotifier<int> breathStartSignal = ValueNotifier<int>(0);

  String get greetingWord {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  String get totalTimeLabel {
    final h = totalTime.inHours;
    final m = totalTime.inMinutes % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }

  int get entriesToday => entries.length;

  void goToBreathAndStart() {
    navigateTo?.call(1);
    breathStartSignal.value++;
  }

  void toggleTea() {
    teaDone = !teaDone;
    if (teaDone) _markTodayDone();
    notifyListeners();
  }

  void selectMood(int index) {
    selectedMood = (selectedMood == index) ? null : index;
    notifyListeners();
  }

  /// Called when a breathing session ends (or is ended early).
  void completeBreath(Duration listened) {
    if (listened > Duration.zero) {
      totalTime += listened;
      _markTodayDone();
      notifyListeners();
    }
  }

  void saveJournalEntry(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    entries.add(JournalEntry(text: trimmed, mood: selectedMood, at: DateTime.now()));
    final words = trimmed.split(RegExp(r'\s+')).length;
    pagesWritten += (words / 180).ceil().clamp(1, 4);
    _markTodayDone();
    notifyListeners();
  }

  void _markTodayDone() {
    if (!weekDone[todayIndex]) {
      weekDone[todayIndex] = true;
      streakDays += 1;
    }
  }

  @override
  void dispose() {
    breathStartSignal.dispose();
    super.dispose();
  }
}

/// Exposes [AppState] to the widget tree; dependents rebuild on change.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required Widget child})
      : super(notifier: state, child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!.notifier!;
  }
}
