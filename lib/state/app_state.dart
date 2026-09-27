import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/opportunity.dart';

/// Single source of truth for everything that needs to survive navigation
/// between screens: the signed-in user, dark-mode preference, which feed
/// mode is active, and which listings the user bookmarked / applied to.
///
/// Kept deliberately dependency-free (no external state-management
/// package) — just a [ChangeNotifier] exposed through [AppStateScope], an
/// [InheritedNotifier]. Any widget that reads `AppStateScope.of(context)`
/// during build automatically rebuilds whenever [notifyListeners] fires.
class AppState extends ChangeNotifier {
  AppState()
      : jobs = MockData.jobs,
        volunteers = MockData.volunteers;

  final List<Opportunity> jobs;
  final List<Opportunity> volunteers;

  String userName = 'Maman';
  String userEmail = 'maman@volunjob.id';

  /// Raw bytes of the picked profile photo, kept in memory only (this is a
  /// demo app with no backend to upload to). Null means "no photo" — the UI
  /// falls back to an initials avatar.
  Uint8List? profilePhoto;

  ThemeMode themeMode = ThemeMode.light;
  bool notificationsEnabled = true;

  OpportunityType feedMode = OpportunityType.job;

  final Set<String> _bookmarkedIds = <String>{};
  final Set<String> _appliedIds = <String>{};

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);
  bool isApplied(String id) => _appliedIds.contains(id);

  List<Opportunity> get allOpportunities => [...jobs, ...volunteers];

  List<Opportunity> get bookmarkedOpportunities => allOpportunities
      .where((o) => _bookmarkedIds.contains(o.id))
      .toList(growable: false);

  List<Opportunity> get appliedOpportunities => allOpportunities
      .where((o) => _appliedIds.contains(o.id))
      .toList(growable: false);

  Opportunity byId(String id) => allOpportunities.firstWhere((o) => o.id == id);

  void toggleBookmark(String id) {
    if (!_bookmarkedIds.remove(id)) {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }

  void applyTo(String id) {
    _appliedIds.add(id);
    notifyListeners();
  }

  void setFeedMode(OpportunityType mode) {
    if (feedMode == mode) return;
    feedMode = mode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void updateProfile({String? name, String? email}) {
    if (name != null && name.trim().isNotEmpty) userName = name.trim();
    if (email != null && email.trim().isNotEmpty) userEmail = email.trim();
    notifyListeners();
  }

  /// Sets or clears (pass null) the profile photo.
  void setProfilePhoto(Uint8List? bytes) {
    profilePhoto = bytes;
    notifyListeners();
  }

  /// Resets session-only state on logout, keeping the mock catalog intact.
  void resetSession() {
    _bookmarkedIds.clear();
    _appliedIds.clear();
    feedMode = OpportunityType.job;
    profilePhoto = null;
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
