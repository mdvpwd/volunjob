import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import 'auth_screen.dart';

class _Slide {
  final String eyebrow;
  final String titleLine1;
  final String titleLine2;
  final String subtitle;
  final IconData icon;
  final String badgeTopLeft;
  final String badgeBottomRight;

  const _Slide({
    required this.eyebrow,
    required this.titleLine1,
    required this.titleLine2,
    required this.subtitle,
    required this.icon,
    required this.badgeTopLeft,
    required this.badgeBottomRight,
  });
}

const _slides = [
  _Slide(
    eyebrow: 'GEN Z IMPACT SPACE',
    titleLine1: 'Kerja Santai,',
    titleLine2: 'Impact Maksimal.',
    subtitle:
        'Temukan proyek kerelawanan seru & karier berdampak sosial impianmu dalam hitungan menit.',
    icon: Icons.volunteer_activism,
    badgeTopLeft: 'Verified Impact',
    badgeBottomRight: '500+ Proyek Aktif',
  ),
  _Slide(
    eyebrow: 'SATU APLIKASI',
    titleLine1: 'Sejuta Peluang,',
    titleLine2: 'Satu Genggaman.',
    subtitle:
        'Jelajahi ratusan proyek relawan dan lowongan karier berdampak sosial dari organisasi terverifikasi.',
    icon: Icons.explore,
    badgeTopLeft: '120+ Organisasi',
    badgeBottomRight: '4.9/5 Rating',
  ),
  _Slide(
    eyebrow: 'GABUNG SEKARANG',
    titleLine1: 'Daftar, Berdampak,',
    titleLine2: 'Berkembang Bareng.',
    subtitle:
        'Cukup satu profil untuk melamar kerja atau bergabung aksi relawan secepat kilat, kapan saja.',
    icon: Icons.rocket_launch,
    badgeTopLeft: 'Daftar Cepat',
    badgeBottomRight: '10rb+ Pengguna',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _slides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToAuth({bool startInLogin = false}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AuthScreen(startInLogin: startInLogin)),
    );
  }

  /// Mobile drives the current slide through the swipeable [PageController];
  /// desktop has no PageView (see [_buildDesktop]) so it just jumps state.
  void _goToSlide(int index) {
    if (context.isDesktop) {
      setState(() => _page = index);
    } else {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleNext() {
    if (_isLast) {
      _goToAuth();
    } else {
      _goToSlide(_page + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.surface,
      body: context.isDesktop ? _buildDesktop(context, colors) : _buildMobile(context, colors),
    );
  }

  Widget _buildDesktop(BuildContext context, VolunJobColors colors) {
    final slide = _slides[_page];

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(56),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primaryDark, colors.primary, colors.success],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'VolunJob',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 56),
                Container(
                  width: 92,
                  height: 92,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Icon(slide.icon, color: Colors.white, size: 46),
                ),
                const SizedBox(height: 28),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(text: '${slide.titleLine1}\n'),
                      TextSpan(text: slide.titleLine2, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 420,
                  child: Text(
                    slide.subtitle,
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.6),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _WhiteBadge(icon: Icons.check_circle, label: slide.badgeTopLeft),
                    _WhiteBadge(icon: Icons.circle, iconSize: 8, label: slide.badgeBottomRight),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: colors.surface,
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 32, 0),
                      child: TextButton(
                        onPressed: () => _goToAuth(),
                        style: TextButton.styleFrom(foregroundColor: colors.textSecondary),
                        child: const Text('Lewati'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide.eyebrow,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${slide.titleLine1} ${slide.titleLine2}',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                slide.subtitle,
                                style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.6),
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: List.generate(_slides.length, (i) {
                                  final active = i == _page;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: () => _goToSlide(i),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 220),
                                        width: active ? 26 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: active ? colors.primary : colors.border,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _handleNext,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_isLast ? 'Mulai Sekarang' : 'Lanjut'),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Text(
                                    'Sudah punya akun? ',
                                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                  ),
                                  GestureDetector(
                                    onTap: () => _goToAuth(startInLogin: true),
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colors.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, VolunJobColors colors) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.primaryLight, colors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 20,
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
                TextButton(
                  onPressed: () => _goToAuth(),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textSecondary,
                    backgroundColor: colors.surfaceAlt,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Lewati'),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _SlideView(slide: _slides[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _page;
                return GestureDetector(
                  onTap: () => _goToSlide(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? colors.primary : colors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isLast ? 'Mulai Sekarang' : 'Lanjut'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => _goToAuth(startInLogin: true),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteBadge extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  const _WhiteBadge({required this.icon, required this.label, this.iconSize = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Cap the illustration instead of letting AspectRatio grow with
        // whatever width the window happens to offer — on a wide desktop
        // browser that could otherwise blow past the available height.
        final illustrationSize = constraints.maxWidth.clamp(0, 260).toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: illustrationSize,
                  height: illustrationSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colors.primary.withOpacity(0.12),
                                colors.success.withOpacity(0.12),
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(slide.icon, size: 88, color: colors.primary),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: _FloatingBadge(icon: Icons.check_circle, label: slide.badgeTopLeft),
                      ),
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: _FloatingBadge(
                          icon: Icons.circle,
                          iconSize: 8,
                          label: slide.badgeBottomRight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  slide.eyebrow,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      height: 1.25,
                    ),
                    children: [
                      TextSpan(text: '${slide.titleLine1}\n'),
                      TextSpan(text: slide.titleLine2, style: TextStyle(color: colors.primary)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  slide.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  const _FloatingBadge({required this.icon, required this.label, this.iconSize = 14});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: colors.success),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
