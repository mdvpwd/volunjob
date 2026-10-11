/// Satu tempat untuk semua path aset (gambar, ikon, dll).
///
/// Kenapa dipusatkan di sini? Supaya tidak ada string path yang tersebar di
/// banyak file — kalau nama/folder aset berubah, cukup edit di sini. Dan kalau
/// kamu menambah aset baru, daftarkan konstantanya di bawah lalu pakai dengan:
///
/// ```dart
/// Image.asset(AppAssets.logoMark, width: 40)
/// ```
///
/// Ingat: folder aset harus terdaftar juga di `pubspec.yaml` (bagian
/// `flutter: assets:`). Panduan lengkap ada di `assets/README.md`.
class AppAssets {
  AppAssets._();

  // ── Logo ──────────────────────────────────────────────────────────────
  /// Logo lengkap (kotak gradien biru + hati putih) untuk latar terang/gelap.
  static const String logoMark = 'assets/images/logo/logo_mark.png';

  /// Hati putih polos (transparan) untuk dipasang di atas latar gradien/berwarna.
  static const String logoMarkWhite = 'assets/images/logo/logo_mark_white.png';

  // ── Ilustrasi onboarding ──────────────────────────────────────────────
  static const String onboarding1 = 'assets/images/onboarding/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding/onboarding_3.png';

  // ── Folder tempat menambah aset sendiri (belum ada isinya) ────────────
  // assets/images/  → foto/gambar umum (banner, cover, placeholder, dll)
  // assets/icons/   → ikon kustom (PNG)
}
