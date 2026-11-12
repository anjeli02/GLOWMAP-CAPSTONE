import 'package:flutter/material.dart';
import '../colors.dart';

// Halaman chat dengan Glowie (asisten skincare).
// Hanya tampilan (UI): isinya contoh percakapan tetap, belum ada fungsi kirim.
// StatelessWidget karena tidak ada data yang berubah.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  // Isi percakapan: (teks, dariUser). dariUser true = Lily (kanan),
  // false = Glowie (kiri).
  static const _pesan = [
    (
      'Halo, Lily! Aku Glowie 🌿 asisten kulitmu. Tanya apa saja seputar skincare dan perawatan kulit ya.',
      false
    ),
    (
      'Kulitku kombinasi cenderung berminyak, tapi pipiku sering kemerahan. Harus pakai apa ya?',
      true
    ),
    (
      'Dari hasil screening-mu, kulitmu kombinasi berminyak dan agak reaktif. Beberapa saran:\n\n'
          '• Pakai pembersih gel yang lembut dengan pH rendah\n'
          '• Niacinamide membantu mengontrol minyak di T-zone\n'
          '• Centella menenangkan kemerahan di pipi\n'
          '• Tetap pakai pelembap ringan dan sunscreen tiap pagi ☀️',
      false
    ),
    ('Niacinamide boleh dipakai bareng Hyaluronic Acid nggak?', true),
    (
      'Boleh banget! Niacinamide dan Hyaluronic Acid adalah pasangan yang aman. Niacinamide mengatur minyak dan menenangkan, sedangkan Hyaluronic Acid menjaga kulit tetap terhidrasi 💧\n\n'
          'Mulai dari konsentrasi rendah dulu ya, dan lakukan patch test sebelum dipakai ke seluruh wajah.',
      false
    ),
    ('Kalau sunscreen, kapan harus dipakai ulang?', true),
    (
      'Pakai sunscreen setiap pagi sebagai langkah terakhir skincare. Kalau beraktivitas di luar ruangan, ulangi tiap 2–3 jam ya ☀️',
      false
    ),
  ];

  // Avatar bulat berisi logo Glowmap (dipakai di AppBar dan di samping pesan Glowie)
  Widget _avatarGlowie(double ukuran) {
    return Container(
      width: ukuran,
      height: ukuran,
      padding: EdgeInsets.all(ukuran * 0.12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset(
        'assets/images/logo_icon.png',
        // Cadangan kalau gambar gagal dimuat
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.spa_outlined, color: kGreen, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        backgroundColor: kCream,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            _avatarGlowie(40),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Glowie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text('Asisten kulit Glowmap',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ===== Daftar pesan =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                // Catatan kecil di atas
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kGreenLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('Jawaban bersifat edukasi, bukan pengganti dokter.',
                        style: TextStyle(fontSize: 11, color: kGreen)),
                  ),
                ),
                // for ... in = buat 1 gelembung untuk setiap pesan
                for (final p in _pesan) _bubble(context, p.$1, p.$2),
              ],
            ),
          ),

          // ===== Kolom ketik + tombol kirim (tampilan saja) =====
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Tulis pertanyaan seputar kulit...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.black38),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: kGreen,
                    child: IconButton(
                      onPressed: () {}, // belum ada fungsi
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Gelembung 1 pesan ----------
  Widget _bubble(BuildContext context, String teks, bool user) {
    final gelembung = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      // Batasi lebar gelembung maksimal 72% lebar layar
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
      decoration: BoxDecoration(
        color: user ? kGreen : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(user ? 18 : 4),
          bottomRight: Radius.circular(user ? 4 : 18),
        ),
        boxShadow: user
            ? null
            : const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Text(
        teks,
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          color: user ? Colors.white : Colors.black87,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: user
          // Pesan Lily: rata kanan, tanpa avatar
          ? Align(alignment: Alignment.centerRight, child: gelembung)
          // Pesan Glowie: avatar logo di kiri + gelembung
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _avatarGlowie(30),
                const SizedBox(width: 8),
                gelembung,
              ],
            ),
    );
  }
}