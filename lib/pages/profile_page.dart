import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';
import 'edit_profil_page.dart';
import 'pengaturan_page.dart';
import 'login_page.dart';

// Halaman Profil (tab ke-5 di bottom nav).
// StatelessWidget karena belum ada data yang berubah di halaman ini.
// onNavigate dipakai untuk pindah tab (mis. ke tab Cek Kulit).
class ProfilePage extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const ProfilePage({super.key, required this.onNavigate});

  // Dekorasi kartu putih yang dipakai berulang (radius 16 + shadow tipis)
  BoxDecoration get _cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      );

  // Dialog konfirmasi logout (belum ada fungsi asli, hanya tampilan)
  void _konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Glowmap?'),
        content: const Text('Kamu bisa masuk lagi kapan saja.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            // Tutup dialog, lalu kembali ke halaman Login.
            // (route) => false = hapus semua halaman sebelumnya.
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Color(0xFFC0392B))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlowmapAppBar(subtitle: 'Profil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== JUDUL HALAMAN =====
            const Text(
              'RUANG PERSONALMU',
              style: TextStyle(fontSize: 11, letterSpacing: 1.2, color: kGreen, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text('Profil Saya', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text(
              'Perawatan yang terasa personal, dimulai dari mengenal dirimu.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // ===== KARTU PROFIL: foto, nama, chip, tombol Edit =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Foto profil. Nanti bisa diganti Image.asset / foto dari galeri.
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: kPeach, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 38,
                          backgroundColor: kRoseLight,
                          child: Icon(Icons.person, size: 40, color: kRose),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lily', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            const Text('Teman perjalanan kulitmu 🌿',
                                style: TextStyle(fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 8),
                            _chip('Profil lokal · Tanpa akun', kGreenLight, kGreen),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tombol Edit Profil -> pindah ke EditProfilPage
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfilPage()),
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreenLight,
                        foregroundColor: kGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ===== KARTU PROFIL KULITMU (warna peach) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kPeach, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.spa_outlined, size: 18, color: Color(0xFF7A3E39)),
                      SizedBox(width: 8),
                      Text('Profil kulitmu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Kombinasi Cenderung Berminyak',
                    style: TextStyle(fontSize: 26, fontFamily: 'serif', height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  // Wrap = chip otomatis turun baris kalau layar sempit
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip('Sensitif / Reaktif', Colors.white, Colors.black87),
                      _chip('Jerawat ringan', kGreenLight, kGreen),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fokus perawatan: menjaga skin barrier, menenangkan kemerahan, dan menyeimbangkan minyak di T-zone.',
                    style: TextStyle(fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0x22000000)),
                  const SizedBox(height: 10),
                  const Text('Berdasarkan screening · 24 November 2026',
                      style: TextStyle(fontSize: 11, color: Colors.black54)),
                  const SizedBox(height: 6),
                  // Link ke tab Cek Kulit (index 1)
                  InkWell(
                    onTap: () => onNavigate(1),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Perbarui lewat Cek Kulit',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF7A3E39))),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16, color: Color(0xFF7A3E39)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ===== MENU PENGATURAN -> PengaturanPage =====
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PengaturanPage()),
              ),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: _cardDecoration,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: kCream, shape: BoxShape.circle),
                      child: const Icon(Icons.tune, size: 20, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengaturan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          SizedBox(height: 2),
                          Text('Pengingat, notifikasi, dan preferensi',
                              style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.black38),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ===== KARTU PRIVASI (hijau muda) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, color: kGreen),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pribadi, tanpa perlu akun',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGreen)),
                        SizedBox(height: 4),
                        Text(
                          'Analisis dilakukan on-device. Foto, hasil, dan profilmu hanya tersimpan di perangkat ini, bukan di server.',
                          style: TextStyle(fontSize: 12, height: 1.4, color: kGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ===== TOMBOL LOGOUT =====
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => _konfirmasiLogout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRoseLight,
                  foregroundColor: const Color(0xFFC0392B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chip kecil berbentuk pil (dipakai di kartu profil dan kartu kulit)
  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w500)),
    );
  }
}