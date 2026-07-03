import 'package:equatable/equatable.dart';

class WellnessStats extends Equatable {
  const WellnessStats({
    required this.userName,
    required this.streakDays,
    required this.totalTime,
    required this.pagesWritten,
    required this.weekDone,
    this.todayIndex = 3,
  });

  final String userName;
  final int streakDays;
  final Duration totalTime;
  final int pagesWritten;
  final List<bool> weekDone; // Mon..Sun
  final int todayIndex;

  String get totalTimeLabel {
    final h = totalTime.inHours;
    final m = totalTime.inMinutes % 60;
    return h == 0 ? '${m}m' : '${h}h ${m}m';
  }

  String get greetingWord {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  WellnessStats copyWith({
    String? userName,
    int? streakDays,
    Duration? totalTime,
    int? pagesWritten,
    List<bool>? weekDone,
    int? todayIndex,
  }) {
    return WellnessStats(
      userName: userName ?? this.userName,
      streakDays: streakDays ?? this.streakDays,
      totalTime: totalTime ?? this.totalTime,
      pagesWritten: pagesWritten ?? this.pagesWritten,
      weekDone: weekDone ?? this.weekDone,
      todayIndex: todayIndex ?? this.todayIndex,
    );
  }

  @override
  List<Object?> get props =>
      [userName, streakDays, totalTime, pagesWritten, weekDone, todayIndex];
}
