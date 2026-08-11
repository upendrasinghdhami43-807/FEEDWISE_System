import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import 'sidebar.dart';

// ─── Admin Layout ─────────────────────────────────────────────────────────────
// Sidebar (desktop/web) + content area

class AdminLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
  });

  @override
  ConsumerState<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends ConsumerState<AdminLayout> {
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    if (isMobile) {
      return _MobileLayout(child: widget.child, title: widget.title, actions: widget.actions);
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: Row(
        children: [
          // Sidebar
          StudioSidebar(
            isCollapsed: _sidebarCollapsed,
            onToggle: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                _TopBar(
                  title: widget.title,
                  actions: widget.actions,
                  onMenuTap: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
                ),

                // Content
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mobile Layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends ConsumerWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const _MobileLayout({required this.child, required this.title, this.actions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCardDark,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: actions,
        iconTheme: const IconThemeData(color: AppColors.textSecondaryDark),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surfaceCardDark,
        child: const StudioSidebar(),
      ),
      body: child,
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onMenuTap;

  const _TopBar({required this.title, this.actions, this.onMenuTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.surfaceCardDark,
        border: Border(bottom: BorderSide(color: AppColors.borderDark, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Page title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          // Action buttons
          if (actions != null) ...actions!.map((a) => Padding(padding: const EdgeInsets.only(left: 8), child: a)),

          const SizedBox(width: 12),

          // Notification bell
          _NotificationBell(),

          const SizedBox(width: 8),

          // User chip
          if (user != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.heroGradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        user.name.split(' ').take(2).map((p) => p[0]).join().toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.name.split(' ').first,
                    style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textTertiaryDark),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 22),
          color: AppColors.textSecondaryDark,
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.secondary400,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
