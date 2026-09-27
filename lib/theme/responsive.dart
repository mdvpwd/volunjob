import 'package:flutter/widgets.dart';

/// Width-based breakpoints. `desktop` is where there's enough room for a
/// persistent sidebar plus multi-column content (a typical laptop window
/// and up); anything narrower keeps the original mobile-first, single
/// column, bottom-nav layout.
class Breakpoints {
  Breakpoints._();
  static const double tablet = 700;
  static const double desktop = 980;
}

extension ResponsiveX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isDesktop => screenWidth >= Breakpoints.desktop;
  bool get isMobile => screenWidth < Breakpoints.tablet;
}
