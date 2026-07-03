/// Static content shown across the app. Swap asset paths / copy freely.
class Practice {
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
  final String category; // matches a filter in [libraryFilters]
  final String description;

  String get meta => '$kind · $duration';
}

/// Library entries. The three photos map to real files in assets/images/;
/// the rest reuse them, and any missing file falls back to a soft tile.
const libraryPractices = <Practice>[
  Practice(
    title: 'Morning tea, alone',
    kind: 'RITUAL',
    duration: '8 MIN',
    asset: 'assets/images/morning_tea.jpg',
    category: 'Breath',
    description:
        'A slow, wordless ritual. Make the tea, hold the cup, and let the '
        'first breath of the day arrive on its own.',
  ),
  Practice(
    title: 'Notes on stillness',
    kind: 'READING',
    duration: '12 MIN',
    asset: 'assets/images/notes_stillness.jpg',
    category: 'Reading',
    description:
        'A short reading on doing less — and noticing more — gathered from '
        'quiet writers who made a practice of paying attention.',
  ),
  Practice(
    title: 'A forest, before dawn',
    kind: 'SOUNDSCAPE',
    duration: '30 MIN',
    asset: 'assets/images/forest_dawn.jpg',
    category: 'Sleep',
    description:
        'Rain on bamboo, distant birds, and the hush before first light. '
        'Made to be half-heard as you drift.',
  ),
  Practice(
    title: 'Returning to the breath',
    kind: 'BREATH',
    duration: '12 MIN',
    asset: 'assets/images/morning_tea.jpg',
    category: 'Breath',
    description:
        'Guided box breathing at a 4·4·4·4 count. A steady place to come '
        'back to, whenever the day gets loud.',
  ),
  Practice(
    title: 'A slow walk',
    kind: 'WALK',
    duration: '15 MIN',
    asset: 'assets/images/forest_dawn.jpg',
    category: 'Walks',
    description:
        'A walking meditation. No destination — just the rhythm of stepping '
        'and the world going by a little slower.',
  ),
  Practice(
    title: 'Sleep, softly',
    kind: 'SLEEP',
    duration: '22 MIN',
    asset: 'assets/images/notes_stillness.jpg',
    category: 'Sleep',
    description:
        'A gentle wind-down to loosen the day and let sleep come without '
        'being chased.',
  ),
];

const libraryFilters = <String>['All', 'Breath', 'Sleep', 'Walks', 'Reading'];
