import 'package:flutter/material.dart';

import '../models/opportunity.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/opportunity_card.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/user_avatar.dart';
import 'detail_screen.dart';
import 'main_shell.dart';

class _FilterOption {
  final String label;
  final IconData icon;
  final String? tag;
  const _FilterOption(this.label, this.icon, this.tag);
}

const _jobFilters = [
  _FilterOption('Semua', Icons.dashboard_outlined, null),
  _FilterOption('WFA / Remote', Icons.home_work_outlined, 'remote'),
  _FilterOption('Urgent', Icons.bolt, 'urgent'),
  _FilterOption('Part-time', Icons.schedule_outlined, 'part-time'),
  _FilterOption('Lingkungan', Icons.eco, 'lingkungan'),
  _FilterOption('Pendidikan', Icons.school_outlined, 'pendidikan'),
];

const _volunteerFilters = [
  _FilterOption('Semua Aksi', Icons.volunteer_activism, null),
  _FilterOption('Lingkungan & Alam', Icons.eco, 'lingkungan'),
  _FilterOption('Edukasi & Anak', Icons.school_outlined, 'edukasi'),
  _FilterOption('Bantuan Pangan', Icons.soup_kitchen, 'pangan'),
  _FilterOption('Hewan & Satwa', Icons.pets, 'satwa'),
  _FilterOption('Akhir Pekan', Icons.calendar_month, 'akhir-pekan'),
  _FilterOption('Sertifikat Resmi', Icons.verified_outlined, 'sertifikat'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedTag;

  void _setMode(OpportunityType mode, AppState appState) {
    appState.setFeedMode(mode);
    setState(() => _selectedTag = null);
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feed diperbarui — ada peluang baru hari ini!')),
    );
  }

  void _openNotifications() {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary),
                ),
                const SizedBox(height: 14),
                _NotificationTile(
                  icon: Icons.bolt,
                  color: colors.primary,
                  title: 'Lamaranmu dilihat perekrut',
                  subtitle: 'Yayasan Sehat Bangsa membuka profilmu untuk "Lead Desainer UI/UX".',
                  time: '2 jam lalu',
                ),
                _NotificationTile(
                  icon: Icons.volunteer_activism,
                  color: colors.success,
                  title: 'Kuota aksi hampir penuh',
                  subtitle: '"Restorasi Terumbu Karang & Pesisir" tersisa 12 kuota lagi.',
                  time: '5 jam lalu',
                ),
                _NotificationTile(
                  icon: Icons.celebration_outlined,
                  color: colors.warning,
                  title: 'Selamat datang di VolunJob!',
                  subtitle: 'Lengkapi profilmu supaya rekomendasi makin cocok.',
                  time: 'Kemarin',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cardFor(BuildContext context, Opportunity o) {
    return OpportunityCard(
      opportunity: o,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailScreen(opportunity: o)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final isJob = appState.feedMode == OpportunityType.job;
    final source = isJob ? appState.jobs : appState.volunteers;
    final filtered = _selectedTag == null
        ? source
        : source.where((o) => o.tags.contains(_selectedTag)).toList();
    final filters = isJob ? _jobFilters : _volunteerFilters;
    final initials = appState.userName.trim().isEmpty
        ? '?'
        : appState.userName.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: context.isDesktop
          ? _buildDesktopBody(context, appState, colors, isJob, filtered, filters)
          : _buildMobileBody(context, appState, colors, isJob, filtered, filters, initials),
    );
  }

  Widget _buildDesktopBody(
    BuildContext context,
    AppState appState,
    VolunJobColors colors,
    bool isJob,
    List<Opportunity> filtered,
    List<_FilterOption> filters,
  ) {
    final featured = filtered.where((o) => o.featured).toList();
    final standard = filtered.where((o) => !o.featured).toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: colors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 32, 40, 56),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hai, ${appState.userName}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isJob
                                    ? 'Siap bikin impact hari ini?'
                                    : 'Siap beraksi & berdampak sosial hari ini?',
                                style: TextStyle(fontSize: 14, color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        _DesktopSearchField(
                          onTap: () => MainShellController.of(context).goToTab(1),
                        ),
                        const SizedBox(width: 12),
                        _HeaderIconButton(
                          icon: Icons.notifications_none,
                          showDot: true,
                          onTap: _openNotifications,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 280,
                          child: ModeToggle(
                            value: appState.feedMode,
                            onChanged: (mode) => _setMode(mode, appState),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final f in filters)
                                _FilterChipButton(
                                  label: f.label,
                                  icon: f.icon,
                                  selected: _selectedTag == f.tag,
                                  accent: isJob ? colors.primary : colors.success,
                                  onTap: () => setState(() => _selectedTag = f.tag),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 44, color: colors.textMuted),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada yang cocok dengan filter ini.',
                                style: TextStyle(color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      for (final o in featured) ...[
                        _cardFor(context, o),
                        const SizedBox(height: 20),
                      ],
                      ResponsiveCardGrid(
                        children: [for (final o in standard) _cardFor(context, o)],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBody(
    BuildContext context,
    AppState appState,
    VolunJobColors colors,
    bool isJob,
    List<Opportunity> filtered,
    List<_FilterOption> filters,
    String initials,
  ) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                  const Spacer(),
                  _HeaderIconButton(
                    icon: Icons.search,
                    onTap: () => MainShellController.of(context).goToTab(1),
                  ),
                  const SizedBox(width: 8),
                  _HeaderIconButton(
                    icon: Icons.notifications_none,
                    showDot: true,
                    onTap: _openNotifications,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: colors.primary,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hai, ${appState.userName}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isJob
                                    ? 'Siap bikin impact hari ini?'
                                    : 'Siap beraksi & berdampak sosial hari ini?',
                                style: TextStyle(fontSize: 13, color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => MainShellController.of(context).goToTab(3),
                          child: Stack(
                            children: [
                              UserAvatar(
                                photo: appState.profilePhoto,
                                initials: initials,
                                radius: 22,
                                background: colors.primary,
                                foreground: Colors.white,
                                fontSize: 16,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: colors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors.pageBackground, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ModeToggle(
                      value: appState.feedMode,
                      onChanged: (mode) => _setMode(mode, appState),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final f = filters[i];
                          final selected = _selectedTag == f.tag;
                          return _FilterChipButton(
                            label: f.label,
                            icon: f.icon,
                            selected: selected,
                            accent: isJob ? colors.primary : colors.success,
                            onTap: () => setState(() => _selectedTag = f.tag),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 40, color: colors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada yang cocok dengan filter ini.',
                              style: TextStyle(color: colors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ...filtered.map(
                        (o) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _cardFor(context, o),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}

class _DesktopSearchField extends StatelessWidget {
  final VoidCallback onTap;
  const _DesktopSearchField({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 280,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.search, size: 18, color: colors.textMuted),
              const SizedBox(width: 8),
              Text(
                'Cari posisi, organisasi...',
                style: TextStyle(fontSize: 13, color: colors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;
  const _HeaderIconButton({required this.icon, required this.onTap, this.showDot = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.border)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 20, color: colors.textSecondary),
              if (showDot)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 1.5),
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

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: selected ? accent : colors.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? Colors.transparent : colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: selected ? Colors.white : colors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 2),
                Text(time, style: TextStyle(fontSize: 11, color: colors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
