part of 'journal_bloc.dart';

class JournalState extends UIState<List<JournalEntry>> {
  const JournalState({super.status, super.message, super.data});

  List<JournalEntry> get entries => data ?? const [];

  @override
  JournalState copyWith({
    UIStatus? status,
    String? message,
    List<JournalEntry>? data,
  }) {
    return JournalState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
