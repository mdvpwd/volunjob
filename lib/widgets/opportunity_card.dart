import 'package:flutter/material.dart';

import '../models/opportunity.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'feedback_sheet.dart';

Color _accentOf(BuildContext context, OpportunityType type) {
  final colors = context.colors;
  return type == OpportunityType.job ? colors.primary : colors.success;
}

(Color, Color) _tonePalette(BuildContext context, ChipTone tone) {
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

Future<void> _handleApply(BuildContext context, Opportunity opportunity) async {
  final appState = AppStateScope.of(context);
  appState.applyTo(opportunity.id);
  final isJob = opportunity.type == OpportunityType.job;
  await showSuccessSheet(
    context,
    color: _accentOf(context, opportunity.type),
    title: isJob ? 'Lamaran terkirim!' : 'Berhasil gabung aksi!',
    message: isJob
        ? 'Lamaranmu untuk "${opportunity.title}" sudah diteruskan ke ${opportunity.orgName}. Pantau statusnya di tab Aktivitas.'
        : 'Kamu resmi terdaftar di "${opportunity.title}". Sampai jumpa di lokasi, ya!',
  );
}

class _ChipPill extends StatelessWidget {
  final InfoChip chip;
  const _ChipPill(this.chip);

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _tonePalette(context, chip.tone);
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
  }
}

class _BookmarkButton extends StatelessWidget {
  final String id;
  const _BookmarkButton(this.id);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final saved = appState.isBookmarked(id);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => appState.toggleBookmark(id),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(12),
            color: saved ? colors.primary.withOpacity(0.08) : Colors.transparent,
          ),
          child: Icon(
            saved ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: saved ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  final Opportunity opportunity;
  const _CtaButton(this.opportunity);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final applied = appState.isApplied(opportunity.id);
    final accent = _accentOf(context, opportunity.type);

    return ElevatedButton(
      onPressed: applied ? null : () => _handleApply(context, opportunity),
      style: ElevatedButton.styleFrom(
        backgroundColor: applied ? colors.surfaceAlt : accent,
        foregroundColor: applied ? colors.textSecondary : Colors.white,
        disabledBackgroundColor: colors.surfaceAlt,
        disabledForegroundColor: colors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 0,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            applied ? 'Terdaftar' : opportunity.ctaLabel,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 4),
          Icon(applied ? Icons.check_circle : Icons.bolt, size: 15),
        ],
      ),
    );
  }
}

/// Renders either the hero [_FeaturedCard] or a compact [_StandardCard]
/// depending on [Opportunity.featured].
class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;

  const OpportunityCard({super.key, required this.opportunity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return opportunity.featured
        ? _FeaturedCard(opportunity: opportunity, onTap: onTap)
        : _StandardCard(opportunity: opportunity, onTap: onTap);
  }
}

class _FeaturedCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;
  const _FeaturedCard({required this.opportunity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = _accentOf(context, opportunity.type);
    final isJob = opportunity.type == OpportunityType.job;
    final gradientColors = isJob
        ? [colors.primaryDark, colors.primary, const Color(0xFF0F172A)]
        : [colors.success, colors.primary, const Color(0xFF0F172A)];
    final progress = opportunity.progress;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (opportunity.featuredBadge != null)
                          _TranslucentPill(
                            icon: Icons.star,
                            iconColor: const Color(0xFFFCD34D),
                            label: opportunity.featuredBadge!,
                          ),
                        if (opportunity.urgentLabel != null)
                          _TranslucentPill(
                            dotColor: const Color(0xFFF87171),
                            label: opportunity.urgentLabel!,
                            background: Colors.red.withOpacity(0.28),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
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
                    const SizedBox(height: 2),
                    Text(
                      opportunity.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: opportunity.orgIconBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(opportunity.orgIcon, size: 16, color: opportunity.orgIconFg),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  opportunity.orgName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (opportunity.orgVerified) ...[
                                const SizedBox(width: 3),
                                Icon(Icons.verified, size: 14, color: accent),
                              ],
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (opportunity.sideNote != null)
                          Text(
                            opportunity.sideNote!,
                            style: TextStyle(fontSize: 12, color: colors.textSecondary),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: opportunity.chips.map(_ChipPill.new).toList(),
                    ),
                    if (progress != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: TextStyle(fontSize: 12, color: colors.textSecondary),
                              children: [
                                TextSpan(
                                  text: '${opportunity.joined}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text: ' dari ${opportunity.quota} '
                                      '${isJob ? 'pendaftar' : 'relawan'} bergabung',
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}% Kuota',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
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
                    const SizedBox(height: 12),
                    Divider(color: colors.border, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            opportunity.metaInfo,
                            style: TextStyle(fontSize: 12, color: colors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _BookmarkButton(opportunity.id),
                        const SizedBox(width: 8),
                        _CtaButton(opportunity),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TranslucentPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Color? dotColor;
  final Color? background;

  const _TranslucentPill({
    required this.label,
    this.icon,
    this.iconColor,
    this.dotColor,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon!, size: 13, color: iconColor ?? Colors.white),
          if (dotColor != null)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StandardCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;
  const _StandardCard({required this.opportunity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: opportunity.orgIconBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(opportunity.orgIcon, size: 24, color: opportunity.orgIconFg),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.orgName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          opportunity.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (opportunity.matchLabel != null) ...[
                    const SizedBox(width: 8),
                    _StatusPill(
                      label: opportunity.matchLabel!,
                      icon: Icons.auto_awesome,
                      tone: ChipTone.info,
                    ),
                  ] else if (opportunity.statusLabel != null) ...[
                    const SizedBox(width: 8),
                    _StatusPill(
                      label: opportunity.statusLabel!,
                      icon: Icons.notification_important,
                      tone: opportunity.statusTone,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: opportunity.chips.map(_ChipPill.new).toList(),
              ),
              const SizedBox(height: 10),
              Text(
                opportunity.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colors.textSecondary, height: 1.45),
              ),
              const SizedBox(height: 12),
              Divider(color: colors.border, height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      opportunity.metaInfo,
                      style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _BookmarkButton(opportunity.id),
                  const SizedBox(width: 8),
                  _CtaButton(opportunity),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final ChipTone tone;
  const _StatusPill({required this.label, required this.icon, required this.tone});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _tonePalette(context, tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
        ],
      ),
    );
  }
}
