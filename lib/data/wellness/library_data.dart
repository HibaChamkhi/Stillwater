import '../../domain/wellness/models/practice.dart';

/// Static library content. Filter categories match [libraryFilters].
const List<Practice> kLibraryPractices = <Practice>[
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

const List<String> libraryFilters = ['All', 'Breath', 'Sleep', 'Walks', 'Reading'];
