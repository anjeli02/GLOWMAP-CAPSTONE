import 'package:flutter/material.dart';
import '../colors.dart';
import 'hasil_cek_produk_page.dart';

// Warna khusus halaman ini. Diawali "_" artinya privat (hanya di file ini).
const _kBrown = Color(0xFF7A3E39); // cokelat tua: tombol & teks aksen
const _kRed = Color(0xFFC0392B); // merah: peringatan kulit sensitif

// Halaman hasil analisis kulit. Tampil DI DALAM tab Cek Kulit, jadi menu
// bawah tetap terlihat. Dua fungsi dikirim dari MainShell:
//  - onBack            : kembali ke halaman scan (panah back)
//  - onLihatRutinitas  : tutup halaman ini lalu pindah ke tab Rutinitas
class HasilAnalisisPage extends StatefulWidget {
  const HasilAnalisisPage({
    super.key,
    required this.onBack,
    required this.onLihatRutinitas,
  });

  final VoidCallback onBack;
  final VoidCallback onLihatRutinitas;

  @override
  State<HasilAnalisisPage> createState() => _HasilAnalisisPageState();
}

class _HasilAnalisisPageState extends State<HasilAnalisisPage> {
  bool _saved = false; // riwayat screening sudah disimpan?
  bool _productSaved = false; // produk rekomendasi sudah di-bookmark?

  // Skor jerawat 0-100 (makin kecil makin baik). Nanti dari model ML.
  final double _score = 28;

  // Data keluhan prioritas: (judul, penjelasan, label)
  static const _priorities = [
    (
      'Pori-pori Tersumbat & Sebum T-Zone',
      'Penumpukan sebum alami di hidung dan dahi yang rentan komedo jika tidak dibersihkan dengan benar.',
      'Prioritas Tinggi'
    ),
    (
      'Kemerahan Reaktif di Pipi',
      'Eritema ringan pada pipi akibat cuaca panas atau gesekan, membutuhkan bahan menenangkan.',
      'Sensitif'
    ),
    (
      'Dehidrasi Lapisan Kulit Luar (Mikro-kering)',
      'Kurang kelembapan air meskipun permukaan tampak berkilau karena minyak berlebih.',
      'Perlu Hidrasi'
    ),
  ];

  // Data bahan aktif: (nama, label, subjudul, alasan, ikon)
  static const _ingredients = [
    (
      'Niacinamide (2-4%)',
      'Barrier-Friendly',
      'Pengontrol Sebum & Anti-Inflamasi',
      'Mengontrol kelebihan minyak di T-Zone dan menenangkan peradangan bekas jerawat tanpa merusak pertahanan alami kulit.',
      Icons.ac_unit
    ),
    (
      'Centella Asiatica (Cica)',
      'Penenang Cepat',
      'Penenang Reaktivitas Kulit',
      'Meredakan kemerahan, memperkuat skin barrier yang reaktif, dan mempercepat pemulihan sel kulit yang teriritasi.',
      Icons.eco_outlined
    ),
    (
      'Hyaluronic Acid',
      'Non-Komedogenik',
      'Hidrasi Molekul Ringan',
      'Mengunci hidrasi tanpa menyumbat pori atau memicu komedo, memulihkan kelembapan mikro-kering pada pipi.',
      Icons.water_drop_outlined
    ),
  ];

