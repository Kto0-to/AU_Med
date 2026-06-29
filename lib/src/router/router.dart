import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icon_plus/icon_plus.dart';

import 'package:au_med/src/screens/today/today_screen.dart';
import 'package:au_med/src/screens/medications/all_medications_screen.dart';
import 'package:au_med/src/screens/medications/add_edit_medication_screen.dart';
import 'package:au_med/src/screens/medications/archive_screen.dart';
import 'package:au_med/src/screens/statistics/statistics_screen.dart';
import 'package:au_med/src/screens/dosage/dosage_history_screen.dart';
import 'package:au_med/src/screens/logs/edit_log_screen.dart';
import 'package:au_med/src/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigator,
  initialLocation: '/today',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(state: state, child: child),
      routes: [
        GoRoute(
          path: '/today',
          builder: (context, state) => const TodayScreen(),
        ),
        GoRoute(
          path: '/medications',
          builder: (context, state) => const AllMedicationsScreen(),
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/medications/add',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => const AddEditMedicationScreen(),
    ),
    GoRoute(
      path: '/medications/:id/edit',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => AddEditMedicationScreen(
        medicationId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/medications/:id/logs/:logId',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => EditLogScreen(
        medicationId: int.parse(state.pathParameters['id']!),
        logId: int.parse(state.pathParameters['logId']!),
      ),
    ),
    GoRoute(
      path: '/medications/:id/dosage-history',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => DosageHistoryScreen(
        medicationId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/archive',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => const ArchiveScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigator,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const MainShell({super.key, required this.child, required this.state});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int get _currentIndex {
    final location = widget.state.matchedLocation;
    if (location.startsWith('/medications')) return 0;
    if (location.startsWith('/today')) return 1;
    if (location.startsWith('/statistics')) return 2;
    return 1;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/medications');
        break;
      case 1:
        context.go('/today');
        break;
      case 2:
        context.go('/statistics');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = _currentIndex;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withAlpha(60),
              width: 0.5,
            ),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Bootstrap.capsule_pill,
                  activeIcon: Bootstrap.capsule_pill,
                  isActive: index == 0,
                  onTap: () => _onTap(0, context),
                ),
                _NavItem(
                  icon: Bootstrap.calendar,
                  activeIcon: Bootstrap.calendar_date_fill,
                  isActive: index == 1,
                  onTap: () => _onTap(1, context),
                ),
                _NavItem(
                  icon: Bootstrap.bar_chart,
                  activeIcon: Bootstrap.bar_chart_fill,
                  isActive: index == 2,
                  onTap: () => _onTap(2, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(isActive ? activeIcon : icon, color: color, size: 28),
      ),
    );
  }
}
