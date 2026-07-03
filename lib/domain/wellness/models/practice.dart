import 'package:equatable/equatable.dart';

class Practice extends Equatable {
  const Practice({
    required this.title,
    required this.kind,
    required this.duration,
    required this.asset,
    required this.category,
    this.description = '',
  });

  final String title;
  final String kind; // RITUAL, READING, SOUNDSCAPE...
  final String duration; // 8 MIN
  final String asset; // assets/images/<file>
  final String category; // matches a library filter
  final String description;

  String get meta => '$kind · $duration';

  @override
  List<Object?> get props => [title, kind, duration, asset, category, description];
}
