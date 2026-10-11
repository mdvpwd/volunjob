# Folder `assets/` — VolunJob

Tempat semua berkas statis yang ikut dibundel ke dalam aplikasi (gambar, ikon,
dll). Panduan ini untuk menambah aset baru ke aplikasi.

## Struktur

```
assets/
├── icons/                  # ikon kustom (PNG) — masih kosong, siap diisi
└── images/
    ├── logo/               # logo_mark.png, logo_mark_white.png
    └── onboarding/         # onboarding_1.png … onboarding_3.png
```

Gambar yang ditaruh langsung di `assets/images/` juga ikut terbawa (folder itu
sudah terdaftar di `pubspec.yaml`).

## Cara menambah aset baru

1. **Taruh filenya** di folder yang sesuai, mis. `assets/images/banner_relawan.png`.
   Pakai nama huruf kecil tanpa spasi (`banner_relawan.png`, bukan `Banner Relawan.png`).
2. **Pastikan foldernya terdaftar** di `pubspec.yaml`. Folder yang sudah ada tidak
   perlu diubah. Kalau membuat **sub-folder baru** (mis. `assets/images/banner/`),
   tambahkan barisnya:
   ```yaml
   flutter:
     assets:
       - assets/images/
       - assets/images/logo/
       - assets/images/onboarding/
       - assets/icons/
       - assets/images/banner/   # ← contoh sub-folder baru
   ```
   > Flutter **tidak rekursif**: mendaftarkan `assets/images/` hanya memuat file
   > yang langsung ada di dalamnya, bukan isi sub-foldernya.
3. **Daftarkan path-nya** di `lib/constants/app_assets.dart`:
   ```dart
   static const String bannerRelawan = 'assets/images/banner_relawan.png';
   ```
4. **Pakai di UI**:
   ```dart
   Image.asset(AppAssets.bannerRelawan, fit: BoxFit.cover)
   ```
5. Jalankan `flutter pub get`, lalu **restart penuh** aplikasi (stop lalu `flutter run`
   lagi — *hot reload* tidak mengenali aset baru).

## Tips

- **Format**: PNG untuk ilustrasi/logo transparan, JPG untuk foto. SVG butuh package
  tambahan (`flutter_svg`).
- **Ukuran**: usahakan di bawah ±300 KB per gambar supaya aplikasi tetap ringan.
- **Resolusi layar berbeda**: kalau perlu versi tajam untuk layar rapat, Flutter
  mendukung folder varian `2.0x/` dan `3.0x/` di sebelah file aslinya
  (mis. `assets/images/2.0x/logo.png`) — tidak perlu ubah kode.
- Selalu beri `errorBuilder` pada `Image.asset` seperti di `lib/widgets/app_logo.dart`
  supaya layar tidak error kalau file aset hilang/salah nama.
