# VolunJob — Flutter App

Implementasi Flutter dari desain Stitch **"VolunJob"** (volunteer & job finder
app untuk Gen Z). Dibangun sebagai aplikasi Flutter asli (bukan HTML/CSS),
jadi bisa langsung di-*build* ke Web, Android, iOS, atau desktop dari satu
basis kode yang sama.

## Layout responsif (mobile & desktop)

Setiap layar sekarang punya **dua tampilan nyata**, bukan satu tampilan
mobile yang di-kecilin ke tengah layar desktop:

- **< 980px** (HP/tablet sempit) → layout mobile asli: bottom navigation,
  satu kolom, kartu penuh lebar.
- **≥ 980px** (laptop/desktop) → layout desktop asli: sidebar navigasi di
  kiri, header dengan search bar, konten multi-kolom, kartu tersusun grid,
  dan halaman onboarding/login pakai split-screen (panel branding di kiri,
  form di kanan) — pola umum yang dipakai website/dashboard modern.

Breakpoint-nya ada di `lib/theme/responsive.dart` (`context.isDesktop`),
kalau mau diubah tinggal edit angka `980` di situ.

## Yang sudah diimplementasikan

Desain sumber hanya berisi 4 layar statis (onboarding, login/register, dan
2 varian beranda). Semua tombol pada desain tersebut **sudah fungsional**,
dan ditambah beberapa layar & fitur susulan (bagian "Improvisasi" di bawah)
supaya alurnya terasa seperti aplikasi utuh, bukan sekadar mockup.

- **Onboarding** — carousel 3 slide (swipe & tap dot), tombol Lewati/Lanjut.
- **Login & Register** — satu layar dengan toggle mode, validasi form,
  show/hide password, tombol Google/Apple (placeholder).
- **Beranda** — toggle mode **Kerja ↔ Relawan** (mengganti warna aksen, data,
  dan filter secara live), filter chip, kartu unggulan (progress kuota),
  bookmark, tombol "Daftar Cepat" / "Gabung Aksi" dengan konfirmasi, pull-to-
  refresh, dan panel notifikasi.
- **Eksplorasi** — pencarian live di semua lowongan/aksi + kategori cepat.
- **Aktivitas** — tab "Dilamar" & "Disimpan", terhubung ke aksi bookmark/apply
  dari layar lain.
- **Profil** — edit nama/email, **ganti/hapus foto profil** (lewat
  `image_picker`, jalan di web & mobile), statistik pribadi, **mode gelap
  fungsional**, notifikasi toggle, dan logout (reset sesi). Foto profil ikut
  tampil di header Beranda dan sidebar desktop.
- **Detail** — halaman detail lengkap untuk tiap lowongan/aksi relawan.

## Struktur proyek

```
lib/
├── main.dart                  # entry point, tema light/dark
├── theme/app_theme.dart       # design tokens (warna, tipografi Plus Jakarta Sans)
├── state/app_state.dart       # state global (tanpa package eksternal)
├── models/opportunity.dart    # model data lowongan/aksi relawan
├── data/mock_data.dart        # data contoh (9 listing, siap diganti API asli)
├── screens/                   # 8 layar aplikasi
└── widgets/                   # kartu, toggle, bottom nav, dll (reusable)
```

## Cara menjalankan

1. Pastikan [Flutter SDK](https://docs.flutter.dev/get-started/install)
   sudah terpasang (`flutter doctor` untuk cek).
2. Di folder proyek ini, jalankan:
   ```bash
   flutter pub get
   ```
3. Jalankan sebagai web (paling cepat untuk preview):
   ```bash
   flutter run -d chrome
   ```
   Atau untuk build production web:
   ```bash
   flutter build web
   ```
   Hasilnya ada di `build/web/`, tinggal di-*deploy* ke hosting statis
   (Firebase Hosting, Vercel, Netlify, GitHub Pages, dll).
4. Untuk Android/iOS, gunakan device/emulator lalu `flutter run` seperti biasa.

> Font **Plus Jakarta Sans** diambil dari Google Fonts via package
> `google_fonts` — koneksi internet dibutuhkan saat pertama kali build/run
> (font akan di-cache otomatis sesudahnya).

## Catatan implementasi

- **State management**: sengaja tanpa Provider/Riverpod/Bloc — hanya
  `ChangeNotifier` + `InheritedNotifier` bawaan Flutter (`AppState` +
  `AppStateScope`), supaya proyek mudah dibaca dan di-*extend* tanpa
  dependensi tambahan. Gampang diganti ke Riverpod/Bloc kalau proyek
  berkembang.
- **Data**: `lib/data/mock_data.dart` sengaja dipisah dari UI. Untuk
  menyambungkan ke API asli, tinggal ganti isi `MockData.jobs` /
  `MockData.volunteers` dengan hasil `http`/`dio` call yang di-*map* ke
  `Opportunity`.
- **Ikon**: memakai Material Icons bawaan Flutter (bukan Material Symbols /
  gambar dari desain asli) supaya tidak perlu bundel aset font tambahan.
- **Dark mode**: nyata, bukan sekadar UI — coba toggle di Profil → Mode Gelap.

## Improvisasi di luar desain asli

Desain Stitch yang diberikan hanya mencakup 4 layar. Untuk melengkapi jadi
alur aplikasi yang utuh, ditambahkan:

- Layar **Eksplorasi**, **Aktivitas**, **Profil**, dan **Detail** (tidak ada
  di desain asli).
- Bottom navigation bar 4 tab.
- Sistem bookmark & "sudah melamar" yang konsisten lintas layar.
- Mode gelap penuh (light/dark theme).
- Panel notifikasi & dialog konfirmasi logout/edit profil.
- Pencarian & filter kategori yang benar-benar memfilter data.
