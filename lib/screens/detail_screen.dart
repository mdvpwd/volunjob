import 'package:flutter/material.dart';

import '../models/opportunity.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/feedback_sheet.dart';

class DetailScreen extends StatelessWidget {
  final Opportunity opportunity;
  const DetailScreen({super.key, required this.opportunity});

  Color _accent(BuildContext context) {
    final colors = context.colors;
    return opportunity.type == OpportunityType.job ? colors.primary : colors.success;
  }

  (Color, Color) _tone(BuildContext context, ChipTone tone) {
    final colors = context.colors;
    switch (tone) {
      case ChipTone.success:
        return (colors.successBg, colors.onSuccess);
      case ChipTone.info:
        return (colors.primary.withOpacity(0.10), colors.primary);
      case ChipTone.warning:
        return (colors.warningBg, colors.onWarning);
      case ChipTone.danger:
        return (colors.dangerBg, colors.danger);
      case ChipTone.neutral:
        return (colors.surfaceAlt, colors.textSecondary);
    }
  }

  Future<void> _apply(BuildContext context) async {
    final appState = AppStateScope.of(context);
    appState.applyTo(opportunity.id);
    final isJob = opportunity.type == OpportunityType.job;
    await showSuccessSheet(
      context,
      color: _accent(context),
      title: isJob ? 'Lamaran terkirim!' : 'Berhasil gabung aksi!',
      message: isJob
          ? 'Lamaranmu untuk "${opportunity.title}" sudah diteruskan ke ${opportunity.orgName}.'
          : 'Kamu resmi terdaftar di "${opportunity.title}". Sampai jumpa di lokasi, ya!',
    );
  }

  Widget _buildHero(BuildContext context, VolunJobColors colors, bool isJob) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isJob
              ? [colors.primaryDark, colors.primary, const Color(0xFF0F172A)]
              : [colors.success, colors.primary, const Color(0xFF0F172A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (opportunity.featuredBadge != null)
                _Pill(label: opportunity.featuredBadge!, icon: Icons.star),
              if (opportunity.urgentLabel != null) ...[
                const SizedBox(width: 8),
                _Pill(label: opportunity.urgentLabel!, dot: true),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (opportunity.eyebrow != null)
            Text(
              opportunity.eyebrow!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Colors.white70,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            opportunity.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: opportunity.orgIconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(opportunity.orgIcon, size: 16, color: opportunity.orgIconFg),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  opportunity.orgName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (opportunity.orgVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, size: 15, color: Colors.white),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    VolunJobColors colors,
    bool isJob,
    Color accent,
    double progress,
  ) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${opportunity.joined} dari ${opportunity.quota} '
                  '${isJob ? 'pendaftar' : 'relawan'} bergabung',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ),
              Text(
                '${(progress * 100).round()}% Kuota',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colors.surfaceAlt,
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, VolunJobColors colors, bool isJob) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(icon: Icons.place_outlined, label: 'Lokasi', value: opportunity.location),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Komitmen waktu',
            value: opportunity.commitment,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.payments_outlined,
            label: isJob ? 'Kompensasi' : 'Insentif',
            value: opportunity.compensation,
          ),
        ],
      ),
    );
  }

  Widget _buildChipsCard(BuildContext context, VolunJobColors colors) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: opportunity.chips.map((chip) {
              final (bg, fg) = _tone(context, chip.tone);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(chip.icon, size: 12, color: fg),
                    const SizedBox(width: 4),
                    Text(
                      chip.label,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context, VolunJobColors colors, bool isJob) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isJob ? 'Deskripsi Pekerjaan' : 'Tentang Aksi Ini',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.description,
            style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.6),
          ),
          const SizedBox(height: 10),
          Text(
            'Diselenggarakan oleh ${opportunity.orgName}'
            '${opportunity.orgVerified ? ' — organisasi terverifikasi di VolunJob.' : '.'}',
            style: TextStyle(fontSize: 13, color: colors.textMuted, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContent(
    BuildContext context,
    VolunJobColors colors,
    bool isJob,
    Color accent,
    double? progress,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(context, colors, isJob),
          const SizedBox(height: 20),
          if (progress != null) ...[
            _buildProgressCard(context, colors, isJob, accent, progress),
            const SizedBox(height: 14),
          ],
          _buildInfoCard(context, colors, isJob),
          const SizedBox(height: 14),
          _buildChipsCard(context, colors),
          const SizedBox(height: 14),
          _buildDescriptionCard(context, colors, isJob),
          const SizedBox(height: 14),
          Text(opportunity.metaInfo, style: TextStyle(fontSize: 12, color: colors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildDesktopContent(
    BuildContext context,
    VolunJobColors colors,
    bool isJob,
    Color accent,
    double? progress,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(context, colors, isJob),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildChipsCard(context, colors),
                        const SizedBox(height: 16),
                        _buildDescriptionCard(context, colors, isJob),
                        const SizedBox(height: 14),
                        Text(
                          opportunity.metaInfo,
                          style: TextStyle(fontSize: 12, color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (progress != null) ...[
                          _buildProgressCard(context, colors, isJob, accent, progress),
                          const SizedBox(height: 16),
                        ],
                        _buildInfoCard(context, colors, isJob),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final appState = AppStateScope.of(context);
    final accent = _accent(context);
    final isJob = opportunity.type == OpportunityType.job;
    final progress = opportunity.progress;
    final desktop = context.isDesktop;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: colors.pageBackground,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tautan disalin ke clipboard.')),
                  );
                },
                icon: Icon(Icons.ios_share, color: colors.textPrimary),
              ),
              AnimatedBuilder(
                animation: appState,
                builder: (context, _) {
                  final saved = appState.isBookmarked(opportunity.id);
                  return IconButton(
                    onPressed: () => appState.toggleBookmark(opportunity.id),
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      color: saved ? accent : colors.textPrimary,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: desktop
                ? _buildDesktopContent(context, colors, isJob, accent, progress)
                : _buildMobileContent(context, colors, isJob, accent, progress),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 1080 : double.infinity),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: AnimatedBuilder(
                animation: appState,
                builder: (context, _) {
                  final saved = appState.isBookmarked(opportunity.id);
                  final applied = appState.isApplied(opportunity.id);
                  return Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => appState.toggleBookmark(opportunity.id),
                          child: Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: colors.border),
                              borderRadius: BorderRadius.circular(16),
                              color: saved ? accent.withOpacity(0.08) : colors.surface,
                            ),
                            child: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_border,
                              color: saved ? accent : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: applied ? null : () => _apply(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: applied ? colors.surfaceAlt : accent,
                              foregroundColor: applied ? colors.textSecondary : Colors.white,
                              disabledBackgroundColor: colors.surfaceAlt,
                              disabledForegroundColor: colors.textSecondary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  applied ? 'Kamu Sudah Terdaftar' : opportunity.ctaLabel,
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(width: 6),
                                Icon(applied ? Icons.check_circle : Icons.bolt, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: colors.textMuted)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool dot;
  const _Pill({required this.label, this.icon, this.dot = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: dot ? Colors.red.withOpacity(0.28) : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon!, size: 13, color: const Color(0xFFFCD34D)),
          if (dot)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle),
            ),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}
