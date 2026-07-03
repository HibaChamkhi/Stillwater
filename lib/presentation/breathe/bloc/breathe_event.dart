part of 'breathe_bloc.dart';

abstract class BreatheEvent extends Equatable {
  const BreatheEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when a session finishes (or is ended early), carrying the time
/// actually practiced so it can be recorded in the wellness stats.
class CompletePracticeEvent extends BreatheEvent {
  final Duration listened;

  const CompletePracticeEvent(this.listened);

  @override
  List<Object?> get props => [listened];
}
