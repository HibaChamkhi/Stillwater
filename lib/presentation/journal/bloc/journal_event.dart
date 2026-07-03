part of 'journal_bloc.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class LoadEntriesEvent extends JournalEvent {}

class SaveEntryEvent extends JournalEvent {
  final String text;
  final int? mood;

  const SaveEntryEvent({required this.text, required this.mood});

  @override
  List<Object?> get props => [text, mood];
}
