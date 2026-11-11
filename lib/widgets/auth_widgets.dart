import 'package:flutter/material.dart';
import '../colors.dart';

// Bagian-bagian yang dipakai bersama oleh halaman Login dan Daftar,
// supaya kodenya tidak ditulis dua kali.

// ===== Header: logo + "Glowmap" + tagline =====
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo Glowmap
        Image.asset(
          'assets/images/logo_icon.png',
          height: 48,
          // Kalau gambar gagal dimuat, tampilkan ikon daun sebagai cadangan
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.spa_outlined, color: kGreen, size: 32),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Glowmap',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            Text('Teman perjalanan kulitmu',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

// ===== Kartu sambutan bergradasi hijau -> peach dengan hiasan daun =====
class AuthHero extends StatelessWidget {
  const AuthHero({
    super.key,
    required this.label,
    required this.judul,
    required this.deskripsi,
  });

  final String label; // tulisan kecil kapital di atas
  final String judul; // judul besar (font serif)
  final String deskripsi;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [kGreenLight, kPeach],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      // Stack = tumpuk daun hiasan di belakang teks
      child: Stack(
        children: [
          // Hiasan daun di kanan atas
          Positioned(
            right: 0,
            top: 0,
            child: Column(
              children: [
                Transform.rotate(
                  angle: 0.5,
                  child: Icon(Icons.eco_outlined,
                      size: 52, color: kGreen.withValues(alpha: 0.25)),
                ),
                Transform.rotate(
                  angle: -0.6,
                  child: Icon(Icons.eco_outlined,
                      size: 44, color: kGreen.withValues(alpha: 0.25)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Text(judul,
                    style: const TextStyle(
                        fontSize: 30, fontFamily: 'serif', height: 1.15)),
              ),
              const SizedBox(height: 12),
              Text(deskripsi,
                  style: const TextStyle(
                      fontSize: 12, height: 1.45, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== Kolom isian: label di atas + kotak putih membulat =====
// StatefulWidget karena ikon "mata" bisa menampilkan / menyembunyikan sandi.
class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    this.icon, // ikon di kiri (opsional)
    this.password = false, // true = titik-titik + ikon mata
    this.keyboardType,
  });

  final String label;
  final String hint;
  final IconData? icon;
  final bool password;
  final TextInputType? keyboardType;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _sembunyi = true; // true = sandi disembunyikan

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          child: TextField(
            obscureText: widget.password && _sembunyi,
            keyboardType: widget.keyboardType,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
              prefixIcon: widget.icon == null
                  ? null
                  : Icon(widget.icon, size: 20, color: Colors.black54),
              suffixIcon: widget.password
                  ? IconButton(
                      onPressed: () => setState(() => _sembunyi = !_sembunyi),
                      icon: Icon(
                        _sembunyi
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: Colors.black54,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}

// ===== Tombol hijau besar membulat (Masuk / Daftar) =====
class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.teks, required this.onPressed});

  final String teks;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: kGreen,
          elevation: 4,
          shadowColor: const Color(0x554F6B52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(teks,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}

// ===== Kartu hijau muda di bawah: catatan privasi =====
class PrivacyNote extends StatelessWidget {
  const PrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0E6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, size: 20, color: kGreen),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perawatan personal, privasi tetap terjaga',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                SizedBox(height: 3),
                Text(
                  'Analisis kulit diproses secara offline. Foto dan hasil screening tersimpan di perangkat ini.',
                  style: TextStyle(fontSize: 11, height: 1.4, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}