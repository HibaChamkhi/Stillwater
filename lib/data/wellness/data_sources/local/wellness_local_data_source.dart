import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/error_utils.dart';
import '../../../../domain/wellness/models/journal_entry.dart';
import '../../../../domain/wellness/models/wellness_stats.dart';
import '../../dtos/journal_entry_dto.dart';

/// Local persistence contract (mirrors the starter's PrefUtils pattern).
abstract class WellnessLocalDataSource {
  Future<Either<Exception, WellnessStats>> readStats();
  Future<Either<Exception, Unit>> writeStats(WellnessStats stats);
  Future<Either<Exception, bool>> readTeaDone();
  Future<Either<Exception, Unit>> writeTeaDone(bool value);
  Future<Either<Exception, List<JournalEntry>>> readEntries();
  Future<Either<Exception, Unit>> writeEntries(List<JournalEntry> entries);
}

@Injectable(as: WellnessLocalDataSource)
class WellnessLocalDataSourceImpl implements WellnessLocalDataSource {
  final SharedPreferences prefs;

  WellnessLocalDataSourceImpl(this.prefs);

  static const _kSeeded = 'seeded';
  static const _kUser = 'userName';
  static const _kStreak = 'streakDays';
  static const _kMinutes = 'totalMinutes';
  static const _kPages = 'pagesWritten';
  static const _kWeek = 'weekDone';
  static const _kTea = 'teaDone';
  static const _kEntries = 'entries';

  void _seedIfNeeded() {
    if (prefs.getBool(_kSeeded) ?? false) return;
    prefs.setString(_kUser, 'Lena');
    prefs.setInt(_kStreak, 12);
    prefs.setInt(_kMinutes, 262); // 4h 22m
    prefs.setInt(_kPages, 38);
    prefs.setStringList(_kWeek, ['1', '1', '1', '0', '0', '0', '0']);
    prefs.setBool(_kTea, false);
    prefs.setBool(_kSeeded, true);
  }

  @override
  Future<Either<Exception, WellnessStats>> readStats() {
    return performLocalRequest(() async {
      _seedIfNeeded();
      final week = (prefs.getStringList(_kWeek) ?? [])
          .map((e) => e == '1')
          .toList();
      return WellnessStats(
        userName: prefs.getString(_kUser) ?? 'Lena',
        streakDays: prefs.getInt(_kStreak) ?? 0,
        totalTime: Duration(minutes: prefs.getInt(_kMinutes) ?? 0),
        pagesWritten: prefs.getInt(_kPages) ?? 0,
        weekDone: week.length == 7 ? week : List.filled(7, false),
      );
    });
  }

  @override
  Future<Either<Exception, Unit>> writeStats(WellnessStats stats) {
    return performLocalRequest(() async {
      await prefs.setString(_kUser, stats.userName);
      await prefs.setInt(_kStreak, stats.streakDays);
      await prefs.setInt(_kMinutes, stats.totalTime.inMinutes);
      await prefs.setInt(_kPages, stats.pagesWritten);
      await prefs.setStringList(
        _kWeek,
        stats.weekDone.map((e) => e ? '1' : '0').toList(),
      );
      return unit;
    });
  }

  @override
  Future<Either<Exception, bool>> readTeaDone() {
    return performLocalRequest(() async {
      _seedIfNeeded();
      return prefs.getBool(_kTea) ?? false;
    });
  }

  @override
  Future<Either<Exception, Unit>> writeTeaDone(bool value) {
    return performLocalRequest(() async {
      await prefs.setBool(_kTea, value);
      return unit;
    });
  }

  @override
  Future<Either<Exception, List<JournalEntry>>> readEntries() {
    return performLocalRequest(() async {
      final raw = prefs.getStringList(_kEntries) ?? [];
      return raw.map(JournalEntryDto.decode).toList();
    });
  }

  @override
  Future<Either<Exception, Unit>> writeEntries(List<JournalEntry> entries) {
    return performLocalRequest(() async {
      await prefs.setStringList(
        _kEntries,
        entries.map(JournalEntryDto.encode).toList(),
      );
      return unit;
    });
  }
}
