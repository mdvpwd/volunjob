import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_theme.dart';

/// Logo VolunJob yang dipakai di header Beranda, sidebar desktop, onboarding
/// dan layar login. Gambarnya diambil dari folder `assets/` (lihat
/// [AppAssets]); kalau file aset gagal dimuat, otomatis jatuh ke logo ikon
/// bawaan sehingga layar tidak pernah kosong.
class AppLogo extends StatelessWidget {
  /// Lebar = tinggi logo.
  final double size;

  /// `true` untuk dipakai di atas panel gradien/gelap (mis. panel branding
  /// desktop): tampil sebagai hati putih di dalam kotak putih transparan.
  final bool onDark;

  const AppLogo({super.key, this.size = 34, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return onDark ? _buildOnDark() : _buildDefault(context);
  }

  Widget _buildDefault(BuildContext context) {
    final colors = context.colors;
    return Image.asset(
      AppAssets.logoMark,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colors.primaryLight, colors.primaryDark]),
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: Icon(Icons.favorite, color: Colors.white, size: size * 0.5),
      ),
    );
  }

  Widget _buildOnDark() {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Image.asset(
        AppAssets.logoMarkWhite,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.favorite, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
