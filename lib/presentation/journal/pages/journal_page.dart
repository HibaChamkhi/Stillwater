import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/model/ui_state.dart';
import '../../../core/ui/styles/colors.dart';
import '../../../core/ui/styles/typography.dart';
import '../../../domain/wellness/models/journal_entry.dart';
import '../bloc/journal_bloc.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JournalBloc>()..add(LoadEntriesEvent()),
      child: const _JournalView(),
    );
  }
}

class _JournalView extends StatefulWidget {
  const _JournalView();

  @override
  State<_JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<_JournalView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  int? _mood;

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

  void _save() {
    final text = _controller.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write a little something first.')),
      );
      return;
    }
    context.read<JournalBloc>().add(SaveEntryEvent(text: text, mood: _mood));
    _controller.clear();
    _focus.unfocus();
    setState(() => _mood = null);
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
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        final entries = state.entries;
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
              _card(
                Column(
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
              _card(
                TextField(
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
              _moodRow(),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _save,
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
              if (entries.isNotEmpty) ...[
                const SizedBox(height: 30),
                Text('EARLIER TODAY · ${entries.length}', style: AppText.label()),
                const SizedBox(height: 12),
                for (final e in entries.reversed) ...[
                  _entryCard(e),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _card(Widget child) {
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

  Widget _moodRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var i = 0; i < _moodIcons.length; i++)
          GestureDetector(
            onTap: () => setState(() => _mood = _mood == i ? null : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _mood == i ? AppColors.sage : AppColors.tan,
              ),
              child: Icon(
                _moodIcons[i],
                size: 20,
                color: _mood == i ? Colors.white : AppColors.forest,
              ),
            ),
          ),
      ],
    );
  }

  Widget _entryCard(JournalEntry e) {
    final hh = e.at.hour.toString().padLeft(2, '0');
    final mm = e.at.minute.toString().padLeft(2, '0');
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
          Text(e.text, style: AppText.sans(size: 14, height: 1.55)),
        ],
      ),
    );
  }
}
