import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

// Every screen decides its own layout via `context.isDesktop`
// (see theme/responsive.dart) — a real multi-column desktop layout above
// the breakpoint, the original single-column mobile layout below it. So
// there's no app-wide "shrink everything into a phone-width card" wrapper
// here; each screen fills the window properly at every size.

void main() {
  runApp(const VolunJobApp());
}

class VolunJobApp extends StatefulWidget {
  const VolunJobApp({super.key});

  @override
  State<VolunJobApp> createState() => _VolunJobAppState();
}

class _VolunJobAppState extends State<VolunJobApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
      // The Builder below reads AppStateScope with `.of(context)`, which
      // registers it as a dependent — so this subtree (and therefore
      // MaterialApp's `themeMode`) rebuilds whenever AppState changes,
      // e.g. when the dark-mode switch on the profile screen is toggled.
      child: Builder(
        builder: (context) {
          final appState = AppStateScope.of(context);
          return MaterialApp(
            title: 'VolunJob',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: appState.themeMode,
            home: const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
