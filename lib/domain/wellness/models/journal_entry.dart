import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.text,
    required this.mood,
    required this.at,
  });

  final String text;
  final int? mood;
  final DateTime at;

  @override
  List<Object?> get props => [text, mood, at];
}
