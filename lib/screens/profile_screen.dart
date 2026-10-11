import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import '../widgets/user_avatar.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _editProfile(BuildContext context, AppState appState) {
    final nameCtrl = TextEditingController(text: appState.userName);
    final emailCtrl = TextEditingController(text: appState.userEmail);
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama lengkap'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Format email tidak valid' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                appState.updateProfile(name: nameCtrl.text, email: emailCtrl.text);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context, {required String title, required String message}) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message, style: const TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppState appState) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Data lamaran & simpanan demo di perangkat ini akan direset.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: context.colors.danger),
            onPressed: () {
              appState.resetSession();
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto(BuildContext context, AppState appState) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return; // user cancelled — not an error
      final Uint8List bytes = await picked.readAsBytes();
      appState.setProfilePhoto(bytes);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka foto itu. Coba foto lain, ya.')),
      );
    }
  }

  void _showPhotoOptions(BuildContext context, AppState appState) {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library_outlined, color: colors.primary),
                  title: const Text('Pilih Foto'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pickPhoto(context, appState);
                  },
                ),
                if (appState.profilePhoto != null)
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: colors.danger),
                    title: const Text('Hapus Foto'),
                    onTap: () {
                      appState.setProfilePhoto(null);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, VolunJobColors colors, AppState appState, String initials) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              UserAvatar(
                photo: appState.profilePhoto,
                initials: initials,
                radius: 34,
                background: colors.primary,
                foreground: Colors.white,
                fontSize: 24,
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Material(
                  color: colors.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showPhotoOptions(context, appState),
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            appState.userName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(appState.userEmail, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _editProfile(context, appState),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit Profil'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, VolunJobColors colors, AppState appState) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.assignment_turned_in_outlined,
            color: colors.primary,
            value: '${appState.appliedOpportunities.length}',
            label: 'Dilamar',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.bookmark_border,
            color: colors.success,
            value: '${appState.bookmarkedOpportunities.length}',
            label: 'Disimpan',
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, VolunJobColors colors, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengaturan',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.textMuted),
        ),
        const SizedBox(height: 8),
        _SettingsGroup(
          children: [
            SwitchListTile(
              value: appState.notificationsEnabled,
              onChanged: appState.toggleNotifications,
              title: const Text('Notifikasi'),
              subtitle: const Text('Update lamaran & aksi relawan'),
              secondary: Icon(Icons.notifications_none, color: colors.textSecondary),
            ),
            Divider(color: colors.border, height: 1),
            SwitchListTile(
              value: appState.themeMode == ThemeMode.dark,
              onChanged: appState.setDarkMode,
              title: const Text('Mode Gelap'),
              subtitle: const Text('Sesuaikan tampilan aplikasi'),
              secondary: Icon(Icons.dark_mode_outlined, color: colors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SettingsGroup(
          children: [
            ListTile(
              leading: Icon(Icons.language, color: colors.textSecondary),
              title: const Text('Bahasa'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Indonesia', style: TextStyle(color: colors.textSecondary)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: colors.textMuted),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bahasa lain segera hadir di VolunJob.')),
                );
              },
            ),
            Divider(color: colors.border, height: 1),
            ListTile(
              leading: Icon(Icons.help_outline, color: colors.textSecondary),
              title: const Text('Bantuan & Dukungan'),
              trailing: Icon(Icons.chevron_right, color: colors.textMuted),
              onTap: () => _showInfoDialog(
                context,
                title: 'Bantuan & Dukungan',
                message:
                    'Butuh bantuan? Hubungi tim kami di support@volunjob.id atau lihat Pusat Bantuan di aplikasi utama.',
              ),
            ),
            Divider(color: colors.border, height: 1),
            ListTile(
              leading: Icon(Icons.info_outline, color: colors.textSecondary),
              title: const Text('Tentang VolunJob'),
              trailing: Icon(Icons.chevron_right, color: colors.textMuted),
              onTap: () => _showInfoDialog(
                context,
                title: 'Tentang VolunJob',
                message:
                    'VolunJob v1.0.0 — demo aplikasi pencari kerja & relawan berdampak sosial, '
                    'dibangun dengan Flutter berdasarkan desain Stitch.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, appState),
            icon: Icon(Icons.logout, color: colors.danger, size: 18),
            label: Text('Keluar', style: TextStyle(color: colors.danger)),
            style: OutlinedButton.styleFrom(side: BorderSide(color: colors.danger.withOpacity(0.4))),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final colors = context.colors;
    final initials =
        appState.userName.trim().isEmpty ? '?' : appState.userName.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: context.isDesktop
            ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(40, 24, 40, 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 340,
                              child: Column(
                                children: [
                                  _buildProfileCard(context, colors, appState, initials),
                                  const SizedBox(height: 16),
                                  _buildStatsRow(context, colors, appState),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: _buildSettingsSection(context, colors, appState),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildProfileCard(context, colors, appState, initials),
                  const SizedBox(height: 14),
                  _buildStatsRow(context, colors, appState),
                  const SizedBox(height: 20),
                  _buildSettingsSection(context, colors, appState),
                ],
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
