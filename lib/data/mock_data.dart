import 'package:flutter/material.dart';

import '../models/opportunity.dart';

/// Static demo catalog. In a real app this would come from an API — the
/// shape of [Opportunity] is deliberately API-friendly (flat, serializable
/// fields) so swapping this out for a network call later is a small change
/// contained to this one file.
class MockData {
  MockData._();

  static const _emeraldBg = Color(0xFFECFDF5);
  static const _emeraldFg = Color(0xFF047857);
  static const _blueBg = Color(0xFFEFF6FF);
  static const _blueFg = Color(0xFF2563EB);
  static const _amberBg = Color(0xFFFFFBEB);
  static const _amberFg = Color(0xFF92400E);

  static final List<Opportunity> jobs = [
    const Opportunity(
      id: 'job-1',
      type: OpportunityType.job,
      featured: true,
      orgName: 'Yayasan Samudera Sejahtera',
      orgVerified: true,
      orgIcon: Icons.eco,
      orgIconBg: _emeraldBg,
      orgIconFg: _emeraldFg,
      title: 'Program Officer Konservasi Pesisir',
      eyebrow: 'PROGRAM KARIER BAHARI',
      featuredBadge: 'Unggulan Hari Ini',
      urgentLabel: 'Mendesak',
      sideNote: 'Batas 2 hari',
      chips: [
        InfoChip(label: 'Rp 8 - 12 jt / bln', icon: Icons.payments, tone: ChipTone.success),
        InfoChip(label: 'Pulau Pari', icon: Icons.place_outlined),
        InfoChip(label: 'Full-time', icon: Icons.badge_outlined),
      ],
      description:
          'Pimpin kemitraan lapangan untuk program restorasi terumbu karang bersama 12 komunitas pesisir mitra.',
      metaInfo: 'Diposting 2 hari lalu • 21 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['urgent', 'lingkungan'],
      location: 'Pulau Pari, Kepulauan Seribu',
      commitment: 'Penuh waktu · di lapangan',
      compensation: 'Rp 8.000.000 – 12.000.000 / bulan',
    ),
    const Opportunity(
      id: 'job-2',
      type: OpportunityType.job,
      orgName: 'GreenEarth Nusantara',
      orgIcon: Icons.forest_outlined,
      orgIconBg: _emeraldBg,
      orgIconFg: _emeraldFg,
      title: 'Manajer Program Komunitas',
      statusLabel: 'Segera',
      statusTone: ChipTone.warning,
      chips: [
        InfoChip(label: 'Rp 9 - 14 jt / bln', icon: Icons.payments, tone: ChipTone.success),
        InfoChip(label: 'Remote', icon: Icons.home_work_outlined),
        InfoChip(label: 'Full-time', icon: Icons.badge_outlined),
      ],
      description:
          'Kelola aksi penanaman 50.000 bibit pohon dan supervisi 12 koordinator cabang komunitas daerah.',
      metaInfo: 'Diposting 1 hari lalu • 14 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['remote', 'lingkungan'],
      location: 'Remote (WFA)',
      commitment: 'Penuh waktu',
      compensation: 'Rp 9.000.000 – 14.000.000 / bulan',
    ),
    const Opportunity(
      id: 'job-3',
      type: OpportunityType.job,
      orgName: 'Yayasan Sehat Bangsa',
      orgIcon: Icons.local_hospital_outlined,
      orgIconBg: _blueBg,
      orgIconFg: _blueFg,
      title: 'Lead Desainer UI/UX Inklusif',
      matchLabel: '91% Cocok',
      chips: [
        InfoChip(label: 'Rp 12 - 18 jt / bln', icon: Icons.payments, tone: ChipTone.success),
        InfoChip(label: 'Hybrid (Jakarta)', icon: Icons.domain_outlined),
        InfoChip(label: 'Kontrak', icon: Icons.schedule_outlined),
      ],
      description:
          'Rancang sistem layanan navigasi kesehatan yang ramah disabilitas dan aksesibel bagi jutaan warga prasejahtera.',
      metaInfo: 'Diposting 4 jam lalu • 8 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['hybrid'],
      location: 'Hybrid — Jakarta Pusat',
      commitment: 'Kontrak 12 bulan',
      compensation: 'Rp 12.000.000 – 18.000.000 / bulan',
    ),
    const Opportunity(
      id: 'job-4',
      type: OpportunityType.job,
      orgName: 'Literasi Digital Indonesia',
      orgIcon: Icons.menu_book_outlined,
      orgIconBg: _blueBg,
      orgIconFg: _blueFg,
      title: 'Content & Campaign Specialist',
      statusLabel: 'Baru',
      statusTone: ChipTone.info,
      chips: [
        InfoChip(label: 'Rp 6 - 9 jt / bln', icon: Icons.payments, tone: ChipTone.success),
        InfoChip(label: 'Remote', icon: Icons.home_work_outlined),
        InfoChip(label: 'Part-time', icon: Icons.schedule_outlined),
      ],
      description:
          'Rancang konten kampanye edukasi literasi digital untuk pelajar di 50 sekolah mitra di seluruh Indonesia.',
      metaInfo: 'Diposting 6 jam lalu • 5 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['part-time', 'remote', 'pendidikan'],
      location: 'Remote (WFA)',
      commitment: 'Paruh waktu',
      compensation: 'Rp 6.000.000 – 9.000.000 / bulan',
    ),
  ];

