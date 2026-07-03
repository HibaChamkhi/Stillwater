import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/model/ui_state.dart';
import '../../../core/ui/styles/colors.dart';
import '../../../core/ui/styles/typography.dart';
import '../bloc/today_bloc.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key, required this.onBegin, required this.onOpenJournal});

  final VoidCallback onBegin;
  final VoidCallback onOpenJournal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TodayBloc>()..add(LoadTodayEvent()),
      child: BlocBuilder<TodayBloc, TodayState>(
        builder: (context, state) {
          final data = state.data;
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.sage),
            );
          }
          return _TodayBody(
            data: data,
            onBegin: onBegin,
            onOpenJournal: onOpenJournal,
            onToggleTea: () => context.read<TodayBloc>().add(ToggleTeaEvent()),
          );
        },
      ),
    );
  }
}

class _TodayBody extends StatelessWidget {
  const _TodayBody({
    required this.data,
    required this.onBegin,
    required this.onOpenJournal,
    required this.onToggleTea,
  });

  final TodayData data;
  final VoidCallback onBegin;
  final VoidCallback onOpenJournal;
  final VoidCallback onToggleTea;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        children: [
          Text('THURSDAY · MARCH 14', style: AppText.label()),
          const SizedBox(height: 18),
          Text.rich(
            TextSpan(
              style: AppText.serif(size: 34, height: 1.1),
              children: [
                const TextSpan(text: 'A gentle '),
                TextSpan(
                  text: data.greetingWord,
                  style: AppText.serif(size: 34, italic: true, color: AppColors.greenText),
                ),
                TextSpan(text: ' to you, ${data.userName}.'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "You've returned ${data.streakDays} days in a row. "
            "Today's practice is set.",
            style: AppText.sans(size: 14.5, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 26),
          _MorningRitualCard(onBegin: onBegin),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SmallTile(
                  icon: data.teaDone ? Icons.check_circle : Icons.wb_sunny_outlined,
                  title: 'Sunrise tea',
                  meta: data.teaDone ? 'DONE · WELL HELD' : 'RITUAL · 3 MIN',
                  highlight: data.teaDone,
                  onTap: onToggleTea,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SmallTile(
                  icon: Icons.edit_outlined,
                  title: "Today's pages",
                  meta: 'JOURNAL · 8 MIN',
                  onTap: onOpenJournal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MorningRitualCard extends StatelessWidget {
  const _MorningRitualCard({required this.onBegin});

  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.sage,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MORNING RITUAL · 12 MIN', style: AppText.label(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(
            'Returning to the breath',
            style: AppText.serif(size: 25, italic: true, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Guided · Box breathing · 4·4·4·4',
            style: AppText.sans(size: 13, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onBegin,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.sageDark,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Begin  →',
                style: AppText.sans(size: 14, weight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallTile extends StatelessWidget {
  const _SmallTile({
    required this.icon,
    required this.title,
    required this.meta,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String meta;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 128,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: highlight ? AppColors.sage : AppColors.tan,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: highlight ? Colors.white : AppColors.forest),
            const Spacer(),
            Text(
              title,
              style: AppText.serif(
                size: 19,
                italic: true,
                color: highlight ? Colors.white : AppColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(meta, style: AppText.label(color: highlight ? Colors.white70 : AppColors.inkSoft)),
          ],
        ),
      ),
    );
  }
}
