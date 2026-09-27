import 'package:flutter/material.dart';

import '../models/opportunity.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/opportunity_card.dart';
import '../widgets/responsive_grid.dart';
import 'detail_screen.dart';

class _Category {
  final String label;
  final IconData icon;
  final String query;
  const _Category(this.label, this.icon, this.query);
}

const _categories = [
  _Category('Lingkungan', Icons.eco, 'lingkungan'),
  _Category('Pendidikan', Icons.school_outlined, 'edukasi'),
  _Category('Kesehatan', Icons.local_hospital_outlined, 'kesehatan'),
  _Category('Pangan Sosial', Icons.soup_kitchen, 'pangan'),
  _Category('Hewan & Satwa', Icons.pets, 'satwa'),
  _Category('Remote / WFA', Icons.home_work_outlined, 'remote'),
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Opportunity> _search(AppState appState) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return appState.allOpportunities;
    return appState.allOpportunities.where((o) {
      final haystack = [
        o.title,
        o.orgName,
        o.description,
        o.location,
        ...o.tags,
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final results = _search(appState);
    final desktop = context.isDesktop;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1100 : double.infinity),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, desktop ? 16 : 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    'Eksplorasi',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Cari peluang kerja & aksi relawan yang cocok untukmu.',
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Cari posisi, organisasi, atau lokasi...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final c = _categories[i];
                  final active = _query.toLowerCase() == c.query;
                  return Material(
                    color: active ? colors.primary : colors.surface,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        final next = active ? '' : c.query;
                        setState(() => _query = next);
                        _searchCtrl.value = TextEditingValue(
                          text: next,
                          selection: TextSelection.collapsed(offset: next.length),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: active ? Colors.transparent : colors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(c.icon, size: 15, color: active ? Colors.white : colors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              c.label,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: active ? Colors.white : colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
                const SizedBox(height: 12),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 44, color: colors.textMuted),
                                const SizedBox(height: 12),
                                Text(
                                  'Tidak ditemukan',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Coba kata kunci lain, ya.',
                                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : desktop
                          ? SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                              child: ResponsiveCardGrid(
                                children: [
                                  for (final o in results)
                                    OpportunityCard(
                                      opportunity: o,
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => DetailScreen(opportunity: o)),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                              itemCount: results.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, i) {
                                final o = results[i];
                                return OpportunityCard(
                                  opportunity: o,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => DetailScreen(opportunity: o)),
                                  ),
                                );
                              },
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
