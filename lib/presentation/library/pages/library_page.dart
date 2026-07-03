import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/ui/styles/colors.dart';
import '../../../core/ui/styles/typography.dart';
import '../../../core/ui/widgets/soft_image.dart';
import '../../../data/wellness/library_data.dart';
import '../../../domain/wellness/models/practice.dart';
import '../bloc/library_bloc.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key, required this.onBegin});

  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LibraryBloc>()..add(LoadLibraryEvent()),
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          final data = state.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.sage));
          }
          return _LibraryBody(
            data: data,
            onFilter: (f) => context.read<LibraryBloc>().add(ChangeFilterEvent(f)),
            onOpen: (p) => _openSheet(context, p),
          );
        },
      ),
    );
  }

  void _openSheet(BuildContext context, Practice p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PracticeSheet(
        practice: p,
        onBegin: () {
          Navigator.of(context).pop();
          onBegin();
        },
      ),
    );
  }
}

class _LibraryBody extends StatelessWidget {
  const _LibraryBody({required this.data, required this.onFilter, required this.onOpen});

  final LibraryData data;
  final ValueChanged<String> onFilter;
  final ValueChanged<Practice> onOpen;

  @override
  Widget build(BuildContext context) {
    final items = data.visible;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        children: [
          Text.rich(
            TextSpan(
              style: AppText.serif(size: 32),
              children: [
                const TextSpan(text: 'A quiet '),
                TextSpan(
                  text: 'library',
                  style: AppText.serif(size: 32, italic: true, color: AppColors.greenText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${data.all.length} practices · curated weekly',
            style: AppText.sans(size: 13.5, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: libraryFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final label = libraryFilters[i];
                return _FilterChip(
                  label: label,
                  selected: label == data.filter,
                  onTap: () => onFilter(label),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Nothing here yet — a quiet corner.',
                  style: AppText.serif(size: 19, italic: true, color: AppColors.inkSoft),
                ),
              ),
            )
          else
            for (final p in items) ...[
              _PracticeCard(practice: p, onTap: () => onOpen(p)),
              const SizedBox(height: 14),
            ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.sage : AppColors.tan,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppText.sans(
            size: 13,
            weight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({required this.practice, required this.onTap});

  final Practice practice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            SoftImage(asset: practice.asset, width: 62, height: 62, radius: 12),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(practice.title, style: AppText.serif(size: 20, italic: true, height: 1.1)),
                  const SizedBox(height: 6),
                  Text(practice.meta, style: AppText.label()),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(color: AppColors.sage, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeSheet extends StatelessWidget {
  const _PracticeSheet({required this.practice, required this.onBegin});

  final Practice practice;
  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SoftImage(asset: practice.asset, width: double.infinity, height: 160, radius: 18),
            const SizedBox(height: 18),
            Text(practice.title, style: AppText.serif(size: 28, italic: true)),
            const SizedBox(height: 6),
            Text(practice.meta, style: AppText.label()),
            const SizedBox(height: 14),
            Text(
              practice.description,
              style: AppText.sans(size: 14.5, height: 1.55, color: AppColors.ink),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: onBegin,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.sageDark,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Begin practice  →',
                    style: AppText.sans(size: 15, weight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
