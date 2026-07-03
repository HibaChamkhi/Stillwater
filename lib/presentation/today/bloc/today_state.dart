part of 'today_bloc.dart';

class TodayData extends Equatable {
  const TodayData({
    required this.userName,
    required this.greetingWord,
    required this.streakDays,
    required this.teaDone,
  });

  final String userName;
  final String greetingWord;
  final int streakDays;
  final bool teaDone;

  @override
  List<Object?> get props => [userName, greetingWord, streakDays, teaDone];
}

class TodayState extends UIState<TodayData> {
  const TodayState({super.status, super.message, super.data});

  @override
  TodayState copyWith({UIStatus? status, String? message, TodayData? data}) {
    return TodayState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
