import 'package:flutter/material.dart';

import '../models/opportunity.dart';
import '../theme/app_theme.dart';

/// The pill-shaped "Kerja / Relawan" segmented control shown at the top of
/// the home feed. Switching segments swaps both the accent color (blue for
/// jobs, emerald for volunteering) and the underlying data set.
class ModeToggle extends StatelessWidget {
  final OpportunityType value;
  final ValueChanged<OpportunityType> onChanged;

  const ModeToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isJob = value == OpportunityType.job;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                label: 'Kerja',
                icon: Icons.work_outline,
                selected: isJob,
                activeColor: colors.primary,
                onTap: () => onChanged(OpportunityType.job),
              ),
            ),
            Expanded(
              child: _Segment(
                label: 'Relawan',
                icon: Icons.volunteer_activism,
                selected: !isJob,
                activeColor: colors.success,
                onTap: () => onChanged(OpportunityType.volunteer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color activeColor;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : colors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : colors.textSecondary,
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
