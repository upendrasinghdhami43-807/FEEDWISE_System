import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/analytics_model.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';

class ModerationScreen extends ConsumerStatefulWidget {
  const ModerationScreen({super.key});

  @override
  ConsumerState<ModerationScreen> createState() => _ModerationScreenState();
}

class _ModerationScreenState extends ConsumerState<ModerationScreen> {
  String _filter = 'pending';
  late List<ModerationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(MockData.moderationItems);
  }

  List<ModerationItem> get _filteredItems {
    if (_filter == 'all') return _items;
    return _items.where((i) => i.status == _filter).toList();
  }

  void _approve(String id) {
    setState(() {
      _items = _items.map((i) => i.id == id
        ? ModerationItem(id: i.id, title: i.title, submitterName: i.submitterName, submitterEmail: i.submitterEmail, category: i.category, status: 'approved', submittedAt: i.submittedAt, reviewNote: 'Approved by admin.')
        : i
      ).toList();
    });
  }

  void _reject(String id, String note) {
    setState(() {
      _items = _items.map((i) => i.id == id
        ? ModerationItem(id: i.id, title: i.title, submitterName: i.submitterName, submitterEmail: i.submitterEmail, category: i.category, status: 'rejected', submittedAt: i.submittedAt, reviewNote: note)
        : i
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pending  = _items.where((i) => i.status == 'pending').length;
    final approved = _items.where((i) => i.status == 'approved').length;
    final rejected = _items.where((i) => i.status == 'rejected').length;

    return AdminLayout(
      title: 'Moderation',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            Row(
              children: [
                _SummaryCard(label: 'Pending',  count: pending,  color: AppColors.warning),
                const SizedBox(width: 12),
                _SummaryCard(label: 'Approved', count: approved, color: AppColors.success),
                const SizedBox(width: 12),
                _SummaryCard(label: 'Rejected', count: rejected, color: AppColors.error),
              ],
            ),
            const SizedBox(height: 20),

            // Filter tabs
            Row(
              children: [
                _FilterTab(label: 'Pending',  count: pending,  selected: _filter == 'pending',  onTap: () => setState(() => _filter = 'pending')),
                const SizedBox(width: 8),
                _FilterTab(label: 'Approved', count: approved, selected: _filter == 'approved', onTap: () => setState(() => _filter = 'approved')),
                const SizedBox(width: 8),
                _FilterTab(label: 'Rejected', count: rejected, selected: _filter == 'rejected', onTap: () => setState(() => _filter = 'rejected')),
                const SizedBox(width: 8),
                _FilterTab(label: 'All',      count: _items.length, selected: _filter == 'all', onTap: () => setState(() => _filter = 'all')),
              ],
            ),
            const SizedBox(height: 16),

            // Items
            ..._filteredItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ModerationCard(item: item, onApprove: () => _approve(item.id), onReject: (note) => _reject(item.id, note)),
            )),
            if (_filteredItems.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: Column(
                    children: [
                      Icon(Icons.shield_outlined, size: 48, color: AppColors.textTertiaryDark),
                      SizedBox(height: 12),
                      Text('All caught up!', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SummaryCard({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$count', style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w700)),
              Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
            ],
          ),
        ],
      ),
    ),
  );
}

class _FilterTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  const _FilterTab({required this.label, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary500.withOpacity(0.15) : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: selected ? AppColors.primary500 : AppColors.borderDark),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: selected ? AppColors.primary400 : AppColors.textSecondaryDark, fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary500 : AppColors.surfaceCardDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count', style: TextStyle(color: selected ? Colors.white : AppColors.textTertiaryDark, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ),
  );
}

class _ModerationCard extends StatelessWidget {
  final ModerationItem item;
  final VoidCallback onApprove;
  final ValueChanged<String> onReject;
  const _ModerationCard({required this.item, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (item.status) {
      'approved' => AppColors.success,
      'rejected' => AppColors.error,
      _          => AppColors.warning,
    };

    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(item.category, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w500)),
              ),
              const Spacer(),
              Text(item.timeAgo, style: AppTypography.labelSmall(AppColors.textTertiaryDark)),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title, style: AppTypography.titleMedium(AppColors.textPrimaryDark)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppColors.textTertiaryDark),
              const SizedBox(width: 6),
              Text('Submitted by ${item.submitterName}', style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
              const SizedBox(width: 12),
              const Icon(Icons.email_outlined, size: 14, color: AppColors.textTertiaryDark),
              const SizedBox(width: 6),
              Text(item.submitterEmail, style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
            ],
          ),
          if (item.reviewNote != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notes_outlined, size: 14, color: AppColors.textTertiaryDark),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.reviewNote!, style: AppTypography.bodySmall(AppColors.textSecondaryDark))),
                ],
              ),
            ),
          ],
          if (item.status == 'pending') ...[
            const SizedBox(height: 14),
            const Divider(color: AppColors.borderDark, height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                FWButton(
                  label: 'Approve',
                  icon: Icons.check_rounded,
                  variant: FWButtonVariant.success,
                  onPressed: onApprove,
                  size: FWButtonSize.small,
                ),
                const SizedBox(width: 10),
                FWButton(
                  label: 'Reject',
                  icon: Icons.close_rounded,
                  variant: FWButtonVariant.danger,
                  onPressed: () => onReject('Content does not meet MIL standards.'),
                  size: FWButtonSize.small,
                ),
                const Spacer(),
                FWButton(
                  label: 'Preview Scenario',
                  icon: Icons.visibility_outlined,
                  variant: FWButtonVariant.ghost,
                  onPressed: () {},
                  size: FWButtonSize.small,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
