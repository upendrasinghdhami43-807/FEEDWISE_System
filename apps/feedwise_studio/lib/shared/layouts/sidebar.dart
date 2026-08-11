import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/auth_provider.dart';

// ─── Nav Item Model ───────────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final List<UserRole>? allowedRoles;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  }) : allowedRoles = null;
}

const _adminNav = [
  _NavItem(label: 'Dashboard',   icon: Icons.dashboard_outlined,  activeIcon: Icons.dashboard,    route: '/dashboard'),
  _NavItem(label: 'Scenarios',   icon: Icons.article_outlined,    activeIcon: Icons.article,      route: '/scenarios'),
  _NavItem(label: 'Users',       icon: Icons.people_outline,      activeIcon: Icons.people,       route: '/users'),
  _NavItem(label: 'Analytics',   icon: Icons.bar_chart_outlined,  activeIcon: Icons.bar_chart,    route: '/analytics'),
  _NavItem(label: 'Moderation',  icon: Icons.shield_outlined,     activeIcon: Icons.shield,       route: '/moderation'),
  _NavItem(label: 'Settings',    icon: Icons.settings_outlined,   activeIcon: Icons.settings,     route: '/settings'),
];

const _teacherNav = [
  _NavItem(label: 'Dashboard',   icon: Icons.dashboard_outlined,  activeIcon: Icons.dashboard,    route: '/teacher'),
  _NavItem(label: 'Classes',     icon: Icons.class_outlined,      activeIcon: Icons.class_,       route: '/classes'),
  _NavItem(label: 'Students',    icon: Icons.people_outline,      activeIcon: Icons.people,       route: '/students'),
  _NavItem(label: 'Analytics',   icon: Icons.bar_chart_outlined,  activeIcon: Icons.bar_chart,    route: '/analytics'),
];

// ─── Sidebar ──────────────────────────────────────────────────────────────────

class StudioSidebar extends ConsumerStatefulWidget {
  final bool isCollapsed;
  final VoidCallback? onToggle;

  const StudioSidebar({
    super.key,
    this.isCollapsed = false,
    this.onToggle,
  });

  @override
  ConsumerState<StudioSidebar> createState() => _StudioSidebarState();
}

class _StudioSidebarState extends ConsumerState<StudioSidebar> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isAdmin = user?.role == UserRole.admin;
    final navItems = isAdmin ? _adminNav : _teacherNav;
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final w = widget.isCollapsed ? 72.0 : 240.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: w,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceCardDark,
          border: Border(right: BorderSide(color: AppColors.borderDark, width: 1)),
        ),
        child: Column(
          children: [
            // ─ Logo
            _buildLogo(w),

            const SizedBox(height: 8),

            // ─ Nav items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                itemCount: navItems.length,
                itemBuilder: (context, i) {
                  final item = navItems[i];
                  final isActive = currentRoute.startsWith(item.route);
                  return _NavTile(
                    item: item,
                    isActive: isActive,
                    isCollapsed: widget.isCollapsed,
                    onTap: () => context.go(item.route),
                  );
                },
              ),
            ),

            // ─ User profile
            _buildUserSection(user, w),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(double w) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.heroGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
          ),
          if (!widget.isCollapsed) ...[
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FEEDWISE',
                  style: AppTypography.wordmark(AppColors.textPrimaryDark),
                ),
                Text(
                  'Studio',
                  style: AppTypography.labelSmall(AppColors.primary400),
                ),
              ],
            ),
            const Spacer(),
            if (widget.onToggle != null)
              IconButton(
                icon: const Icon(Icons.menu_rounded, size: 20),
                color: AppColors.textTertiaryDark,
                onPressed: widget.onToggle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserSection(UserModel? user, double w) {
    if (user == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderDark, width: 1)),
      ),
      child: widget.isCollapsed
        ? _AvatarWidget(name: user.name)
        : Row(
            children: [
              _AvatarWidget(name: user.name),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTypography.labelMedium(AppColors.textPrimaryDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(user.role.name, style: AppTypography.labelSmall(AppColors.primary400)),
                  ],
                ),
              ),
              Consumer(
                builder: (context, ref, _) => IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  color: AppColors.textTertiaryDark,
                  tooltip: 'Sign out',
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Tooltip(
          message: widget.isCollapsed ? widget.item.label : '',
          preferBelow: false,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 12 : 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isActive
                  ? AppColors.primary500.withValues(alpha: 0.15)
                  : (_isHovered ? AppColors.surfaceElevatedDark : Colors.transparent),
                borderRadius: BorderRadius.circular(10),
                border: isActive
                  ? Border.all(color: AppColors.primary500.withValues(alpha: 0.3), width: 1)
                  : null,
              ),
              child: Row(
                mainAxisSize: widget.isCollapsed ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: widget.isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Icon(
                    isActive ? widget.item.activeIcon : widget.item.icon,
                    size: 20,
                    color: isActive ? AppColors.primary400 : AppColors.textSecondaryDark,
                  ),
                  if (!widget.isCollapsed) ...[
                    const SizedBox(width: 12),
                    Text(
                      widget.item.label,
                      style: TextStyle(
                        color: isActive ? AppColors.primary400 : AppColors.textSecondaryDark,
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (isActive) ...[
                      const Spacer(),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  final String name;
  const _AvatarWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(' ').take(2).map((p) => p[0]).join().toUpperCase();
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.heroGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}


