import 'package:flutter/material.dart';
import '../colors.dart';

// Satu bahan aktif. Class kecil ini hanya "wadah data" supaya daftar
// bahan bisa ditulis rapi dan ditampilkan lewat perulangan.
class ActiveIngredient {
  final String name;
  final String tag;
  final String desc;
  final IconData icon;

  const ActiveIngredient({
    required this.name,
    required this.tag,
    required this.desc,
    required this.icon,
  });
}

// StatefulWidget karena tombol bookmark/simpan bisa berubah status.
class HasilCekProdukPage extends StatefulWidget {
  const HasilCekProdukPage({super.key});

  @override
  State<HasilCekProdukPage> createState() => _HasilCekProdukPageState();
}

class _HasilCekProdukPageState extends State<HasilCekProdukPage> {
  // Apakah produk sudah disimpan. Berubah saat bookmark ditekan.
  bool _saved = false;

  // Skor kecocokan (0-100). Nanti nilainya datang dari hasil analisis.
  final double _score = 94;

  // Data contoh bahan aktif (placeholder, sesuaikan dengan desainmu).
  final List<ActiveIngredient> _ingredients = const [
    ActiveIngredient(
      name: 'Niacinamide (5%)',
      tag: 'BHQ • Anti-Acne',
      desc: 'Membantu mengontrol minyak, menyamarkan pori, dan memperkuat barrier kulit.',
      icon: Icons.science_outlined,
    ),
    ActiveIngredient(
      name: 'Centella Asiatica Extract',
      tag: 'BHQ • Soothing',
      desc: 'Menenangkan kulit yang kemerahan atau mudah iritasi.',
      icon: Icons.eco_outlined,
    ),
    ActiveIngredient(
      name: 'Sodium Hyaluronate',
      tag: 'HUM • Hidrasi',
      desc: 'Menarik dan mengunci kelembapan agar kulit tetap kenyal.',
      icon: Icons.water_drop_outlined,
    ),
    ActiveIngredient(
      name: 'Camellia Sinensis (Green Tea)',
      tag: 'ANT • Antioksidan',
      desc: 'Melindungi kulit dari radikal bebas dan membantu mengurangi peradangan.',
      icon: Icons.local_cafe_outlined,
    ),
  ];

  // Dipanggil saat bookmark atau tombol Simpan ditekan.
  void _toggleSave() {
    setState(() => _saved = !_saved); // balik nilai true <-> false
    // SnackBar = pesan singkat yang muncul di bawah layar.
    // hideCurrentSnackBar() menutup pesan lama dulu supaya tidak menumpuk.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
              _saved ? 'Produk disimpan' : 'Produk dihapus dari simpanan'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCream,
        elevation: 0,
        title: const Text('Hasil Analisis Produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: _toggleSave,
            // Ikon berubah sesuai status _saved
            icon: Icon(_saved ? Icons.bookmark : Icons.bookmark_border,
                color: kRose),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap = seperti Row, tapi turun baris otomatis kalau tidak muat
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(Icons.text_fields,
                    '18 Bahan Terdeteksi via On-Device OCR'),
                _chip(Icons.public, 'Global'),
              ],
            ),
            const SizedBox(height: 14),
            _productCard(),
            const SizedBox(height: 14),
            _compatibilityCard(),
            const SizedBox(height: 20),

            // Judul bagian + jumlah bahan.
            // Expanded di judul supaya teks tidak overflow di layar sempit.
            Row(
              children: [
                const Expanded(
                  child: Text('Kandungan Aktif Unggulan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                _chip(Icons.biotech_outlined,
                    '${_ingredients.length} Bahan Aktif'),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Cocok dengan kebutuhan profil kulit dan tingkat keamanan bahan.',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // Satu kartu per bahan, dibuat lewat perulangan
            for (final item in _ingredients) ...[
              _ingredientCard(item),
              const SizedBox(height: 10),
            ],

            const SizedBox(height: 6),
            // Dua tombol aksi berdampingan
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _toggleSave,
                    style: FilledButton.styleFrom(
                      backgroundColor: kRose,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(_saved ? Icons.check : Icons.bookmark_border,
                        size: 18),
                    label: Text(_saved ? 'Tersimpan' : 'Simpan Produk'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    // Navigator.pop = tutup halaman ini, kembali ke halaman scan
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon:
                        const Icon(Icons.document_scanner_outlined, size: 18),
                    label: const Text('Pindai Lainnya'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kRoseLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Analisis ini bersifat informatif dan dihasilkan secara on-device dari teks komposisi. Bukan pengganti saran dokter kulit.',
                style: TextStyle(fontSize: 10.5, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Kartu info produk ----------
  Widget _productCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Placeholder foto produk (nanti diganti gambar asli)
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kRoseLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.spa_outlined, color: kRose, size: 30),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AURA BOTANICA • SERUM WAJAH',
                    style: TextStyle(fontSize: 10, color: Colors.brown)),
                SizedBox(height: 2),
                Text('Rejuvenating Face Serum (30ml)',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('Dipindai hari ini (14:42 WIB)',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu kecocokan profil kulit ----------
  Widget _compatibilityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kecocokan Profil Kulit Anda',
                        style: TextStyle(fontSize: 11, color: Colors.black54)),
                    const SizedBox(height: 2),
                    // Text.rich = satu teks dengan beberapa gaya berbeda
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_score.round()}% ',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: kRose),
                          ),
                          const TextSpan(
                            text: 'Sangat Cocok',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Badge status keamanan
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kRoseLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Sangat\nAman',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar: value harus antara 0.0 sampai 1.0, jadi skor dibagi 100
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _score / 100,
              minHeight: 8,
              backgroundColor: kRoseLight,
              valueColor: const AlwaysStoppedAnimation(kRose),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Formula ini sangat cocok untuk kulit Kombinasi & Sensitif Anda saat ini.',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu satu bahan aktif ----------
  Widget _ingredientCard(ActiveIngredient item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kGreenLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: kGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kCream,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(item.tag, style: const TextStyle(fontSize: 10)),
                ),
                const SizedBox(height: 4),
                Text(item.desc,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Chip kecil berbentuk pil (ikon + teks)
  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kRoseLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: kRose),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10.5)),
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