  static final List<Opportunity> volunteers = [
    const Opportunity(
      id: 'vol-1',
      type: OpportunityType.volunteer,
      featured: true,
      orgName: 'Yayasan Bahari Lestari',
      orgVerified: true,
      orgIcon: Icons.eco,
      orgIconBg: _emeraldBg,
      orgIconFg: _emeraldFg,
      title: 'Restorasi Terumbu Karang & Pesisir',
      eyebrow: 'EKSPEDISI KONSERVASI BAHARI',
      featuredBadge: 'Aksi Unggulan',
      urgentLabel: 'Mendesak • Sisa 3 Hari',
      sideNote: 'Kepulauan Seribu',
      chips: [
        InfoChip(label: 'Insentif + Sertifikat', icon: Icons.card_membership, tone: ChipTone.success),
        InfoChip(label: 'Pulau Pari', icon: Icons.place_outlined),
        InfoChip(label: 'Sabtu–Minggu (12 Jam)', icon: Icons.schedule_outlined),
      ],
      description:
          'Bantu tim selam memasang media transplantasi karang dan edukasi warga pesisir soal konservasi laut.',
      metaInfo: 'Tersisa 12 kuota lagi',
      ctaLabel: 'Gabung Aksi',
      joined: 48,
      quota: 60,
      tags: ['lingkungan', 'sertifikat', 'akhir-pekan'],
      location: 'Pulau Pari, Kepulauan Seribu',
      commitment: 'Sabtu–Minggu, 12 jam',
      compensation: 'Insentif lapangan + sertifikat relawan',
    ),
    const Opportunity(
      id: 'vol-2',
      type: OpportunityType.volunteer,
      orgName: 'Komunitas Pangan Berbagi',
      orgIcon: Icons.soup_kitchen,
      orgIconBg: _amberBg,
      orgIconFg: _amberFg,
      title: 'Relawan Dapur Umum & Distribusi',
      statusLabel: 'Batas 2 Hari',
      statusTone: ChipTone.warning,
      chips: [
        InfoChip(label: 'Bantuan Sosial', icon: Icons.volunteer_activism, tone: ChipTone.success),
        InfoChip(label: 'Jakarta Selatan', icon: Icons.place_outlined),
        InfoChip(label: '4 Jam / Hari', icon: Icons.schedule_outlined),
        InfoChip(label: 'Makan Siang & Sertifikat', icon: Icons.restaurant),
      ],
      description:
          'Bantu siapkan 500 paket makanan bernutrisi dan salurkan langsung ke panti asuhan dan lansia prasejahtera.',
      metaInfo: 'Dibutuhkan 8 relawan lagi • 12 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['pangan', 'sertifikat'],
      location: 'Jakarta Selatan',
      commitment: '4 jam / hari',
      compensation: 'Makan siang + sertifikat relawan',
    ),
    const Opportunity(
      id: 'vol-3',
      type: OpportunityType.volunteer,
      orgName: 'Sahabat Literasi Cilik',
      orgIcon: Icons.local_library,
      orgIconBg: _blueBg,
      orgIconFg: _blueFg,
      title: 'Pengajar Kreatif & Teman Baca',
      statusLabel: 'Edukasi Anak',
      statusTone: ChipTone.info,
      chips: [
        InfoChip(label: 'Pendidikan', icon: Icons.school, tone: ChipTone.success),
        InfoChip(label: 'Muara Angke', icon: Icons.place_outlined),
        InfoChip(label: 'Weekend', icon: Icons.calendar_month),
        InfoChip(label: 'Workshop Kit', icon: Icons.palette_outlined),
      ],
      description:
          'Bimbing adik-adik belajar membaca cerita inspiratif dan melukis impian di taman bacaan binaan pesisir.',
      metaInfo: 'Dibutuhkan 5 relawan • 18 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['edukasi', 'akhir-pekan'],
      location: 'Muara Angke, Jakarta Utara',
      commitment: 'Akhir pekan, 3 jam',
      compensation: 'Workshop kit + sertifikat relawan',
    ),
    const Opportunity(
      id: 'vol-4',
      type: OpportunityType.volunteer,
      orgName: 'Pusaka Satwa Indonesia',
      orgIcon: Icons.pets,
      orgIconBg: _emeraldBg,
      orgIconFg: _emeraldFg,
      title: 'Relawan Rescue & Perawatan Kucing',
      statusLabel: 'Satwa',
      statusTone: ChipTone.success,
      chips: [
        InfoChip(label: 'Fauna & Satwa', icon: Icons.pets, tone: ChipTone.success),
        InfoChip(label: 'Tangerang', icon: Icons.place_outlined),
        InfoChip(label: 'Di Tempat', icon: Icons.badge_outlined),
        InfoChip(label: 'Medis Dasar', icon: Icons.medical_services_outlined),
      ],
      description:
          'Bantu dokter hewan membersihkan shelter, memberi makan hewan terlantar, dan sosialisasi program adopsi.',
      metaInfo: 'Dibutuhkan 4 relawan • 9 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['satwa'],
      location: 'Tangerang, Banten',
      commitment: 'Di tempat, fleksibel',
      compensation: 'Sertifikat relawan + transport lokal',
    ),
    const Opportunity(
      id: 'vol-5',
      type: OpportunityType.volunteer,
      orgName: 'Rumah Belajar Nusantara',
      orgIcon: Icons.auto_stories_outlined,
      orgIconBg: _blueBg,
      orgIconFg: _blueFg,
      title: 'Fasilitator Kelas Coding Anak',
      statusLabel: 'Sertifikat Resmi',
      statusTone: ChipTone.info,
      chips: [
        InfoChip(label: 'Edukasi & Anak', icon: Icons.school, tone: ChipTone.success),
        InfoChip(label: 'Bandung', icon: Icons.place_outlined),
        InfoChip(label: 'Weekend', icon: Icons.calendar_month),
      ],
      description:
          'Ajarkan dasar logika pemrograman lewat game block-coding untuk anak-anak usia 9-12 tahun.',
      metaInfo: 'Dibutuhkan 6 relawan • 10 pelamar',
      ctaLabel: 'Daftar Cepat',
      tags: ['edukasi', 'akhir-pekan', 'sertifikat'],
      location: 'Bandung, Jawa Barat',
      commitment: 'Akhir pekan, 2 jam',
      compensation: 'Sertifikat resmi terakreditasi',
    ),
  ];
}
