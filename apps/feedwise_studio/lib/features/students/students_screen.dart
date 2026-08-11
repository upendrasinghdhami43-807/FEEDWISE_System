import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/providers/teacher_provider.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_avatar.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_text_field.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(filteredStudentsProvider);
    final filter = ref.watch(studentFilterProvider);
    final notifier = ref.read(studentFilterProvider.notifier);

    return AdminLayout(
      title: 'Students',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─ Filter row
            LayoutBuilder(
              builder: (context, constraints) {
                final searchField = FWSearchField(
                  hint: 'Search students by name or email...',
                  onChanged: notifier.setSearch,
                );
                final filters = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterBtn(label: 'All',              selected: filter.filter == null,             onTap: () => notifier.setFilter(null)),
                      const SizedBox(width: 8),
                      _FilterBtn(label: '🔥 High Performers', selected: filter.filter == 'high_performers', onTap: () => notifier.setFilter('high_performers'), color: AppColors.success),
                      const SizedBox(width: 8),
                      _FilterBtn(label: '⚠️ Needs Support',  selected: filter.filter == 'struggling',     onTap: () => notifier.setFilter('struggling'), color: AppColors.error),
                    ],
                  ),
                );

                final sortRow = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text('Sort by:', style: AppTypography.labelMedium(AppColors.textSecondaryDark)),
                      const SizedBox(width: 10),
                      ...StudentSortBy.values.map((s) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _SortBtn(
                          label: _sortLabel(s),
                          selected: filter.sortBy == s,
                          onTap: () => notifier.setSortBy(s),
                        ),
                      )),
                      const SizedBox(width: 12),
                      Text('${students.length} students', style: AppTypography.bodySmall(AppColors.textTertiaryDark)),
                    ],
                  ),
                );

                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      searchField,
                      const SizedBox(height: 12),
                      filters,
                      const SizedBox(height: 12),
                      sortRow,
                    ],
                  );
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: searchField),
                        const SizedBox(width: 12),
                        filters,
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: sortRow),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 900,
                child: FWCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceElevatedDark,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: _ColHeader('Student')),
                            Expanded(flex: 2, child: _ColHeader('Class')),
                            Expanded(child: _ColHeader('Score')),
                            Expanded(child: _ColHeader('Level')),
                            Expanded(child: _ColHeader('Streak')),
                            Expanded(child: _ColHeader('Last Active')),
                            SizedBox(width: 40, child: _ColHeader('')),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderDark),

                      if (students.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: Text('No students match the filter', style: TextStyle(color: AppColors.textSecondaryDark))),
                        )
                      else
                        ...students.asMap().entries.map((entry) {
                          final i = entry.key;
                          final s = entry.value;
                          return Column(
                            children: [
                              _StudentRow(student: s, onTap: () {
                                ref.read(selectedStudentIdProvider.notifier).state = s.id;
                                context.go('/students/${s.id}');
                              }),
                              if (i < students.length - 1)
                                const Divider(height: 1, color: AppColors.borderDark),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sortLabel(StudentSortBy s) => switch (s) {
    StudentSortBy.name       => 'Name',
    StudentSortBy.score      => 'Score',
    StudentSortBy.progress   => 'Progress',
    StudentSortBy.streak     => 'Streak',
    StudentSortBy.lastActive => 'Last Active',
  };
}

class _StudentRow extends StatefulWidget {
  final dynamic student;
  final VoidCallback onTap;
  const _StudentRow({required this.student, required this.onTap});

  @override
  State<_StudentRow> createState() => _StudentRowState();
}

class _StudentRowState extends State<_StudentRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final scoreColor = s.averageScore >= 80 ? AppColors.success : s.averageScore < 60 ? AppColors.error : AppColors.warning;
    final lastActive = s.lastActive as DateTime?;
    final lastActiveStr = lastActive == null ? 'Never'
      : DateTime.now().difference(lastActive).inMinutes < 60 ? '${DateTime.now().difference(lastActive).inMinutes}m ago'
      : DateTime.now().difference(lastActive).inHours < 24  ? '${DateTime.now().difference(lastActive).inHours}h ago'
      : '${DateTime.now().difference(lastActive).inDays}d ago';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: _hovered ? AppColors.surfaceElevatedDark : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    FWAvatar(name: s.name as String, size: 34),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name as String, style: AppTypography.titleSmall(AppColors.textPrimaryDark)),
                          Text(s.email as String, style: AppTypography.labelSmall(AppColors.textTertiaryDark), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Text(s.className as String, style: AppTypography.bodySmall(AppColors.textSecondaryDark))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${(s.averageScore as double).round()}%', style: TextStyle(color: scoreColor, fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: (s.averageScore as double) / 100,
                        minHeight: 4,
                        color: scoreColor,
                        backgroundColor: AppColors.surfaceElevatedDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary500.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Lv.${s.milLevel}', style: const TextStyle(color: AppColors.primary400, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 14, color: AppColors.secondary400),
                    const SizedBox(width: 4),
                    Text('${s.streak}d', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                  ],
                ),
              ),
              Expanded(child: Text(lastActiveStr, style: AppTypography.bodySmall(AppColors.textSecondaryDark))),
              SizedBox(
                width: 40,
                child: Icon(
                  Icons.chevron_right,
                  color: _hovered ? AppColors.primary400 : AppColors.textTertiaryDark,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String label;
  const _ColHeader(this.label);

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w600),
  );
}

class _FilterBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const _FilterBtn({required this.label, required this.selected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary500;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.withValues(alpha: 0.12) : AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? c : AppColors.borderDark),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? c : AppColors.textSecondaryDark, fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
        ),
      ),
    );
  }
}

class _SortBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SortBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary500.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: selected ? AppColors.primary400 : AppColors.textTertiaryDark, fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
    ),
  );
}