  // Pesan singkat di bawah layar. hideCurrentSnackBar menutup pesan lama
  // dulu supaya tidak menumpuk.
  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), duration: const Duration(seconds: 1)),
      );
  }

  void _toggleSave() {
    setState(() => _saved = !_saved); // balik nilai true <-> false
    _showMessage(_saved
        ? 'Riwayat screening disimpan'
        : 'Riwayat screening dihapus dari simpanan');
  }

  void _toggleProduct() {
    setState(() => _productSaved = !_productSaved);
    _showMessage(
        _productSaved ? 'Produk disimpan' : 'Produk dihapus dari simpanan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _aiCard(),
            const SizedBox(height: 14),
            _heroCard(),
            const SizedBox(height: 14),
            _scoreCard(),
            const SizedBox(height: 22),

            // Judul "3 keluhan prioritas kulit"
            const Row(
              children: [
                Icon(Icons.priority_high, size: 16, color: _kRed),
                SizedBox(width: 2),
                Expanded(
                  child: Text('3 KELUHAN PRIORITAS KULIT',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _kBrown)),
                ),
                Text('Fokus Perawatan',
                    style: TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            // for dengan index (i) supaya bisa menampilkan nomor 1, 2, 3
            for (int i = 0; i < _priorities.length; i++) ...[
              _priorityCard(i, _priorities[i]),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),

            // Judul "Rekomendasi Bahan Aktif" + ikon labu di kanan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SerifTitle('Rekomendasi Bahan Aktif'),
                      SizedBox(height: 2),
                      Text(
                        'Disesuaikan otomatis untuk menyeimbangkan barrier & sebum',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kRoseLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x337A3E39)),
                  ),
                  child: const Icon(Icons.science_outlined,
                      size: 18, color: _kBrown),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in _ingredients) ...[
              _ingredientCard(item),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),

            // Judul "Rekomendasi Produk Spesifik" + badge kecocokan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SerifTitle('Rekomendasi Produk Spesifik'),
                      SizedBox(height: 2),
                      Text('Kecocokan formula berdasarkan profil kulit',
                          style:
                              TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _pill(Icons.check_circle_outline, 'Kecocokan 98%',
                    bg: kGreenLight, fg: kGreen),
              ],
            ),
            const SizedBox(height: 12),
            _productCard(),
            const SizedBox(height: 22),

            // Judul "Perbandingan Screening Sebelumnya" + badge progress
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: kRoseLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.trending_up,
                      size: 18, color: _kBrown),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Perbandingan Screening Sebelumnya',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                      Text('Screening Kedua vs 14 Hari Lalu (10 Nov)',
                          style:
                              TextStyle(fontSize: 10, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _pill(Icons.arrow_upward, 'Progress +12%',
                    bg: kGreenLight, fg: kGreen),
              ],
            ),
            const SizedBox(height: 12),
            _compareCard(),
            const SizedBox(height: 22),

            // Tombol utama: kembali ke MainShell lalu buka tab Rutinitas
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.onLihatRutinitas,
                style: FilledButton.styleFrom(
                  backgroundColor: _kBrown,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Lihat Rutinitas Skincare'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Tombol kedua: simpan riwayat
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleSave,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kBrown,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: Icon(
                    _saved ? Icons.bookmark : Icons.bookmark_border,
                    size: 18),
                label: Text(
                    _saved ? 'Riwayat Tersimpan' : 'Simpan Riwayat Screening'),
              ),
            ),
            const SizedBox(height: 14),

            // Catatan penting
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x1A7A3E39)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: _kBrown),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style:
                            TextStyle(fontSize: 10.5, color: Colors.black54),
                        children: [
                          TextSpan(
                              text: 'Catatan Penting: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87)),
                          TextSpan(
                              text:
                                  'Hasil analisis ini merupakan perkiraan awal berbasis model Machine Learning offline Glowmap dan bukan merupakan diagnosis medis dokter spesialis kulit. Jika mengalami iritasi parah, segera konsultasikan ke dermatolog.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- App bar ----------
  // Ada panah back (memanggil onBack), logo, judul + subjudul, lonceng, avatar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kCream,
      elevation: 0,
      titleSpacing: 0, // rapatkan judul ke panah back
      leading: IconButton(
        onPressed: widget.onBack,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: kRoseLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa_outlined, color: _kBrown, size: 18),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hasil Analisis',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              Text('Pemindaian Selesai ✓',
                  style: TextStyle(fontSize: 10.5, color: _kBrown)),
            ],
          ),
        ],
      ),
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

  // ---------- Kartu "Analisis AI Mandiri Selesai" ----------
  Widget _aiCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: const BoxDecoration(
              color: kRoseLight,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.auto_awesome, size: 18, color: _kBrown),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ANALISIS AI MANDIRI SELESAI',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: _kBrown)),
                Text('Diproses On-Device Vision ML',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _pill(Icons.verified_outlined, '92% Keyakinan',
              bg: kRoseLight, fg: _kBrown),
        ],
      ),
    );
  }

  // ---------- Kartu hero: hasil analisis utama ----------
  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [kRoseLight, kPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0x1A7A3E39)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap = seperti Row, tapi turun baris otomatis kalau tidak muat
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(Icons.favorite, 'Hasil Analisis Kulit Utama',
                  bg: Colors.white, fg: _kBrown),
              _pill(Icons.warning_amber_rounded,
                  'Kulit Sensitif: Aktif / Reaktif',
                  bg: const Color(0xFFFFE3E0), fg: _kRed),
            ],
          ),
          const SizedBox(height: 14),
          // fontFamily 'serif' = font berkait, seperti di desain
          const Text('Kombinasi Cenderung Berminyak',
              style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.15)),
          const SizedBox(height: 10),
          const Text(
            'Produksi minyak tinggi terpusat di area T-zone, sedangkan bagian pipi mengalami dehidrasi ringan dan sangat reaktif terhadap faktor lingkungan atau formula eksfoliasi agresif.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu Acne Severity Score ----------
  Widget _scoreCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: const BoxDecoration(
                  color: kRoseLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.blur_on, size: 18, color: _kBrown),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Acne Severity Score',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('Intensitas jerawat & lesi aktif',
                        style:
                            TextStyle(fontSize: 10.5, color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Skor di kanan + badge tingkat
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text.rich = satu teks dengan beberapa gaya berbeda
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: 'Skor ',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: _kBrown)),
                        TextSpan(
                            text: _score.round().toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: _kBrown)),
                        const TextSpan(
                            text: ' / 100',
                            style: TextStyle(
                                fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: kGreenLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kGreen.withValues(alpha: 0.4)),
                    ),
                    child: const Text('Tingkat Rendah (Low)',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: kGreen)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _severityBar(),
          const SizedBox(height: 6),
          // Tiga keterangan rentang skor, masing-masing mengambil 1/3 lebar
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('0 - 30: Rendah / Ringan',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: kGreen)),
              ),
              Expanded(
                child: Text('31 - 65: Sedang',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9, color: Colors.black54)),
              ),
              Expanded(
                child: Text('66 - 100: Berat',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 9, color: Colors.black54)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Kotak keterangan hasil deteksi
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x14000000)),
            ),
            child: const Text(
              'Hanya terdeteksi komedo terbuka ringan & 2 titik beruntusan mikro non-inflamasi di area dahi. Tidak ada jerawat kistik aktif yang terdeteksi.',
              style: TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Bar gradasi hijau -> kuning -> merah, dengan penanda posisi skor.
  Widget _severityBar() {
    // LayoutBuilder memberi tahu lebar yang tersedia, supaya posisi
    // penanda bisa dihitung dari persentase skor.
    return LayoutBuilder(
      builder: (context, constraints) {
        final markerLeft = constraints.maxWidth * (_score / 100) - 7;
        return SizedBox(
          height: 16,
          // Stack = menumpuk widget; Positioned = mengatur letaknya
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 4,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6FB57A),
                        Color(0xFFF2CF7A),
                        Color(0xFFE57373),
                      ],
                    ),
                  ),
                ),
              ),
              // Penanda posisi skor
              Positioned(
                left: markerLeft,
                top: 1,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: kGreen, width: 3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- Kartu keluhan prioritas (bernomor) ----------
  Widget _priorityCard(int index, (String, String, String) item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lingkaran nomor (index mulai dari 0, jadi ditambah 1)
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: kRoseLight,
              shape: BoxShape.circle,
            ),
            child: Text('${index + 1}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _kBrown)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.$1,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    // Label di kanan (Prioritas Tinggi / Sensitif / dst.)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kRoseLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(item.$3,
                          style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: _kBrown)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(item.$2,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu bahan aktif (dengan kotak "Alasan") ----------
  Widget _ingredientCard((String, String, String, String, IconData) item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: const BoxDecoration(
                  color: kRoseLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.$5, color: _kBrown, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(item.$1,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kRoseLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(item.$2,
                              style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: _kBrown)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(item.$3,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _kBrown)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Kotak "Alasan: ..." (kata "Alasan:" ditebalkan)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kRoseLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1A7A3E39)),
            ),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 11, color: Colors.black87),
                children: [
                  const TextSpan(
                      text: 'Alasan: ',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(text: item.$4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu produk spesifik ----------
  Widget _productCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder foto produk + tulisan BPOM
              Container(
                width: 60,
                height: 72,
                decoration: BoxDecoration(
                  color: kRoseLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('BPOM',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: _kBrown)),
                    SizedBox(height: 2),
                    Icon(Icons.medication_liquid_outlined,
                        color: _kBrown, size: 28),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('AURA BOTANICA • SERUM WAJAH',
                        style: TextStyle(fontSize: 9.5, color: Colors.brown)),
                    SizedBox(height: 2),
                    Text('Barrier Calming Recovery Serum',
                        style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Rp 129.000 ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: _kBrown)),
                          TextSpan(
                              text: '(30ml)',
                              style: TextStyle(
                                  fontSize: 10.5, color: Colors.black54)),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text('No. BPOM: NA18230199842',
                        style: TextStyle(fontSize: 9.5, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Kotak bahan kunci
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x14000000)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.eco_outlined, size: 14, color: _kBrown),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 11),
                          children: [
                            TextSpan(
                                text: 'Bahan Kunci: ',
                                style:
                                    TextStyle(fontWeight: FontWeight.w800)),
                            TextSpan(
                                text:
                                    'Centella Asiatica 5%, Ceramide NP, Panthenol'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Kombinasi menenangkan tanpa alkohol & pewangi buatan, dirancang khusus mempercepat pemulihan reaktif.',
                  style: TextStyle(fontSize: 10.5, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    // Buka halaman Hasil Cek Produk yang sudah dibuat sebelumnya
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HasilCekProdukPage()),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: kRoseLight,
                      foregroundColor: _kBrown,
                    ),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Lihat Detail Produk',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Tombol bookmark produk
              SizedBox(
                width: 44,
                height: 44,
                child: OutlinedButton(
                  onPressed: _toggleProduct,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: _kBrown,
                  ),
                  child: Icon(
                      _productSaved ? Icons.bookmark : Icons.bookmark_border,
                      size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Kartu perbandingan screening ----------
  Widget _compareCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _miniStat(
                  'Skin Barrier',
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: '58 ',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                                decoration: TextDecoration.lineThrough)),
                        TextSpan(
                            text: '68',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: _kBrown)),
                        TextSpan(
                            text: ' / 100',
                            style: TextStyle(
                                fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _miniStat(
                  'Jerawat & Kemerahan',
                  const Text('Tingkat Rendah',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _kBrown)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kRoseLight.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1A7A3E39)),
            ),
            child: const Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 11, color: Colors.black87),
                children: [
                  TextSpan(
                      text: 'Catatan Progress: ',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  TextSpan(
                      text:
                          'Terjadi peningkatan ketahanan barrier yang nyata. Tekstur mikro-dehidrasi di pipi berangsur pulih dan frekuensi kemerahan berkurang sejak evaluasi 10 November.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kotak kecil berisi label + nilai (dipakai di kartu perbandingan)
  Widget _miniStat(String label, Widget value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x14000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          value,
        ],
      ),
    );
  }

  // ---------- Pembantu tampilan ----------
  // Chip kecil berbentuk pil (ikon + teks) dengan warna yang bisa diatur
  Widget _pill(IconData icon, String text,
      {Color bg = Colors.white, Color fg = _kBrown}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 10.5, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );
  }

  // Gaya kartu putih bersama (sama seperti di halaman lain)
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
            color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
      ],
    );
  }
}

// Judul bagian bergaya serif (font berkait seperti di desain).
class _SerifTitle extends StatelessWidget {
  const _SerifTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontFamily: 'serif', fontSize: 17, fontWeight: FontWeight.w700));
  }
}