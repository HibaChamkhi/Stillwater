import 'package:injectable/injectable.dart';

import '../../../domain/wellness/models/journal_entry.dart';
import '../../../domain/wellness/models/practice.dart';
import '../../../domain/wellness/models/wellness_stats.dart';
import '../../../domain/wellness/repositories/wellness_repository.dart';
import '../data_sources/local/wellness_local_data_source.dart';
import '../library_data.dart';

@Injectable(as: WellnessRepository)
class WellnessRepositoryImpl implements WellnessRepository {
  final WellnessLocalDataSource local;

  WellnessRepositoryImpl(this.local);

  @override
  Future<WellnessStats> getStats() async {
    final res = await local.readStats();
    return res.fold((e) => throw e, (stats) => stats);
  }

  @override
  Future<void> addPracticeTime(Duration listened) async {
    if (listened <= Duration.zero) return;
    final stats = await getStats();
    final updated = _withTodayDone(
      stats.copyWith(totalTime: stats.totalTime + listened),
    );
    (await local.writeStats(updated)).fold((e) => throw e, (_) {});
  }

  @override
  Future<bool> getTeaDone() async {
    final res = await local.readTeaDone();
    return res.fold((e) => throw e, (v) => v);
  }

  @override
  Future<void> setTeaDone(bool value) async {
    (await local.writeTeaDone(value)).fold((e) => throw e, (_) {});
    if (value) {
      final stats = _withTodayDone(await getStats());
      (await local.writeStats(stats)).fold((e) => throw e, (_) {});
    }
  }

  @override
  List<Practice> getLibrary() => kLibraryPractices;

  @override
  Future<List<JournalEntry>> getEntries() async {
    final res = await local.readEntries();
    return res.fold((e) => throw e, (v) => v);
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    final entries = await getEntries();
    final updatedEntries = [...entries, entry];
    (await local.writeEntries(updatedEntries)).fold((e) => throw e, (_) {});

    final words = entry.text.trim().split(RegExp(r'\s+')).length;
    final addedPages = (words / 180).ceil().clamp(1, 4);
    final stats = await getStats();
    final updated = _withTodayDone(
      stats.copyWith(pagesWritten: stats.pagesWritten + addedPages),
    );
    (await local.writeStats(updated)).fold((e) => throw e, (_) {});
  }

  /// Marks today complete and bumps the streak once.
  WellnessStats _withTodayDone(WellnessStats stats) {
    if (stats.weekDone[stats.todayIndex]) return stats;
    final week = [...stats.weekDone];
    week[stats.todayIndex] = true;
    return stats.copyWith(weekDone: week, streakDays: stats.streakDays + 1);
  }
}
