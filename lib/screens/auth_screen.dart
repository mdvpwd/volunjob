import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/responsive.dart';
import 'main_shell.dart';

class AuthScreen extends StatefulWidget {
  final bool startInLogin;
  const AuthScreen({super.key, this.startInLogin = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late bool _isLogin = widget.startInLogin;
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _showComingSoon(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Masuk dengan $provider belum tersedia di demo ini.')),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _submitting = false);

    final appState = AppStateScope.of(context);
    appState.updateProfile(
      name: _isLogin ? null : _nameCtrl.text,
      email: _emailCtrl.text,
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: context.isDesktop ? _buildDesktop(context, colors) : _buildMobile(context, colors),
    );
  }

  Widget _buildDesktop(BuildContext context, VolunJobColors colors) {
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
                const Text(
                  'Satu Akun,\nSejuta Dampak.',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 420,
                  child: Text(
                    'Satu profil VolunJob untuk melamar kerja atau bergabung aksi relawan '
                    'di ratusan organisasi terverifikasi.',
                    style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.6),
                  ),
                ),
                const SizedBox(height: 32),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AuthStatBadge(icon: Icons.groups, label: '10rb+ Pengguna'),
                    _AuthStatBadge(icon: Icons.verified, label: '120+ Organisasi'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: colors.pageBackground,
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Form(
                              key: _formKey,
                              child: _buildFormBody(context, colors),
                            ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primaryLight, colors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 17,
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
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 12),
              _buildFormBody(context, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormBody(BuildContext context, VolunJobColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'GEN Z IMPACT SPACE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Column(
                    key: ValueKey(_isLogin),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLogin
                            ? 'Selamat datang kembali!'
                            : 'Yuk, mulai perjalanan impact-mu bareng VolunJob!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLogin
                            ? 'Masuk untuk lanjut cari proyek relawan & karier impianmu.'
                            : 'Bikin akun secepat kilat, langsung gas cari proyek relawan & karier impianmu.',
                        style: TextStyle(fontSize: 14, color: colors.textSecondary, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                OutlinedButton.icon(
                  onPressed: () => _showComingSoon('Google'),
                  icon: Text(
                    'G',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: colors.primary,
                    ),
                  ),
                  label: const Text('Masuk dengan Google'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _showComingSoon('Apple'),
                  icon: const Icon(Icons.apple, size: 20),
                  label: const Text('Masuk dengan Apple'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    side: BorderSide.none,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'ATAU',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.border)),
                  ],
                ),
                const SizedBox(height: 20),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  child: _isLogin
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: _nameCtrl,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Nama lengkap kamu',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (!_isLogin && (value == null || value.trim().isEmpty)) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                ),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'nama@kamu.com',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email tidak boleh kosong';
                    if (!value.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Password kamu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                    if (value.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_isLogin ? 'Masuk' : 'Daftar Sekarang'),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
                        style: TextStyle(fontSize: 13, color: colors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin ? 'Daftar' : 'Masuk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Dengan mendaftar, kamu menyetujui Ketentuan Layanan & Kebijakan Privasi kami.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: colors.textMuted, height: 1.5),
                  ),
                ],
      ],
    );
  }
}

class _AuthStatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AuthStatBadge({required this.icon, required this.label});

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
          Icon(icon, size: 14, color: Colors.white),
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
