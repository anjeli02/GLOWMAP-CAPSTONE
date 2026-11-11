import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';
import 'hasil_analisis_page.dart';

// Model data 1 hasil screening (data dummy dulu, belum dari database)
class RiwayatItem {
  final String tanggal;
  final String jam;
  final String tipe;
  final String keluhan;
  final String skor;
  final String kepekaan;
  final bool terbaru;

  const RiwayatItem({
    required this.tanggal,
    required this.jam,
    required this.tipe,
    required this.keluhan,
    required this.skor,
    required this.kepekaan,
    this.terbaru = false,
  });
}

// StatefulWidget karena daftar bisa berkurang saat tombol Hapus ditekan (setState)
class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  // Daftar riwayat, urutan terbaru dulu
  final List<RiwayatItem> _items = [
    const RiwayatItem(
      tanggal: '24 November 2026',
      jam: '',
      tipe: 'Kombinasi cenderung berminyak',
      keluhan: 'Jerawat ringan · Kemerahan berkurang',
      skor: 'Skor jerawat 28/100',
      kepekaan: 'Sensitif',
      terbaru: true,
    ),
    const RiwayatItem(
      tanggal: '17 November 2026',
      jam: '08:45 WIB',
      tipe: 'Kombinasi cenderung berminyak',
      keluhan: 'Jerawat sedang · Dehidrasi ringan',
      skor: 'Skor jerawat 34/100',
      kepekaan: 'Sensitif',
    ),
    const RiwayatItem(
      tanggal: '10 November 2026',
      jam: '09:30 WIB',
      tipe: 'Kombinasi cenderung berminyak',
      keluhan: 'Jerawat sedang · Pipi mudah kemerahan',
      skor: 'Skor jerawat 42/100',
      kepekaan: 'Sensitif',
    ),
  ];

  // Dialog konfirmasi sebelum menghapus (sesuai catatan di bawah halaman)
  void _hapus(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus hasil ini?'),
        content: const Text('Hasil screening yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _items.removeAt(index));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hasil screening dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Color(0xFFC0392B))),
          ),
        ],
      ),
    );
  }

  // Lihat detail: buka halaman Hasil Analisis lewat Navigator.push
  void _lihatDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: kCream,
          body: SafeArea(
            child: HasilAnalisisPage(onBack: () => Navigator.pop(ctx)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlowmapAppBar(subtitle: 'Riwayat'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== JUDUL =====
            const Text(
              'PERJALANAN KULITMU',
              style: TextStyle(fontSize: 11, letterSpacing: 1.2, color: kGreen, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text('Riwayat Hasil Screening',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text(
              'Kenali perubahan kecil kulitmu, satu screening demi satu screening.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // ===== INFO HIJAU: tersimpan otomatis =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(14)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: kGreen, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hasil tersimpan otomatis setelah screening. Hanya di perangkatmu, tetap bisa dibuka offline.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: kGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== HEADER BULAN + JUMLAH HASIL =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('November 2026',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text('${_items.length} hasil · Terbaru dulu',
                    style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),

            // ===== DAFTAR KARTU (atau tampilan kosong) =====
            if (_items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('Belum ada riwayat screening',
                      style: TextStyle(color: Colors.black45)),
                ),
              )
            else
              // List.generate bikin 1 kartu untuk tiap data
              ...List.generate(_items.length, (i) => _kartu(i, _items[i])),

            const SizedBox(height: 8),

            // ===== CATATAN BAWAH =====
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.black45),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hasil screening adalah perkiraan awal, bukan diagnosis medis. Penghapusan hasil memerlukan konfirmasi.',
                    style: TextStyle(fontSize: 11, height: 1.4, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 1 kartu riwayat
  Widget _kartu(int index, RiwayatItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris tanggal + badge "Terbaru" / jam
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: kGreen),
              const SizedBox(width: 8),
              Text(item.tanggal, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (item.terbaru)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(12)),
                  child: const Text('Terbaru',
                      style: TextStyle(fontSize: 11, color: kGreen, fontWeight: FontWeight.w600)),
                )
              else
                Text(item.jam, style: const TextStyle(fontSize: 11, color: Colors.black45)),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.tipe, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(item.keluhan, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 10),
          // Chip skor + kepekaan
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _chip(item.skor, kGreenLight, kGreen),
              _chip(item.kepekaan, kRoseLight, const Color(0xFFC0392B)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0x14000000)),
          const SizedBox(height: 10),
          // Baris aksi: Lihat detail (kiri) dan Hapus (kanan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _lihatDetail,
                child: const Row(
                  children: [
                    Text('Lihat detail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _hapus(index),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: Color(0xFFC0392B)),
                    SizedBox(width: 4),
                    Text('Hapus',
                        style: TextStyle(fontSize: 13, color: Color(0xFFC0392B), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w500)),
    );
  }
}