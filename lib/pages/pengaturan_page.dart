import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/glowmap_app_bar.dart';

// Halaman Pengaturan (dibuka dari menu "Pengaturan" di halaman Profil).
// StatefulWidget karena switch dan jam pengingat bisa berubah (setState).
class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  // ----- State (data yang bisa berubah) -----
  bool _notifAktif = true;   // switch utama notifikasi rutinitas
  bool _pagiAktif = true;    // switch rutinitas pagi
  bool _malamAktif = true;   // switch rutinitas malam
  TimeOfDay _jamPagi = const TimeOfDay(hour: 7, minute: 30);
  TimeOfDay _jamMalam = const TimeOfDay(hour: 21, minute: 0);

  // Warna latar kotak pengingat (peach sangat muda)
  static const Color _kotakPengingat = Color(0xFFF8EFEA);

  // Ubah TimeOfDay jadi teks "07:30 WIB"
  String _format(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  // Buka pemilih jam bawaan Flutter, lalu simpan hasilnya
  Future<void> _pilihJam(bool pagi) async {
    final hasil = await showTimePicker(
      context: context,
      initialTime: pagi ? _jamPagi : _jamMalam,
    );
    if (hasil != null) {
      setState(() {
        if (pagi) {
          _jamPagi = hasil;
        } else {
          _jamMalam = hasil;
        }
      });
    }
  }

  // Dialog informasi sederhana (untuk menu yang belum punya halaman sendiri)
  void _info(String judul, String isi) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(judul),
        content: Text(isi),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  // Dialog konfirmasi hapus seluruh riwayat (belum menghapus data asli)
  void _hapusRiwayat() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus seluruh riwayat?'),
        content: const Text(
          'Semua hasil dan foto screening akan dihapus permanen. Profilmu tetap tersimpan.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seluruh riwayat dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Color(0xFFC0392B))),
          ),
        ],
      ),
    );
  }

  // Dekorasi kartu putih
  BoxDecoration get _kartu => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      // Panah kembali muncul otomatis karena halaman ini dibuka lewat Navigator.push
      appBar: const GlowmapAppBar(subtitle: 'Pengaturan'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== JUDUL HALAMAN =====
              const Text(
                'SESUAIKAN RITUALMU',
                style: TextStyle(fontSize: 11, letterSpacing: 1.2, color: kGreen, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text('Pengaturan', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(
                'Atur pengingat dan kenyamanan aplikasi, sesuai ritme harianmu.',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 22),

              // ===== SEKSI 1: PENGINGAT & NOTIFIKASI =====
              _judulSeksi('Pengingat & notifikasi'),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: _kartu,
                child: Column(
                  children: [
                    // Baris switch utama
                    Row(
                      children: [
                        _ikonBulat(Icons.notifications_none),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Notifikasi rutinitas',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              SizedBox(height: 2),
                              Text('Pengingat lokal di perangkatmu',
                                  style: TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notifAktif,
                          activeColor: Colors.white,
                          activeTrackColor: kGreen,
                          onChanged: (v) => setState(() => _notifAktif = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0x14000000)),
                    const SizedBox(height: 12),
                    _barisPengingat(
                      ikon: Icons.wb_sunny_outlined,
                      judul: 'Rutinitas pagi',
                      jam: _format(_jamPagi),
                      aktif: _pagiAktif,
                      onGantiJam: () => _pilihJam(true),
                      onSwitch: (v) => setState(() => _pagiAktif = v),
                    ),
                    const SizedBox(height: 10),
                    _barisPengingat(
                      ikon: Icons.nightlight_outlined,
                      judul: 'Rutinitas malam',
                      jam: _format(_jamMalam),
                      aktif: _malamAktif,
                      onGantiJam: () => _pilihJam(false),
                      onSwitch: (v) => setState(() => _malamAktif = v),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Setiap hari · Ketuk jam untuk mengubah jadwal. Pengingat tetap berjalan tanpa internet.',
                      style: TextStyle(fontSize: 11, height: 1.4, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // ===== SEKSI 2: PRIVASI & PENYIMPANAN =====
              _judulSeksi('Privasi & penyimpanan'),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: _kartu,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _ikonBulat(Icons.verified_user_outlined, warna: kGreen, latar: kGreenLight),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data tetap di perangkatmu',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            SizedBox(height: 2),
                            Text('Analisis AI on-device · Tanpa cloud',
                                style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Foto, profil kulit, dan riwayat disimpan secara lokal. Menghapus aplikasi juga dapat menghapus data di perangkat ini.',
                      style: TextStyle(fontSize: 12, height: 1.45),
                    ),
                    const SizedBox(height: 12),
                    // Kotak abu info penyimpanan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F1EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Riwayat & foto screening', style: TextStyle(fontSize: 12)),
                              Text('12,4 MB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text('3 hasil tersimpan di perangkat ini',
                              style: TextStyle(fontSize: 11, color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _info('Privasi data',
                          'Semua analisis berjalan di perangkatmu. Foto dan hasil screening tidak dikirim ke server mana pun.'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Pelajari privasi data',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGreen)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, size: 16, color: kGreen),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ===== KARTU MERAH: HAPUS SELURUH RIWAYAT =====
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _hapusRiwayat,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kRoseLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x33C0392B)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Color(0xFFC0392B)),
                          SizedBox(width: 8),
                          Text('Hapus seluruh riwayat',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFC0392B))),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, size: 18, color: Color(0xFFC0392B)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Menghapus semua hasil dan foto screening secara permanen. Konfirmasi akan diminta sebelum dihapus. Profilmu tetap tersimpan.',
                        style: TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF7A3E39)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // ===== SEKSI 3: TENTANG GLOWMAP =====
              _judulSeksi('Tentang Glowmap'),
              Container(
                decoration: _kartu,
                child: Column(
                  children: [
                    _menu(
                      Icons.info_outline,
                      'Tentang aplikasi',
                      'Glowmap · Versi 1.0.0',
                      () => _info('Tentang aplikasi', 'Glowmap versi 1.0.0\nTeman perawatan kulit harianmu.'),
                    ),
                    const Divider(height: 1, color: Color(0x14000000)),
                    _menu(
                      Icons.menu_book_outlined,
                      'Panduan penggunaan',
                      'Kenali fitur dan batasan analisis',
                      () => _info('Panduan penggunaan',
                          'Ambil foto wajah di tempat terang, ikuti kuesioner, lalu lihat hasil dan rutinitas yang disarankan.'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ===== FOOTER =====
              const Center(
                child: Text(
                  'Teman setia perawatan harianmu.\nDibuat untuk menemani, bukan menggantikan dokter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, height: 1.5, color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Judul tiap seksi
  Widget _judulSeksi(String teks) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(teks, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      );

  // Ikon di dalam lingkaran
  Widget _ikonBulat(IconData ikon, {Color warna = Colors.black54, Color latar = kCream}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: latar, shape: BoxShape.circle),
      child: Icon(ikon, size: 20, color: warna),
    );
  }

  // Kotak pengingat (pagi / malam): ikon, nama, jam (bisa diketuk), switch
  Widget _barisPengingat({
    required IconData ikon,
    required String judul,
    required String jam,
    required bool aktif,
    required VoidCallback onGantiJam,
    required ValueChanged<bool> onSwitch,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: _kotakPengingat, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(ikon, size: 22, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                // Ketuk jam -> muncul pemilih jam
                InkWell(
                  onTap: _notifAktif ? onGantiJam : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(jam, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(width: 6),
                      const Icon(Icons.edit_outlined, size: 13, color: Colors.black54),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: aktif && _notifAktif,
            activeColor: Colors.white,
            activeTrackColor: kGreen,
            // Kalau switch utama mati, switch anak ikut nonaktif (onChanged null)
            onChanged: _notifAktif ? onSwitch : null,
          ),
        ],
      ),
    );
  }

  // Baris menu di seksi "Tentang"
  Widget _menu(IconData ikon, String judul, String sub, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: _ikonBulat(ikon),
      title: Text(judul, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
    );
  }
}