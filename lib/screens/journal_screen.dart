import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  static const _moodIcons = [
    Icons.eco_outlined,
    Icons.circle_outlined,
    Icons.brightness_2_outlined,
    Icons.wb_sunny_outlined,
    Icons.favorite_border,
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _save(AppState state) {
    final text = _controller.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a little something first.')),
      );
      return;
    }
    state.saveJournalEntry(text);
    _controller.clear();
    _focus.unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved to today's pages.")),
    );
  }

  String _stamp() {
    final now = DateTime.now();
    const months = [
      'JAN', 'FEB', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUG', 'SEPT', 'OCT', 'NOV', 'DEC',
    ];
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '${months[now.month - 1]} ${now.day} · $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        children: [
          Text.rich(
            TextSpan(
              style: AppText.serif(size: 30),
              children: [
                const TextSpan(text: "Today's "),
                TextSpan(
                  text: 'pages',
                  style: AppText.serif(size: 30, italic: true, color: AppColors.greenText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(_stamp(), style: AppText.label()),
          const SizedBox(height: 24),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROMPT', style: AppText.label()),
                const SizedBox(height: 10),
                Text(
                  'What is one small thing you\nnoticed this morning?',
                  style: AppText.serif(size: 21, italic: true, height: 1.25),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              maxLines: 5,
              minLines: 3,
              cursorColor: AppColors.sage,
              style: AppText.sans(size: 15, height: 1.6, color: AppColors.ink),
              decoration: InputDecoration.collapsed(
                hintText: 'Begin where you are…',
                hintStyle: AppText.sans(size: 15, color: AppColors.inkSoft),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _MoodRow(
            icons: _moodIcons,
            selected: state.selectedMood,
            onSelect: state.selectMood,
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: () => _save(state),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.sageDark,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Save this page',
                  style: AppText.sans(size: 15, weight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ),
          if (state.entries.isNotEmpty) ...[
            const SizedBox(height: 30),
            Text(
              'EARLIER TODAY · ${state.entriesToday}',
              style: AppText.label(),
            ),
            const SizedBox(height: 12),
            for (final e in state.entries.reversed) ...[
              _EntryCard(entry: e),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

class _MoodRow extends StatelessWidget {
  const _MoodRow({required this.icons, required this.selected, required this.onSelect});

  final List<IconData> icons;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < icons.length; i++)
          GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected == i ? AppColors.sage : AppColors.tan,
              ),
              child: Icon(
                icons[i],
                size: 20,
                color: selected == i ? Colors.white : AppColors.forest,
              ),
            ),
          ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final hh = entry.at.hour.toString().padLeft(2, '0');
    final mm = entry.at.minute.toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$hh:$mm', style: AppText.label()),
          const SizedBox(height: 6),
          Text(entry.text, style: AppText.sans(size: 14, height: 1.55)),
        ],
      ),
    );
  }
}
