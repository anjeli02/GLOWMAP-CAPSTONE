import 'package:flutter/material.dart';
import '../colors.dart';
import 'hasil_cek_produk_page.dart';

// Halaman pindai label komposisi produk. StatelessWidget karena belum
// ada data yang berubah (tampilan saja).
class CekProdukPage extends StatelessWidget {
  const CekProdukPage({super.key});

  // Pindah ke halaman hasil. Navigator.push menumpuk halaman baru
  // di atas halaman ini, jadi tombol back otomatis muncul di sana.
  void _keHasil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HasilCekProdukPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Karena halaman ini dibuka lewat Navigator.push, AppBar otomatis
      // menampilkan panah back di kiri. Tidak perlu kode tambahan.
      appBar: AppBar(
        backgroundColor: kCream,
        elevation: 0,
        title: const Text('Cek Produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: kPeach,
              child: Icon(Icons.person, color: kGreen),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge privasi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kRoseLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 13, color: kRose),
                  SizedBox(width: 4),
                  Text('100% Offline OCR • ML Kit On-Device',
                      style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Cek Kandungan Produk',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text(
              'Pindai label komposisi (ingredients) pada kemasan produk skincare untuk mendeteksi kecocokan dengan profil kulitmu serta potensi bahan iritan.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            _scanPreview(),
            const SizedBox(height: 16),

            // Tombol utama: pindai kemasan (tombol unggah galeri sudah dihapus)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _keHasil(context),
                style: FilledButton.styleFrom(
                  backgroundColor: kRose,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.document_scanner_outlined, size: 18),
                label: const Text('Scan Kemasan Sekarang'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_note, size: 18, color: kRose),
                label: const Text('Ketik Manual Daftar Bahan',
                    style: TextStyle(fontSize: 12, color: kRose)),
              ),
            ),
            const SizedBox(height: 12),

            _tipsCard(),
          ],
        ),
      ),
    );
  }

  // ---------- Area preview kamera ----------
  Widget _scanPreview() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [kRoseLight, kPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      // Stack = menumpuk widget (seperti lapisan), posisinya diatur
      // dengan Positioned.
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bingkai tempat label komposisi diarahkan
          Container(
            width: 240,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.document_scanner_outlined,
                size: 56, color: Colors.white70),
          ),
          // Chip jumlah bahan terdeteksi (kiri atas)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.text_fields, size: 14, color: kRose),
                  SizedBox(width: 4),
                  Text('Teks Terdeteksi: 18 Bahan',
                      style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
          // Tombol info (kanan atas)
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.info_outline, size: 16, color: kRose),
              ),
            ),
          ),
          // Petunjuk di bawah
          Positioned(
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Posisikan daftar komposisi di dalam bingkai',
                  style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu tips ----------
  Widget _tipsCard() {
    // Daftar tips disimpan sebagai list of record: (ikon, judul, deskripsi).
    // Dengan begitu tampilan 3 tips cukup ditulis sekali di perulangan.
    const tips = [
      (Icons.center_focus_strong_outlined, 'Fokus & Anti-Blur',
          'Pastikan teks komposisi tajam dan tidak buram saat dipindai.'),
      (Icons.wb_sunny_outlined, 'Hindari Sinar Pantulan',
          'Miringkan kemasan sedikit agar tidak ada kilau di atas tulisan.'),
      (Icons.crop_free, 'Ratakan Lipatan Kemasan',
          'Luruskan bagian kemasan yang melengkung agar teks terbaca utuh.'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, size: 18, color: kRose),
              SizedBox(width: 8),
              Text('Tips Hasil Pindai Akurat',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          // "for ... in" di dalam children = ulangi widget untuk tiap isi list
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: kRoseLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(tip.$1, size: 16, color: kRose),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tip.$2,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                        Text(tip.$3,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}