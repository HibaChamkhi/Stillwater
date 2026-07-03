part of 'stats_bloc.dart';

class StatsState extends UIState<WellnessStats> {
  const StatsState({super.status, super.message, super.data});

  @override
  StatsState copyWith({UIStatus? status, String? message, WellnessStats? data}) {
    return StatsState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
