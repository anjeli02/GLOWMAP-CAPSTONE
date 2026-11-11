import 'package:flutter/material.dart';
import '../colors.dart';

// AppBar bersama untuk semua halaman Glowmap (logo + nama + subjudul,
// lonceng, dan avatar). Tampilannya sama dengan AppBar di Beranda.
// Cara pakai:  appBar: const GlowmapAppBar(subtitle: 'Profil'),
// Untuk halaman dengan panah kembali buatan sendiri (mis. Hasil Analisis):
//              appBar: GlowmapAppBar(subtitle: 'Hasil Analisis', onBack: fungsi),
//
// "implements PreferredSizeWidget" wajib supaya widget ini boleh
// dipasang di properti appBar milik Scaffold (Scaffold perlu tahu tingginya).
class GlowmapAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlowmapAppBar({super.key, required this.subtitle, this.onBack});

  // Tulisan kecil di bawah "Glowmap" (mis. Beranda, Riwayat, Profil)
  final String subtitle;

  // Kalau diisi, muncul panah kembali di kiri dan fungsi ini dipanggil saat
  // ditekan. Kalau kosong, panah muncul otomatis hanya bila halaman dibuka
  // lewat Navigator.push.
  final VoidCallback? onBack;

  // Tinggi AppBar standar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kCream,
      elevation: 0,
      titleSpacing: onBack == null ? 16 : 0,
      leading: onBack == null
          ? null
          : IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
      // Bagian kiri: kotak logo + tulisan Glowmap/subjudul
      title: Row(
        children: [
          // Logo Glowmap (gambar dari assets/images/logo_icon.png)
          Image.asset(
            'assets/images/logo_icon.png',
            height: 36,
            // Kalau gambar gagal dimuat, tampilkan ikon daun sebagai cadangan
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.spa_outlined, color: kGreen, size: 28),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Glowmap',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ],
      ),
      // Bagian kanan: lonceng + avatar
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: kPeach,
            child: Icon(Icons.person, color: kGreen),
          ),
        ),
      ],
    );
  }
}