import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';

// Satu langkah rutinitas skincare. Class ini hanya "wadah data"
// (tidak ada status ceklis lagi, karena list hanya untuk dilihat).
class RoutineStep {
  final String category;
  final String badge;
  final String name;
  final String desc;
  final IconData icon;

  const RoutineStep({
    required this.category,
    required this.badge,
    required this.name,
    required this.desc,
    required this.icon,
  });
}

// StatefulWidget karena ada toggle Pagi/Malam dan Switch pengingat yang berubah.
class RutinitasPage extends StatefulWidget {
  const RutinitasPage({super.key});

  @override
  State<RutinitasPage> createState() => _RutinitasPageState();
}

class _RutinitasPageState extends State<RutinitasPage> {
  bool _isMorning = true; // true = tab Pagi, false = tab Malam
  bool _morningReminder = true;
  bool _nightReminder = true;

  // Daftar langkah rutinitas pagi
  final List<RoutineStep> _morning = const [
    RoutineStep(
      category: 'PEMBERSIH WAJAH (CLEANSER)',
      badge: 'Rutin',
      name: 'Gentle Low pH Gel Cleanser',
      desc: 'Membersihkan sisa minyak dan debu tanpa mengikis lapisan pelindung kulit.',
      icon: Icons.water_drop_outlined,
    ),
    RoutineStep(
      category: 'TONER / ESSENCE (TONER)',
      badge: 'Opsional',
      name: 'Centella Soothing Essence Toner',
      desc: 'Menenangkan kemerahan dan menyiapkan kulit menyerap serum.',
      icon: Icons.opacity_outlined,
    ),
    RoutineStep(
      category: 'SERUM PERAWATAN (SERUM)',
      badge: 'Rutin',
      name: 'Niacinamide 5% Barrier Serum',
      desc: 'Membantu mengontrol minyak, menyamarkan pori, dan memperkuat barrier kulit.',
      icon: Icons.science_outlined,
    ),
    RoutineStep(
      category: 'PELEMBAP (MOISTURIZER)',
      badge: 'Rutin',
      name: 'Ceramide Calm Gel Moisturizer',
      desc: 'Mengunci kelembapan dan menjaga kulit tetap lembut sepanjang hari.',
      icon: Icons.spa_outlined,
    ),
    RoutineStep(
      category: 'TABIR SURYA (SUNSCREEN)',
      badge: 'SPF 50+',
      name: 'UV Watery Sunscreen SPF 50+ PA++++',
      desc: 'Wajib dipakai setiap pagi untuk melindungi kulit dari paparan sinar UV.',
      icon: Icons.wb_sunny_outlined,
    ),
  ];

  // Daftar langkah rutinitas malam
  final List<RoutineStep> _night = const [
    RoutineStep(
      category: 'PEMBERSIH MINYAK (OIL CLEANSER)',
      badge: 'Rutin',
      name: 'Gentle Cleansing Oil',
      desc: 'Mengangkat sunscreen dan makeup sebelum mencuci wajah.',
      icon: Icons.water_drop_outlined,
    ),
    RoutineStep(
      category: 'PEMBERSIH WAJAH (CLEANSER)',
      badge: 'Rutin',
      name: 'Gentle Low pH Gel Cleanser',
      desc: 'Membersihkan sisa minyak dan debu tanpa mengikis lapisan pelindung kulit.',
      icon: Icons.bubble_chart_outlined,
    ),
    RoutineStep(
      category: 'SERUM PERAWATAN (SERUM)',
      badge: 'Rutin',
      name: 'Centella Repair Serum',
      desc: 'Membantu memperbaiki dan menenangkan kulit saat malam hari.',
      icon: Icons.science_outlined,
    ),
    RoutineStep(
      category: 'PELEMBAP (MOISTURIZER)',
      badge: 'Rutin',
      name: 'Ceramide Calm Gel Moisturizer',
      desc: 'Mengunci kelembapan agar barrier kulit pulih selama tidur.',
      icon: Icons.spa_outlined,
    ),
  ];

