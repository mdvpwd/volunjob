import 'package:flutter/material.dart';

/// The two feed modes the app supports: paid careers ("Kerja") and
/// volunteer initiatives ("Relawan"). Almost every screen branches its
/// color accent and copy off this enum.
enum OpportunityType { job, volunteer }

/// Semantic color tone for an [InfoChip]. The actual colors are resolved
/// against the current [VolunJobColors] at render time so chips stay
/// legible in both light and dark mode.
enum ChipTone { success, info, warning, neutral, danger }

/// A small colored metadata pill, e.g. "Remote", "Rp 9 - 14 jt / bln".
class InfoChip {
  final String label;
  final IconData icon;
  final ChipTone tone;

  const InfoChip({
    required this.label,
    required this.icon,
    this.tone = ChipTone.neutral,
  });
}

/// A single job or volunteer listing shown on the home feed, discover
/// results, activity lists and the detail screen.
class Opportunity {
  final String id;
  final OpportunityType type;

  /// Featured items render as the big hero/story card at the top of a feed.
  final bool featured;

  final String orgName;
  final bool orgVerified;
  final IconData orgIcon;
  final Color orgIconBg;
  final Color orgIconFg;

  final String title;

  /// Small uppercase caption shown above the title on a featured card.
  final String? eyebrow;

  /// e.g. "91% Cocok" — AI match badge shown on some standard cards.
  final String? matchLabel;

  /// e.g. "Segera" / "Batas 2 Hari" — status pill on standard cards.
  final String? statusLabel;
  final ChipTone statusTone;

  /// e.g. "Unggulan Hari Ini" / "Aksi Unggulan" — badge on featured cards.
  final String? featuredBadge;

  /// e.g. "Mendesak" / "Mendesak • Sisa 3 Hari" — urgency badge.
  final String? urgentLabel;

  /// Small right-aligned note under the header of a featured card,
  /// e.g. "Batas 2 hari" or a location.
  final String? sideNote;

  final List<InfoChip> chips;
  final String description;

  /// Footer caption, e.g. "Diposting 1 hari lalu • 14 pelamar".
  final String metaInfo;

  final String ctaLabel;

  final int? joined;
  final int? quota;

  /// Free-form tags used to match against quick-filter chips.
  final List<String> tags;

  final String location;
  final String commitment;
  final String compensation;

  const Opportunity({
    required this.id,
    required this.type,
    this.featured = false,
    required this.orgName,
    this.orgVerified = false,
    required this.orgIcon,
    required this.orgIconBg,
    required this.orgIconFg,
    required this.title,
    this.eyebrow,
    this.matchLabel,
    this.statusLabel,
    this.statusTone = ChipTone.warning,
    this.featuredBadge,
    this.urgentLabel,
    this.sideNote,
    required this.chips,
    required this.description,
    required this.metaInfo,
    required this.ctaLabel,
    this.joined,
    this.quota,
    this.tags = const [],
    required this.location,
    required this.commitment,
    required this.compensation,
  });

  double? get progress =>
      (joined != null && quota != null && quota! > 0) ? joined! / quota! : null;
}
