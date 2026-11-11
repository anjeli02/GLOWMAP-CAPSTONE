import 'package:flutter/material.dart';
import '../colors.dart';

// Satu pesan di dalam percakapan
class _Pesan {
  final String teks;
  final bool dariUser; // true = Lily (kanan), false = Glowie (kiri)
  const _Pesan(this.teks, this.dariUser);
}

// Halaman chat dengan Glowie (asisten skincare).
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _input = TextEditingController(); // isi kolom ketik
  final _scroll = ScrollController(); // untuk scroll otomatis ke bawah
  bool _mengetik = false; // true = Glowie "sedang mengetik"

  // Daftar pesan. Sudah berisi contoh percakapan tentang skincare
  final List<_Pesan> _pesan = [
    const _Pesan(
        'Halo, Lily! Aku Glowie 🌿 asisten kulitmu. Tanya apa saja seputar skincare dan perawatan kulit ya.',
        false),
    const _Pesan('Kulitku kombinasi cenderung berminyak, tapi pipiku sering kemerahan. Harus pakai apa ya?', true),
    const _Pesan(
        'Dari hasil screening-mu, kulitmu kombinasi berminyak dan agak reaktif. Beberapa saran:\n\n'
        '• Pakai pembersih gel yang lembut dengan pH rendah\n'
        '• Niacinamide membantu mengontrol minyak di T-zone\n'
        '• Centella menenangkan kemerahan di pipi\n'
        '• Tetap pakai pelembap ringan dan sunscreen tiap pagi ☀️',
        false),
    const _Pesan('Niacinamide boleh dipakai bareng Hyaluronic Acid nggak?', true),
    const _Pesan(
        'Boleh banget! Niacinamide dan Hyaluronic Acid adalah pasangan yang aman. Niacinamide mengatur minyak dan menenangkan, sedangkan Hyaluronic Acid menjaga kulit tetap terhidrasi 💧\n\n'
        'Mulai dari konsentrasi rendah dulu ya, dan lakukan patch test sebelum dipakai ke seluruh wajah.',
        false),
  ];

  // Pertanyaan cepat (chip) di atas kolom ketik
  static const _cepat = [
    'Urutan skincare yang benar?',
    'Cara atasi jerawat meradang',
    'Bahan yang tidak boleh dicampur',
    'Kapan pakai sunscreen?',
    'Tips kulit berminyak',
    'Tips kulit sensitif',
  ];

  // ---------- "Otak" demo: cari jawaban dari kata kunci ----------
  String _jawab(String tanya) {
    final q = tanya.toLowerCase();
    bool ada(List<String> kata) => kata.any((k) => q.contains(k));

    if (ada(['urutan', 'rutin', 'langkah'])) {
      return 'Urutan dasar skincare:\n\n'
          '☀️ Pagi: pembersih → toner → serum → pelembap → sunscreen\n'
          '🌙 Malam: pembersih (double cleanse kalau pakai sunscreen/makeup) → toner → serum/treatment → pelembap\n\n'
          'Aturan umumnya: dari tekstur paling encer ke paling kental.';
    }
    if (ada(['campur', 'bareng', 'bersamaan', 'tidak boleh'])) {
      return 'Hati-hati mencampur bahan kuat bersamaan:\n\n'
          '• Retinol + AHA/BHA atau vitamin C kuat → rawan iritasi, pakai selang-seling hari atau beda waktu (pagi/malam)\n'
          '• Benzoyl peroxide + retinol → bisa saling melemahkan dan membuat kering\n\n'
          'Yang aman dipasangkan: Niacinamide + Hyaluronic Acid. Kenalkan bahan baru satu per satu ya.';
    }
    if (ada(['jerawat', 'acne', 'meradang', 'jerawatan'])) {
      return 'Untuk jerawat meradang:\n\n'
          '• Jangan dipencet, nanti bekasnya lebih lama hilang\n'
          '• Cuci muka lembut 2x sehari\n'
          '• Cari bahan penenang seperti Centella dan Niacinamide\n'
          '• Azelaic Acid bisa membantu jerawat dan kemerahan\n\n'
          'Kalau jerawat nyeri, banyak, atau tidak membaik berminggu-minggu, sebaiknya periksa ke dokter kulit.';
    }
    if (ada(['sunscreen', 'spf', 'tabir surya', 'sunblock'])) {
      return 'Sunscreen dipakai setiap pagi sebagai langkah terakhir skincare, bahkan saat mendung atau di dalam ruangan.\n\n'
          '• Pilih SPF 30+ dan PA+++\n'
          '• Takaran sekitar dua ruas jari untuk wajah dan leher\n'
          '• Ulangi tiap 2–3 jam kalau beraktivitas di luar ruangan ☀️';
    }
    if (ada(['berminyak', 'minyak', 'sebum'])) {
      return 'Tips kulit berminyak:\n\n'
          '• Pakai pembersih gel yang lembut, jangan terlalu sering cuci muka\n'
          '• Niacinamide membantu mengontrol minyak\n'
          '• Tetap pakai pelembap ringan non-komedogenik, kulit berminyak juga butuh hidrasi 💧';
    }
    if (ada(['sensitif', 'perih', 'kemerahan', 'iritasi'])) {
      return 'Tips kulit sensitif:\n\n'
          '• Pilih produk minim pewangi dan alkohol\n'
          '• Lakukan patch test di belakang telinga sebelum memakai produk baru\n'
          '• Kenalkan satu produk baru dalam satu waktu\n'
          '• Centella dan pelembap yang menguatkan skin barrier bisa membantu menenangkan 🌿';
    }
    if (ada(['kering', 'dehidrasi', 'lembap', 'lembab'])) {
      return 'Untuk kulit kering atau dehidrasi, pakai pelembap dengan Hyaluronic Acid, ceramide, atau gliserin. Aplikasikan saat wajah masih sedikit lembap supaya kelembapan terkunci.';
    }
    if (ada(['halo', 'hai', 'hi ', 'selamat', 'makasih', 'terima kasih'])) {
      return 'Halo! Senang ngobrol denganmu 🌿 Mau tanya soal skincare apa hari ini?';
    }
    // Di luar topik skincare
    return 'Hmm, aku belum paham pertanyaan itu 🙈 Aku cuma bisa bantu seputar skincare dan perawatan kulit. Coba pilih salah satu pertanyaan cepat di bawah ya!';
  }

  // Kirim pesan user, lalu Glowie membalas setelah jeda singkat
  Future<void> _kirim(String teks) async {
    final isi = teks.trim();
    if (isi.isEmpty || _mengetik) return;

    setState(() {
      _pesan.add(_Pesan(isi, true));
      _mengetik = true;
    });
    _input.clear();
    _keBawah();

    // Jeda 800 ms supaya terasa seperti sedang mengetik
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return; // halaman sudah ditutup -> berhenti

    setState(() {
      _pesan.add(_Pesan(_jawab(isi), false));
      _mengetik = false;
    });
    _keBawah();
  }

  // Scroll otomatis ke pesan paling bawah
  void _keBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Saat halaman dibuka, langsung scroll ke pesan paling bawah
    _keBawah();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
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
            // Avatar Glowie
            Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
                color: kGreenLight,
                shape: BoxShape.circle,
            ),
            child: const Icon(
                Icons.support_agent,
                color: kGreen,
                size: 20,
            ),
            ),
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
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                // Catatan kecil di atas
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kGreenLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text('Jawaban bersifat edukasi, bukan pengganti dokter.',
                        style: TextStyle(fontSize: 11, color: kGreen)),
                  ),
                ),
                for (final p in _pesan) _bubble(p),
                if (_mengetik) _bubbleMengetik(),
              ],
            ),
          ),

          // ===== Pertanyaan cepat (bisa digeser ke samping) =====
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _cepat.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ActionChip(
                label: Text(_cepat[i], style: const TextStyle(fontSize: 12, color: kGreen)),
                backgroundColor: Colors.white,
                side: const BorderSide(color: kGreenLight),
                onPressed: () => _kirim(_cepat[i]),
              ),
            ),
          ),

          // ===== Kolom ketik + tombol kirim =====
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
                      child: TextField(
                        controller: _input,
                        onSubmitted: _kirim, // tekan Enter = kirim
                        textInputAction: TextInputAction.send,
                        decoration: const InputDecoration(
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
                      onPressed: () => _kirim(_input.text),
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
  Widget _bubble(_Pesan p) {
    final user = p.dariUser;
    return Align(
      // User di kanan, Glowie di kiri
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        // Batasi lebar gelembung maksimal 78% lebar layar
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
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
          p.teks,
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: user ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // Gelembung "Glowie sedang mengetik..."
  Widget _bubbleMengetik() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: const Text('Glowie sedang mengetik...',
            style: TextStyle(fontSize: 12, color: Colors.black45, fontStyle: FontStyle.italic)),
      ),
    );
  }
}