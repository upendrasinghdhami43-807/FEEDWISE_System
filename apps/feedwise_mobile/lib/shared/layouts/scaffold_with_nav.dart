import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/theme.dart';

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  static const _tabs = [
    _NavTab(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home, path: '/home'),
    _NavTab(label: 'Explore', icon: Icons.explore_outlined, activeIcon: Icons.explore, path: '/explore'),
    _NavTab(label: 'Play', icon: Icons.sports_esports_outlined, activeIcon: Icons.sports_esports, path: '/play'),
    _NavTab(label: 'Academy', icon: Icons.school_outlined, activeIcon: Icons.school, path: '/academy'),
    _NavTab(label: 'Me', icon: Icons.person_outline, activeIcon: Icons.person, path: '/me'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _getSelectedIndex(currentLocation);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (isWide) {
          return _WideLayout(child: child, selectedIndex: selectedIndex);
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: _BottomNav(
            selectedIndex: selectedIndex,
            onTap: (i) => context.go(_tabs[i].path),
          ),
        );
      },
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/play')) return 2;
    if (location.startsWith('/academy')) return 3;
    if (location.startsWith('/me')) return 4;
    return 0;
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderDark, width: 1)),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onTap,
        backgroundColor: AppColors.surfaceCardDark,
        elevation: 0,
        height: 64,
        destinations: ScaffoldWithNav._tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  selectedIcon: Icon(t.activeIcon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const _WideLayout({required this.child, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => context.go(ScaffoldWithNav._tabs[i].path),
            backgroundColor: AppColors.surfaceCardDark,
            extended: false,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('FW', style: AppTypography.brandWordmark.copyWith(color: AppColors.primary500)),
            ),
            destinations: ScaffoldWithNav._tabs
                .map((t) => NavigationRailDestination(
                      icon: Icon(t.icon),
                      selectedIcon: Icon(t.activeIcon),
                      label: Text(t.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(color: AppColors.borderDark, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavTab {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
  const _NavTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
}
