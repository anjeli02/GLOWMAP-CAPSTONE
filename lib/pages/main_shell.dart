import 'package:flutter/material.dart';
import '../colors.dart';
import 'home_page.dart';
import 'cek_kulit_page.dart';
import 'hasil_analisis_page.dart';
import 'rutinitas_page.dart';

// "Shell" = kerangka aplikasi yang memegang menu bawah (NavigationBar)
// dan menampilkan halaman sesuai tab yang dipilih.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // nomor tab yang sedang aktif. 0 = Beranda, 1 = Cek Kulit, dst.
  int _index = 0;

  // Apakah tab Cek Kulit sedang menampilkan halaman Hasil Analisis?
  // false = tampil halaman scan, true = tampil hasil analisis.
  bool _hasilOpen = false;

  // Pindah tab. setState memberi tahu Flutter agar layar digambar ulang.
  // Kalau tab Cek Kulit (1) dipilih, selalu mulai dari halaman scan.
  void _select(int i) {
    setState(() {
      if (i == 1) _hasilOpen = false;
      _index = i;
    });
  }

  // Dari halaman scan -> buka hasil analisis (menu bawah tetap terlihat)
  void _bukaHasil() => setState(() => _hasilOpen = true);

  // Dari hasil analisis -> kembali ke halaman scan (panah back)
  void _tutupHasil() => setState(() => _hasilOpen = false);

  // Dari hasil analisis -> tutup hasil, lalu pindah ke tab Rutinitas (2)
  void _lihatRutinitas() {
    setState(() {
      _hasilOpen = false;
      _index = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman. Urutannya HARUS sama dengan urutan tab di menu bawah.
    final pages = <Widget>[
      HomePage(onNavigate: _select), // kirim fungsi _select ke HomePage
      // Tab Cek Kulit: tampilkan hasil analisis kalau _hasilOpen true,
      // kalau tidak tampilkan halaman scan.
      _hasilOpen
          ? HasilAnalisisPage(
              onBack: _tutupHasil,
              onLihatRutinitas: _lihatRutinitas,
            )
          : CekKulitPage(onLanjut: _bukaHasil),
      const RutinitasPage(),
      const _ComingSoonPage(title: 'Riwayat'),
      const _ComingSoonPage(title: 'Profil'),
    ];

    return Scaffold(
      // IndexedStack menumpuk semua halaman tapi hanya menampilkan satu
      // sesuai index, jadi state tiap halaman (misal centang Rutinitas)
      // tidak hilang saat pindah tab.
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index, // tab yang disorot
        onDestinationSelected: _select, // dipanggil saat tab ditekan
        backgroundColor: Colors.white,
        indicatorColor: kGreenLight,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda'),
          NavigationDestination(
              icon: Icon(Icons.face_outlined),
              selectedIcon: Icon(Icons.face),
              label: 'Cek Kulit'),
          NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: 'Rutinitas'),
          NavigationDestination(
              icon: Icon(Icons.show_chart),
              selectedIcon: Icon(Icons.show_chart),
              label: 'Riwayat'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil'),
        ],
      ),
    );
  }
}

// Halaman sementara untuk tab yang belum dibuat
class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCream,
        elevation: 0, // 0 = tanpa bayangan di bawah AppBar
        title: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
      body: Center(
        // $title = menyisipkan isi variabel ke dalam teks
        child: Text(' $title nyusul ini',
            style: const TextStyle(color: Colors.black54)),
      ),
    );
  }
}