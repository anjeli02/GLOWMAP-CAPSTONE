import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/auth_widgets.dart';
import 'main_shell.dart';

// Halaman Daftar. Belum ada fungsi daftar asli:
// tombol "Daftar" langsung membuka Beranda.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                label: 'DAFTAR AKUN',
                judul: 'Buat akun\nuntuk memulai.',
                deskripsi: 'Lengkapi data diri Anda untuk mendaftar.',
              ),
              const SizedBox(height: 24),

              const AuthField(
                label: 'Nama lengkap',
                hint: 'Masukkan nama lengkap',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              const AuthField(
                label: 'Email',
                hint: 'nama@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const AuthField(
                label: 'Kata sandi',
                hint: 'Buat kata sandi',
                password: true,
              ),
              const SizedBox(height: 8),
              const Text('Gunakan minimal 8 karakter.',
                  style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 14),
              const AuthField(
                label: 'Konfirmasi kata sandi',
                hint: 'Ulangi kata sandi',
                password: true,
              ),
              const SizedBox(height: 22),

              // Tombol Daftar -> ke Beranda.
              // pushAndRemoveUntil (route) => false = hapus SEMUA halaman
              // sebelumnya (login + daftar) supaya tidak bisa kembali ke sana.
              AuthButton(
                teks: 'Daftar',
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainShell()),
                  (route) => false,
                ),
              ),
              const SizedBox(height: 18),

              // Link kembali ke Login
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    children: [
                      const TextSpan(text: 'Sudah punya akun?  '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Masuk',
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