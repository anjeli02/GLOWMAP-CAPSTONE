import 'package:flutter/material.dart';
import '../colors.dart';

class RoutineStep {
  final String category;
  final String badge;
  final String name;
  final String desc;
  final IconData icon;
  bool done;

  RoutineStep({
    required this.category,
    required this.badge,
    required this.name,
    required this.desc,
    required this.icon,
    this.done = false,
  });
}

class RutinitasPage extends StatefulWidget {
  const RutinitasPage({super.key});

  @override
  State<RutinitasPage> createState() => _RutinitasPageState();
}

class _RutinitasPageState extends State<RutinitasPage> {
  bool _isMorning = true;
  bool _morningReminder = true;
  bool _nightReminder = true;

  final List<RoutineStep> _morning = [
    RoutineStep(
      category: 'PEMBERSIH WAJAH (CLEANSER)',
      badge: 'Rutin',
      name: 'Gentle Low pH Gel Cleanser',
      desc: 'Membersihkan sisa minyak dan debu tanpa mengikis lapisan pelindung kulit.',
      icon: Icons.water_drop_outlined,
      done: true,
    ),
    RoutineStep(
      category: 'TONER / ESSENCE (TONER)',
      badge: 'Opsional',
      name: 'Centella Soothing Essence Toner',
      desc: 'Menenangkan kemerahan dan menyiapkan kulit menyerap serum.',
      icon: Icons.opacity_outlined,
      done: true,
    ),
    RoutineStep(
      category: 'SERUM PERAWATAN (SERUM)',
      badge: 'Rutin',
      name: 'Niacinamide 5% Barrier Serum',
      desc: 'Membantu mengontrol minyak, menyamarkan pori, dan memperkuat barrier kulit.',
      icon: Icons.science_outlined,
      done: true,
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

  final List<RoutineStep> _night = [
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

  List<RoutineStep> get _steps => _isMorning ? _morning : _night;
  int get _doneCount => _steps.where((s) => s.done).length;
  double get _progress => _steps.isEmpty ? 0 : _doneCount / _steps.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
            const SizedBox(height: 14),
            _progressCard(),
            const SizedBox(height: 20),
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

  // ---------- App bar ----------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kCream,
      elevation: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Glowmap',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          Text('Rutinitas',
              style: TextStyle(fontSize: 11, color: Colors.black54)),
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
    final morningDone = _morning.where((s) => s.done).length;
    final nightDone = _night.where((s) => s.done).length;

    Widget tab(String label, int done, int total, bool selected, bool morning) {
      return Expanded(
        child: GestureDetector(
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
                const SizedBox(width: 6),
                Text('$done/$total',
                    style: const TextStyle(fontSize: 11, color: Colors.black45)),
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
          tab('Pagi Hari', morningDone, _morning.length, _isMorning, true),
          tab('Malam Hari', nightDone, _night.length, !_isMorning, false),
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

  // ---------- Kartu progress ----------
  Widget _progressCard() {
    final sisa = _steps.length - _doneCount;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_isMorning ? 'Progres Rutinitas Pagi' : 'Progres Rutinitas Malam',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              Text('${(_progress * 100).round()}% Selesai',
                  style: const TextStyle(
                      fontSize: 12,
                      color: kGreen,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: kGreenLight,
              valueColor: const AlwaysStoppedAnimation(kGreen),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sisa == 0
                ? 'Hebat! Semua langkah hari ini sudah selesai.'
                : '$sisa langkah lagi untuk menutup sesi rutinitas hari ini',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------- Kartu langkah ----------
  Widget _stepCard(int index, RoutineStep step) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration:
                            step.done ? TextDecoration.lineThrough : null,
                        color: step.done ? Colors.black45 : Colors.black87)),
                const SizedBox(height: 3),
                Text(step.desc,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => step.done = !step.done),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.done ? kGreen : Colors.transparent,
                border: Border.all(
                    color: step.done ? kGreen : Colors.black26, width: 1.5),
              ),
              child: step.done
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Pengingat ----------
  Widget _reminderCard() {
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