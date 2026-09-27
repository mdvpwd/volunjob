import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Beranda'),
    (icon: Icons.search, activeIcon: Icons.search, label: 'Eksplorasi'),
    (icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: 'Aktivitas'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(0.97),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = index == currentIndex;
              return _NavButton(
                icon: selected ? item.activeIcon : item.icon,
                label: item.label,
                selected: selected,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primary : colors.textSecondary;
    return Semantics(
      label: label,
      selected: selected,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 16 : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
