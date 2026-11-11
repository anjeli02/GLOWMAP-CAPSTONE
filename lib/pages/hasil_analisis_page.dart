import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';
import 'hasil_cek_produk_page.dart';

// Warna khusus halaman ini. Diawali "_" artinya privat (hanya di file ini).
const _kBrown = Color(0xFF7A3E39); // cokelat tua: teks & aksen
const _kRed = Color(0xFFC0392B); // merah: label peringatan

// Halaman Hasil Analisis. Tampil DI DALAM tab Cek Kulit (menu bawah tetap
// terlihat) dan juga dibuka dari Riwayat ("Lihat detail").
// onBack = fungsi dari pemanggil untuk kembali (panah di kiri atas).
// StatelessWidget karena isi halaman belum ada yang berubah.
class HasilAnalisisPage extends StatelessWidget {
  const HasilAnalisisPage({super.key, required this.onBack});

  final VoidCallback onBack;

  // Data bahan aktif: (nama, manfaat)
  static const _bahan = [
    ('Zinc PCA (0.5%)', 'Mengontrol produksi minyak alami'),
    ('Azelaic Acid (10%)', 'Mengatasi jerawat & aman bumil'),
    ('Niacinamide (1%)', 'Meredakan kemerahan & peradangan'),
  ];

  // Data produk: (nama, harga, kandungan)
  static const _produk = [
    ('Azarine Anti Acne Serum', 'Rp 75.000', 'Zinc PCA, Niacinamide'),
    ('Avoskin Your Skin Bae', 'Rp 120.000', 'Azelaic Acid 10%'),
  ];

  // Gaya kartu putih yang dipakai bersama
  BoxDecoration _kartu() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      // AppBar bersama + panah kembali (memanggil onBack)
      appBar: GlowmapAppBar(subtitle: 'Hasil Analisis', onBack: onBack),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hasil Analisis Glowmap',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),

            // ===== 1. PROFIL & KONDISI KULIT =====
            _profilKulit(),
            const SizedBox(height: 14),

            // ===== 2. DETEKSI KONDISI KHUSUS (Rule Engine) =====
            _deteksiKhusus(),
            const SizedBox(height: 22),

            // ===== 3. REKOMENDASI BAHAN AKTIF =====
            _judul('Rekomendasi Bahan Aktif', 'Machine Learning'),
            const SizedBox(height: 10),
            // for ... in = ulangi widget untuk setiap isi list
            for (final b in _bahan) _barisBahan(b.$1, b.$2),
            const SizedBox(height: 14),

            // ===== 4. KATALOG PRODUK LOKAL AMAN =====
            _judul('Katalog Produk Lokal Aman', null),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _produk.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  // Expanded = tiap kartu produk berbagi lebar sama rata
                  Expanded(child: _kartuProduk(context, _produk[i])),
                ],
              ],
            ),
            const SizedBox(height: 22),

            // ===== 5. PERBANDINGAN PROGRES KULIT =====
            _perbandingan(),
            const SizedBox(height: 24),

            // ===== 6. TOMBOL SIMPAN KE JURNAL =====
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Tersimpan ke jurnal progres kulit')),
                    );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: const Text('Simpan ke Jurnal Progres Kulit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Judul seksi (dengan keterangan kecil di kanan, opsional) ----------
  Widget _judul(String teks, String? ket) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(teks,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ),
        if (ket != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: kGreenLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(ket,
                style: const TextStyle(fontSize: 10, color: kGreen, fontWeight: FontWeight.w600)),
          ),
        ],
      ],
    );
  }

  // ---------- Kartu profil & kondisi kulit ----------
  Widget _profilKulit() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.face_retouching_natural_outlined, size: 18, color: kGreen),
              SizedBox(width: 8),
              Text('Profil & Kondisi Kulit Anda',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          _barisInfo('Hasil AI', 'BERMINYAK • JERAWAT SEDANG', warna: kGreen, tebal: true),
          _barisInfo('Usia', '19 - 24 Tahun'),
          _barisInfo('Keluhan', 'Jerawat (Meradang)'),
          _barisInfo('Sensitif', 'Tidak'),
        ],
      ),
    );
  }

  // 1 baris "label : nilai"
  Widget _barisInfo(String label, String nilai,
      {Color warna = Colors.black87, bool tebal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          const Text(':  ', style: TextStyle(fontSize: 12, color: Colors.black54)),
          Expanded(
            child: Text(nilai,
                style: TextStyle(
                    fontSize: 12,
                    color: warna,
                    fontWeight: tebal ? FontWeight.w800 : FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu peringatan kondisi khusus (warna peach) ----------
  Widget _deteksiKhusus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kPeach,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kRose.withValues(alpha: 0.6)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: _kBrown, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deteksi Kondisi Khusus (Rule Engine)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _kBrown)),
                SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 12, height: 1.45, color: _kBrown),
                    children: [
                      TextSpan(text: 'Karena Anda sedang '),
                      TextSpan(text: 'HAMIL', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(
                          text:
                              ', sistem otomatis menyaring & memblokir bahan aktif tidak aman (seperti Salicylic Acid & Benzoyl Peroxide) dan menggantinya dengan alternatif aman.'),
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

  // ---------- 1 baris bahan aktif (kotak hijau muda) ----------
  Widget _barisBahan(String nama, String manfaat) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(nama,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGreen)),
          ),
          Expanded(
            flex: 5,
            child: Text('- $manfaat',
                style: const TextStyle(fontSize: 12, color: kGreen)),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu 1 produk ----------
  Widget _kartuProduk(BuildContext context, (String, String, String) p) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _kartu(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder gambar produk (nanti diganti Image.asset)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kPeach,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.water_drop_outlined, size: 20, color: _kBrown),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(p.$1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(p.$2,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kGreen)),
          const SizedBox(height: 8),
          const Text('Kandungan:', style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 2),
          Text(p.$3, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              // Pindah ke halaman Hasil Cek Produk
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HasilCekProdukPage()),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: kGreen,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Detail Produk', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Perbandingan progres kulit (foto bulan lalu vs sekarang) ----------
  Widget _perbandingan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGreenLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.compare_outlined, size: 18, color: kGreen),
              SizedBox(width: 8),
              Text('Perbandingan Progres Kulit',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kGreen)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _kolomFoto('FOTO\nBULAN LALU', 'AI: Jerawat Parah', kRoseLight, _kRed, Colors.black12)),
              const SizedBox(width: 12),
              Expanded(child: _kolomFoto('FOTO\nSEKARANG', 'AI: Jerawat Sedang', Colors.white, kGreen, kPeach)),
            ],
          ),
        ],
      ),
    );
  }

  // 1 kolom: kotak foto + label hasil AI di bawahnya
  Widget _kolomFoto(String judul, String label, Color labelBg, Color labelFg, Color fotoBg) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fotoBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(judul,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: labelBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: labelFg)),
        ),
      ],
    );
  }
}