  // Getter: daftar yang ditampilkan mengikuti tab yang aktif
  List<RoutineStep> get _steps => _isMorning ? _morning : _night;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlowmapAppBar(subtitle: 'Rutinitas'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 14),
            _toggle(),
            const SizedBox(height: 14),
            _aiCard(),
            const SizedBox(height: 20),
            // Judul daftar + jumlah tahapan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isMorning ? 'Langkah Rutinitas Pagi' : 'Langkah Rutinitas Malam',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text('${_steps.length} Tahapan',
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            // Satu kartu per langkah, dibuat lewat perulangan
            for (int i = 0; i < _steps.length; i++) ...[
              _stepCard(i, _steps[i]),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            _reminderCard(),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Ubah Urutan / Tambah Langkah Rutinitas'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.bookmark_border, size: 18),
                label: const Text('Simpan Jurnal Kulit Hari Ini'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('RITUAL HARIAN',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.brown,
                    fontWeight: FontWeight.w600)),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kPeach,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department,
                      size: 14, color: Colors.deepOrange),
                  SizedBox(width: 4),
                  Text('6 Hari Konsisten', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Langkah perawatan kulit menjaga keseimbangan barrier dan skin optimalmu.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  // ---------- Toggle Pagi / Malam ----------
  Widget _toggle() {
    // Fungsi kecil di dalam fungsi: membuat satu tab (Pagi atau Malam).
    // selected = tab ini sedang aktif, morning = tab ini adalah tab Pagi.
    Widget tab(String label, bool selected, bool morning) {
      return Expanded(
        child: GestureDetector(
          // Saat ditekan, ganti tab lalu gambar ulang layar
          onTap: () => setState(() => _isMorning = morning),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? kGreenLight : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(morning ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                    size: 16, color: selected ? kGreen : Colors.black54),
                const SizedBox(width: 6),
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? kGreen : Colors.black54)),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14000000)),
      ),
      child: Row(
        children: [
          tab('Pagi Hari', _isMorning, true),
          tab('Malam Hari', !_isMorning, false),
        ],
      ),
    );
  }

  // ---------- Kartu hasil analisis AI ----------
  Widget _aiCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: kGreen, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HASIL ANALISIS AI • Terverifikasi',
                    style: TextStyle(
                        fontSize: 10,
                        color: kGreen,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text(
                  'Rutinitas dibuat dari diagnosa Kulit Kombinasi & Sensitif dari hasil Cek Kulit terakhir kamu.',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu langkah (hanya tampilan, tanpa ceklis) ----------
  Widget _stepCard(int index, RoutineStep step) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kotak ikon; warnanya bergantian hijau/peach (index genap/ganjil)
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: index.isEven ? kGreenLight : kPeach,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(step.icon, color: kGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(step.category,
                          style: const TextStyle(
                              fontSize: 9.5,
                              color: Colors.brown,
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: kCream,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(step.badge,
                          style: const TextStyle(fontSize: 9.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(step.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
                const SizedBox(height: 3),
                Text(step.desc,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Pengingat ----------
  Widget _reminderCard() {
    // Fungsi kecil untuk membuat satu baris pengingat (ikon, teks, Switch)
    Widget row(IconData icon, Color iconColor, String title, String time,
        bool value, ValueChanged<bool> onChanged) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kCream,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                Text(time,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: kGreen,
            onChanged: onChanged,
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active_outlined,
                  size: 18, color: kGreen),
              SizedBox(width: 8),
              Text('Pengingat Rutinitas',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          row(Icons.wb_sunny_outlined, Colors.orange, 'Pengingat Pagi',
              '07:00 WIB', _morningReminder,
              (v) => setState(() => _morningReminder = v)),
          const SizedBox(height: 8),
          row(Icons.nightlight_outlined, Colors.indigo, 'Pengingat Malam',
              '21:00 WIB', _nightReminder,
              (v) => setState(() => _nightReminder = v)),
        ],
      ),
    );
  }

  // Gaya kartu putih bersama
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}