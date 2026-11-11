import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';

// Halaman Cek Kulit (tab ke-2). StatelessWidget karena belum ada data berubah.
class CekKulitPage extends StatelessWidget {
  const CekKulitPage({super.key, required this.onLanjut});

  // fungsi milik MainShell. Dipanggil saat tombol "Lanjutkan ke Kuesioner
  // Kulit" ditekan, untuk menampilkan halaman Hasil Analisis di tab ini.
  final VoidCallback onLanjut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlowmapAppBar(subtitle: 'Cek Kulit'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge privasi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kGreenLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 13, color: kGreen),
                  SizedBox(width: 4),
                  Text('100% Privat • On-Device ML',
                      style: TextStyle(fontSize: 11, color: kGreen)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Cek Kondisi Kulit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text(
              'Pindai wajahmu untuk mendeteksi tipe dan kondisi kulit menggunakan model klasifikasi Machine Learning lokal secara offline.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Area preview kamera
            _cameraPreview(),
            const SizedBox(height: 16),

            // Tombol aksi: hanya ambil foto langsung
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: const Text('Ambil Foto Langsung'),
              ),
            ),
            const SizedBox(height: 16),

            // Panduan
            _guideCard(),
            const SizedBox(height: 16),

            // Tombol lanjut: memanggil onLanjut (menampilkan Hasil Analisis).
            // Halaman kuesioner tidak ada di desain, jadi sementara
            // langsung ke hasil.
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onLanjut,
                style: FilledButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lanjutkan ke Kuesioner Kulit'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Area preview kamera ----------
  Widget _cameraPreview() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [kGreenLight, kPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      // Stack = menumpuk widget (seperti lapisan), posisi diatur dengan Positioned
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Panduan oval wajah
          Container(
            width: 170,
            height: 220,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.elliptical(85, 110)),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.face, size: 64, color: Colors.white70),
          ),
          // Chip "Kamera Siap"
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 8, color: kGreen),
                  SizedBox(width: 6),
                  Text('Kamera Siap', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
          // Tombol flash
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.flash_on, size: 16, color: kGreen),
              ),
            ),
          ),
          // Teks bawah
          Positioned(
            bottom: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Posisikan wajah tepat di dalam bingkai',
                  style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu panduan foto ----------
  Widget _guideCard() {
    const tips = [
      'Wajah tampak jelas dan tegak menghadap kamera',
      'Pencahayaan cukup dan merata (hindari backlight)',
      'Hindari filter tebal atau makeup berlebihan',
      'Pastikan kamera bersih dari noda',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 18, color: kGreen),
              SizedBox(width: 8),
              Text('Panduan Pengambilan Foto yang Tepat',
                  style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          // "for ... in" di dalam children = ulangi widget untuk tiap isi list
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: kGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(tip,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}