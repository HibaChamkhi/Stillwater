part of 'breathe_bloc.dart';

/// data == true once a completed session has been recorded.
class BreatheState extends UIState<bool> {
  const BreatheState({super.status, super.message, super.data});

  @override
  BreatheState copyWith({UIStatus? status, String? message, bool? data}) {
    return BreatheState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
