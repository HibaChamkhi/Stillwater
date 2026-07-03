import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/ui/styles/colors.dart';
import '../../../core/ui/styles/typography.dart';
import '../../../domain/wellness/models/wellness_stats.dart';
import '../bloc/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatsBloc>()..add(LoadStatsEvent()),
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          final stats = state.data;
          if (stats == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.sage));
          }
          return _StatsBody(stats: stats);
        },
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats});

  final WellnessStats stats;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        children: [
          Text.rich(
            TextSpan(
              style: AppText.serif(size: 30),
              children: [
                const TextSpan(text: 'A small '),
                TextSpan(
                  text: 'practice',
                  style: AppText.serif(size: 30, italic: true, color: AppColors.greenText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('MARCH · GENTLE METRICS', style: AppText.label()),
          const SizedBox(height: 28),
          Column(
            children: [
              Text('${stats.streakDays}', style: AppText.serif(size: 68, height: 1)),
              const SizedBox(height: 4),
              Text('DAYS · RETURNING', style: AppText.label()),
            ],
          ),
          const SizedBox(height: 26),
          _WeekRow(weekDone: stats.weekDone, todayIndex: stats.todayIndex),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(child: _MetricTile(label: 'TOTAL TIME', value: stats.totalTimeLabel)),
              const SizedBox(width: 16),
              Expanded(child: _MetricTile(label: 'PAGES WRITTEN', value: '${stats.pagesWritten}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({required this.weekDone, required this.todayIndex});

  final List<bool> weekDone;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [for (var i = 0; i < days.length; i++) _dayCell(i)],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final d in days)
              SizedBox(width: 34, child: Center(child: Text(d, style: AppText.label()))),
          ],
        ),
      ],
    );
  }

  Widget _dayCell(int i) {
    final done = i < weekDone.length && weekDone[i];
    final today = i == todayIndex;
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: done ? AppColors.sage : AppColors.tan,
        borderRadius: BorderRadius.circular(9),
        border: today ? Border.all(color: AppColors.forest, width: 1.5) : null,
      ),
      child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.label()),
          const Spacer(),
          Text(value, style: AppText.serif(size: 30)),
        ],
      ),
    );
  }
}
