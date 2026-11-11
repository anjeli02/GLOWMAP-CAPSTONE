import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';
import 'cek_produk_page.dart';
import 'chat_page.dart';

// Halaman Beranda. StatefulWidget karena ada Switch yang bisa on/off
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onNavigate});

  // fungsi milik MainShell untuk pindah tab (0 = Beranda, 1 = Cek Kulit, dst.)
  final ValueChanged<int> onNavigate;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _routineOn = true;

  // build() menyusun seluruh tampilan halaman Beranda.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlowmapAppBar(subtitle: 'Beranda'),
      // Bubble chat melayang di pojok kanan bawah (di atas menu bawah)
      floatingActionButton: _chatBubble(),
      // SingleChildScrollView = membuat isi bisa di scroll kalau kepanjangan
      body: SingleChildScrollView(
        // fromLTRB = jarak dari Left, Top, Right, Bottom
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90), // bawah dilebihkan supaya tidak tertutup bubble chat
        // Column = susun widget dari atas ke bawah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
          children: [
            _greetingCard(),
            const SizedBox(height: 16), // SizedBox = jarak kosong
            _heroCard(),
            const SizedBox(height: 24),
            _sectionTitle('Fitur Utama', action: 'Semua Menu'),
            const SizedBox(height: 12),
            _featureGrid(),
            const SizedBox(height: 12),
            _routineCard(),
            const SizedBox(height: 24),
            _sectionTitle('Artikel Terkini'),
            const SizedBox(height: 12),
            _articleCard(),
            const SizedBox(height: 12),
            _tipCard(),
          ],
        ),
      ),
    );
  }

  // ---------- Bubble chat melayang ----------
  Widget _chatBubble() {
    // Fungsi yang dipanggil saat balon atau tombol diketuk
    void bukaChat() => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatPage()),
        );

    return Column(
      mainAxisSize: MainAxisSize.min, // tingginya secukupnya aja
      crossAxisAlignment: CrossAxisAlignment.end, // rata kanan
      children: [
        // 1. Balon ucapan
        GestureDetector(
          onTap: bukaChat,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x26000000), blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: const Text('Tanya Glowie soal kulitmu',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),

        // 2. Ekor balon: kotak kecil diputar 45 derajat jadi berbentuk berlian,
        // lalu digeser ke atas supaya separuhnya menyatu dengan balon.
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Transform.translate(
            offset: const Offset(0, -6),
            child: Transform.rotate(
              angle: 0.785398, // 45 derajat (dalam radian)
              child: Container(width: 12, height: 12, color: Colors.white),
            ),
          ),
        ),

        // 3. Tombol bulat. Stack dipakai untuk menumpuk titik merah kecil
        // (penanda "ada yang menunggu") di sudut kanan atas.
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: kGreen,
              elevation: 6,
              shadowColor: const Color(0x66000000),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: bukaChat,
                child: const SizedBox(
                  width: 58,
                  height: 58,
                  child: Icon(Icons.chat_bubble_rounded,
                      color: Colors.white, size: 26),
                ),
              ),
            ),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: kRose,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Kartu sapaan ----------
  // ini kartu putih berisi "Halo, Lily!" dan ikon di kanan
  Widget _greetingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang',
                    style: TextStyle(fontSize: 12, color: Colors.brown)),
                SizedBox(height: 4),
                Text('Halo, Lily!',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text(
                  'Teman setia perawatan kulit harianmu. Semua data tersimpan aman secara offline pada perangkat.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: kGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: kGreen),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu utama (hero) ----------
  // kartu besar bergradasi hijau-peach berisi tombol "Mulai Cek Kulit"
  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [kGreenLight, kPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // spaceBetween = dua chip didorong ke ujung kiri dan kanan
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _chip(Icons.offline_bolt_outlined, 'Offline AI Ready'),
              _chip(Icons.schedule, '3 hari lalu'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Yuk, Kenali Kondisi\nKulitmu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
            'Pindai foto wajahmu dan isi kuesioner singkat untuk diagnosis cerdas berbasis Machine Learning.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              // angka 1 = tab Cek Kulit
              onPressed: () => widget.onNavigate(1),
              style: FilledButton.styleFrom(
                backgroundColor: kGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.camera_alt_outlined, size: 18),
              label: const Text('Mulai Cek Kulit'),
            ),
          ),
        ],
      ),
    );
  }

  // chip kecil berbentuk pil putih berisi ikon + teks
  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kGreen),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  // ---------- Judul bagian ----------
  Widget _sectionTitle(String title, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        if (action != null)
          Text(action, style: const TextStyle(fontSize: 12, color: kGreen)),
      ],
    );
  }

  // ---------- Grid fitur ----------
  // Susunan 4 kartu fitur dalam 2 kolom.
  Widget _featureGrid() {
    return GridView.count(
      crossAxisCount: 2, // 2 kolom
      // shrinkWrap + NeverScrollableScrollPhysics: grid ini ada DI DALAM
      // halaman yang sudah bisa scroll, jadi grid tidak boleh scroll sendiri.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12, // jarak antar baris
      crossAxisSpacing: 12, // jarak antar kolom
      childAspectRatio: 1.1, // perbandingan lebar : tinggi tiap kartu
      children: [
        _featureCard(
          Icons.document_scanner_outlined,
          'Cek Produk (OCR)',
          'Pindai label komposisi & cek keamanan bahan.',
          kGreenLight,
          // Dibuka dengan Navigator.push (bukan pindah tab) karena
          // halaman ini tidak punya tab sendiri di menu bawah.
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CekProdukPage()),
          ),
        ),
        _featureCard(
          Icons.check_circle_outline,
          'Rutinitas Harian',
          'Langkah pagi & malam terjadwal rapi.',
          kPeach,
          () => widget.onNavigate(2), // pindah ke tab Rutinitas
        ),
        _featureCard(
          Icons.compare_outlined,
          'Riwayat Analisis',
          'Bandingkan 2 foto untuk evaluasi progres.',
          kGreenLight,
          () => widget.onNavigate(3), // pindah ke tab Riwayat
        ),
        _featureCard(
          Icons.menu_book_outlined,
          'Edukasi Kulit',
          'Ensiklopedia bahan aktif & tips dermatologi.',
          kPeach,
          () {}, // menyusul
        ),
      ],
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle,
      Color iconBg, VoidCallback onTap) {
    // GestureDetector = membuat widget apa pun bisa ditekan
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: kGreen, size: 20),
                ),
                const Icon(Icons.north_east, size: 14, color: Colors.black38),
              ],
            ),
            // Spacer = mendorong widget di bawahnya ke dasar kartu
            const Spacer(),
            Text(title,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle,
                maxLines: 2, // maksimal 2 baris
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 10.5, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  // ---------- Kartu rutinitas ----------
  // Kartu berisi ikon matahari, teks jadwal, dan Switch on/off.
  Widget _routineCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPeach,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rutinitas Pagi • Aktif',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('07:30 Pagi • 5 Langkah hidrasi',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          Switch(
            value: _routineOn, // posisi switch mengikuti variabel ini
            activeThumbColor: Colors.white,
            activeTrackColor: kGreen,
            // Saat switch digeser, Flutter mengirim nilai baru (v = true/false).
            // setState mengubah variabel lalu menggambar ulang layar,
            // sehingga switch benar-benar bergeser.
            onChanged: (v) => setState(() => _routineOn = v),
          ),
        ],
      ),
    );
  }

  // ---------- Artikel ----------
  // Kartu artikel: gambar placeholder di kiri, teks di kanan.
  Widget _articleCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          // Kotak abu-hijau ini placeholder foto; nanti bisa diganti gambar asli
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: kGreenLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image_outlined, color: kGreen),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PANDUAN BAHAN AKTIF',
                    style: TextStyle(fontSize: 10, color: Colors.brown)),
                SizedBox(height: 2),
                Text('Memilih Ceramide yang Tepat untuk Kulitmu',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('Kenali rasio ceramide, kolesterol, dan asam lemak.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tips ----------
  // Kotak hijau muda berisi tips harian dengan ikon lampu.
  Widget _tipCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: kGreen),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips Glowmap Hari Ini • UV Index: 6 (Sedang)',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text(
                  'Jangan lupa aplikasikan ulang sunscreen setiap 2–3 jam saat beraktivitas di luar ruangan!',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Gaya kartu putih yang dipakai bersama oleh semua kartu di halaman ini
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000), // hitam dengan transparansi ~8%
          blurRadius: 10, // seberapa kabur bayangannya
          offset: Offset(0, 4), // bayangan turun 4 piksel ke bawah
        ),
      ],
    );
  }
}