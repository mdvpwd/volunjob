import 'package:flutter/material.dart';

import '../models/opportunity.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/opportunity_card.dart';
import '../widgets/responsive_grid.dart';
import 'detail_screen.dart';
import 'main_shell.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final desktop = context.isDesktop;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.pageBackground,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: desktop ? 1100 : double.infinity),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Row(
                      children: [
                        Text(
                          'Aktivitas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    labelColor: colors.primary,
                    unselectedLabelColor: colors.textSecondary,
                    indicatorColor: colors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    tabs: [
                      Tab(text: 'Dilamar (${appState.appliedOpportunities.length})'),
                      Tab(text: 'Disimpan (${appState.bookmarkedOpportunities.length})'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _ActivityList(
                          items: appState.appliedOpportunities,
                          emptyIcon: Icons.assignment_outlined,
                          emptyTitle: 'Belum ada lamaran',
                          emptyMessage: 'Peluang yang kamu lamar atau ikuti akan muncul di sini.',
                        ),
                        _ActivityList(
                          items: appState.bookmarkedOpportunities,
                          emptyIcon: Icons.bookmark_border,
                          emptyTitle: 'Belum ada yang disimpan',
                          emptyMessage:
                              'Ketuk ikon bookmark pada peluang untuk menyimpannya di sini.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<Opportunity> items;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;

  const _ActivityList({
    required this.items,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: colors.surfaceAlt, shape: BoxShape.circle),
                child: Icon(emptyIcon, size: 32, color: colors.textMuted),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => MainShellController.of(context).goToTab(0),
                child: const Text('Jelajahi Sekarang'),
              ),
            ],
          ),
        ),
      );
    }

    if (context.isDesktop) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 60),
        child: ResponsiveCardGrid(
          children: [
            for (final o in items)
              OpportunityCard(
                opportunity: o,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DetailScreen(opportunity: o)),
                ),
              ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final o = items[i];
        return OpportunityCard(
          opportunity: o,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DetailScreen(opportunity: o)),
          ),
        );
      },
    );
  }
}
