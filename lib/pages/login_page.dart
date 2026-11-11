import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/auth_widgets.dart';
import 'main_shell.dart';
import 'register_page.dart';

// Halaman pertama saat aplikasi dibuka.
// Belum ada fungsi login asli: tombol "Masuk" langsung membuka Beranda.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(),
              const SizedBox(height: 24),

              const AuthHero(
                label: 'RAWAT KULIT, SAYANGI DIRI',
                judul: 'Selamat datang\nkembali.',
                deskripsi:
                    'Masuk untuk melanjutkan perjalanan perawatan kulitmu.',
              ),
              const SizedBox(height: 28),

              const AuthField(
                label: 'Email',
                hint: 'Masukkan emailmu',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              const AuthField(
                label: 'Kata sandi',
                hint: 'Masukkan kata sandi',
                icon: Icons.lock_outline,
                password: true,
              ),
              const SizedBox(height: 12),

              // "Lupa kata sandi?" rata kanan
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur lupa kata sandi belum tersedia')),
                    );
                  },
                  child: const Text('Lupa kata sandi?',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700, color: kGreen)),
                ),
              ),
              const SizedBox(height: 22),

              // Tombol Masuk -> ke MainShell (Beranda).
              AuthButton(
                teks: 'Masuk',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainShell()),
                ),
              ),
              const SizedBox(height: 18),

              // Link ke halaman Daftar
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    children: [
                      const TextSpan(text: 'Baru di Glowmap?  '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterPage()),
                          ),
                          child: const Text('Daftar sekarang',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: kGreen)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const PrivacyNote(),
            ],
          ),
        ),
      ),
    );
  }
}