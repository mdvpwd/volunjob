import 'package:flutter/material.dart';

/// Lays [children] out in a single column on narrow screens, and in an
/// evenly-spaced multi-column grid once there's enough width — used for
/// opportunity cards on desktop. Row heights are whatever their tallest
/// card needs (no forced equal heights), which keeps this cheap and avoids
/// fighting the cards' natural, content-driven height.
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final double minCardWidth;
  final double spacing;
  final int maxColumns;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.minCardWidth = 340,
    this.spacing = 16,
    this.maxColumns = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final rawColumns = (width / (minCardWidth + spacing)).floor();
        final columns = rawColumns.clamp(1, maxColumns).toInt();

        if (columns <= 1) {
          return Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: spacing),
                children[i],
              ],
            ],
          );
        }

        final cardWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: cardWidth, child: child),
          ],
        );
      },
    );
  }
}
