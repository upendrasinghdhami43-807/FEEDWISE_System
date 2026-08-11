import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/user_model.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_text_field.dart';
import '../../shared/widgets/fw_avatar.dart';
import '../../shared/widgets/fw_badge.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _searchCtrl = TextEditingController();
  UserRole? _roleFilter;
  String _searchQuery = '';

  List<UserModel> get _filteredUsers {
    var users = MockData.allUsers;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      users = users.where((u) => u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q)).toList();
    }
    if (_roleFilter != null) {
      users = users.where((u) => u.role == _roleFilter).toList();
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;
    return AdminLayout(
      title: 'Users',
      actions: [
        FWButton(
          label: 'Export CSV',
          icon: Icons.download_outlined,
          variant: FWButtonVariant.ghost,
          onPressed: () {},
          size: FWButtonSize.small,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary row
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      Row(children: [
                        _RoleCountCard(role: 'All', count: MockData.allUsers.length, color: AppColors.primary500),
                        const SizedBox(width: 12),
                        _RoleCountCard(role: 'Admin', count: MockData.allUsers.where((u) => u.role == UserRole.admin).length, color: AppColors.secondary400),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        _RoleCountCard(role: 'Teacher', count: MockData.allUsers.where((u) => u.role == UserRole.teacher).length, color: AppColors.tertiary400),
                        const SizedBox(width: 12),
                        _RoleCountCard(role: 'Student', count: MockData.allUsers.where((u) => u.role == UserRole.student).length, color: AppColors.warning),
                      ]),
                    ],
                  );
                }
                return Row(
                  children: [
                    _RoleCountCard(role: 'All', count: MockData.allUsers.length, color: AppColors.primary500),
                    const SizedBox(width: 12),
                    _RoleCountCard(role: 'Admin', count: MockData.allUsers.where((u) => u.role == UserRole.admin).length, color: AppColors.secondary400),
                    const SizedBox(width: 12),
                    _RoleCountCard(role: 'Teacher', count: MockData.allUsers.where((u) => u.role == UserRole.teacher).length, color: AppColors.tertiary400),
                    const SizedBox(width: 12),
                    _RoleCountCard(role: 'Student', count: MockData.allUsers.where((u) => u.role == UserRole.student).length, color: AppColors.warning),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Filters row
            LayoutBuilder(
              builder: (context, constraints) {
                final searchField = FWSearchField(
                  hint: 'Search by name or email...',
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                );
                final filters = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _RoleFilterBtn(label: 'All', selected: _roleFilter == null, onTap: () => setState(() => _roleFilter = null)),
                      const SizedBox(width: 8),
                      _RoleFilterBtn(label: 'Admin', selected: _roleFilter == UserRole.admin, onTap: () => setState(() => _roleFilter = UserRole.admin)),
                      const SizedBox(width: 8),
                      _RoleFilterBtn(label: 'Teacher', selected: _roleFilter == UserRole.teacher, onTap: () => setState(() => _roleFilter = UserRole.teacher)),
                      const SizedBox(width: 8),
                      _RoleFilterBtn(label: 'Student', selected: _roleFilter == UserRole.student, onTap: () => setState(() => _roleFilter = UserRole.student)),
                    ],
                  ),
                );
                
                if (constraints.maxWidth < 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [searchField, const SizedBox(height: 12), filters],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    filters,
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 900,
                child: FWCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceElevatedDark,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: _TableHeader('User')),
                            Expanded(flex: 2, child: _TableHeader('Email')),
                            Expanded(child: _TableHeader('Role')),
                            Expanded(child: _TableHeader('Level')),
                            Expanded(child: _TableHeader('Streak')),
                            Expanded(child: _TableHeader('Last Active')),
                            SizedBox(width: 80, child: _TableHeader('Actions')),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderDark),
                      // Rows
                      ...users.asMap().entries.map((entry) {
                        final i = entry.key;
                        final user = entry.value;
                        return Column(
                          children: [
                            _UserRow(user: user),
                            if (i < users.length - 1)
                              const Divider(height: 1, color: AppColors.borderDark),
                          ],
                        );
                      }),
                      if (users.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: Text('No users found', style: TextStyle(color: AppColors.textSecondaryDark))),
                        ),
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
}

class _RoleCountCard extends StatelessWidget {
  final String role;
  final int count;
  final Color color;
  const _RoleCountCard({required this.role, required this.count, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(role, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
          const Spacer(),
          Text('$count', style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}

class _RoleFilterBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RoleFilterBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary500.withValues(alpha: 0.15) : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: selected ? AppColors.primary500 : AppColors.borderDark),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.primary400 : AppColors.textSecondaryDark,
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ),
  );
}

class _TableHeader extends StatelessWidget {
  final String label;
  const _TableHeader(this.label);

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
  );
}

class _UserRow extends StatefulWidget {
  final UserModel user;
  const _UserRow({required this.user});

  @override
  State<_UserRow> createState() => _UserRowState();
}

class _UserRowState extends State<_UserRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final lastActive = user.lastActiveDate;
    final String lastActiveStr = lastActive == null
      ? 'Never'
      : DateTime.now().difference(lastActive).inMinutes < 60
        ? '${DateTime.now().difference(lastActive).inMinutes}m ago'
        : DateTime.now().difference(lastActive).inHours < 24
          ? '${DateTime.now().difference(lastActive).inHours}h ago'
          : '${DateTime.now().difference(lastActive).inDays}d ago';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
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
                  FWAvatar(name: user.name, size: 36, color: user.avatarColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppTypography.titleSmall(AppColors.textPrimaryDark)),
                        Text(user.levelTitle, style: AppTypography.labelSmall(AppColors.textTertiaryDark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(user.email, style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
            ),
            Expanded(child: FWRoleBadge(role: user.role.name)),
            Expanded(
              child: Row(
                children: [
                  Text('Lv.${user.level}', style: const TextStyle(color: AppColors.primary400, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Text('${user.xp} XP', style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 14, color: AppColors.secondary400),
                  const SizedBox(width: 4),
                  Text('${user.currentStreak}d', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              child: Text(lastActiveStr, style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
            ),
            SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    color: AppColors.textSecondaryDark,
                    onPressed: () {},
                    tooltip: 'View profile',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    color: AppColors.primary400,
                    onPressed: () {},
                    tooltip: 'Edit user',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
