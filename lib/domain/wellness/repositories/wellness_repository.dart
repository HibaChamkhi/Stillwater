import '../models/journal_entry.dart';
import '../models/practice.dart';
import '../models/wellness_stats.dart';

/// Domain contract for all wellness data. Implemented in the data layer.
abstract class WellnessRepository {
  Future<WellnessStats> getStats();

  /// Records a finished breathing session (adds time, marks today done).
  Future<void> addPracticeTime(Duration listened);

  Future<bool> getTeaDone();
  Future<void> setTeaDone(bool value);

  List<Practice> getLibrary();

  Future<List<JournalEntry>> getEntries();

  /// Saves an entry and updates pages-written / streak.
  Future<void> saveEntry(JournalEntry entry);
}
