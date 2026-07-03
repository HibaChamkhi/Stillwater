import 'dart:convert';
import '../../../domain/wellness/models/journal_entry.dart';

/// Serialization boundary between storage (JSON strings) and the domain model.
class JournalEntryDto {
  static Map<String, dynamic> toMap(JournalEntry e) => {
        'text': e.text,
        'mood': e.mood,
        'at': e.at.toIso8601String(),
      };

  static JournalEntry fromMap(Map<String, dynamic> map) => JournalEntry(
        text: map['text'] as String,
        mood: map['mood'] as int?,
        at: DateTime.parse(map['at'] as String),
      );

  static String encode(JournalEntry e) => jsonEncode(toMap(e));

  static JournalEntry decode(String raw) =>
      fromMap(jsonDecode(raw) as Map<String, dynamic>);
}
