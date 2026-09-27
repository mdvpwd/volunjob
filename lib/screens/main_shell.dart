import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/user_avatar.dart';
import 'activity_screen.dart';
import 'discover_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Lets any descendant screen (e.g. the "search" icon on the home header,
/// or an empty-state button on the activity screen) switch bottom-nav tabs
/// without needing a callback threaded through every constructor.
class MainShellController extends InheritedWidget {
  final void Function(int index) goToTab;

  const MainShellController({super.key, required this.goToTab, required super.child});

  static MainShellController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MainShellController>();
    assert(scope != null, 'MainShellController not found in widget tree');
    return scope!;
  }

  @override
  bool updateShouldNotify(MainShellController oldWidget) => false;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    DiscoverScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final desktop = context.isDesktop;

    return MainShellController(
      goToTab: _goToTab,
      child: Scaffold(
        backgroundColor: colors.pageBackground,
        extendBody: !desktop,
        body: desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DesktopSidebar(currentIndex: _index, onTap: _goToTab),
                  Expanded(child: IndexedStack(index: _index, children: _screens)),
                ],
              )
            : IndexedStack(index: _index, children: _screens),
        bottomNavigationBar:
            desktop ? null : AppBottomNav(currentIndex: _index, onTap: _goToTab),
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _DesktopSidebar({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Beranda'),
    (icon: Icons.search, activeIcon: Icons.search, label: 'Eksplorasi'),
    (icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: 'Aktivitas'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final appState = AppStateScope.of(context);
    final initials =
        appState.userName.trim().isEmpty ? '?' : appState.userName.trim()[0].toUpperCase();

    return Container(
      width: 256,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        right: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [colors.primaryLight, colors.primaryDark]),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.white, size: 17),
                    ),
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                        children: [
                          const TextSpan(text: 'Volun'),
                          TextSpan(text: 'Job', style: TextStyle(color: colors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              for (int i = 0; i < _items.length; i++) ...[
                _SidebarItem(
                  icon: i == currentIndex ? _items[i].activeIcon : _items[i].icon,
                  label: _items[i].label,
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
                const SizedBox(height: 4),
              ],
              const Spacer(),
              Material(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onTap(3),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        UserAvatar(
                          photo: appState.profilePhoto,
                          initials: initials,
                          radius: 17,
                          background: colors.primary,
                          foreground: Colors.white,
                          fontSize: 13,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appState.userName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Lihat profil',
                                style: TextStyle(fontSize: 11, color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? colors.primary.withOpacity(0.10) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 21, color: selected ? colors.primary : colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? colors.primary : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
