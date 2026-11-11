import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cek_kulit_page.dart';
import 'hasil_analisis_page.dart';
import 'rutinitas_page.dart';
import 'riwayat_page.dart';
import 'profile_page.dart';

// Kerangka utama: bottom navigation + isi halaman per tab.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;          // tab yang sedang aktif
  bool _hasilOpen = false; // true = tab Cek Kulit menampilkan Hasil Analisis

  // Ganti tab. Kalau balik ke Cek Kulit, kembalikan ke tampilan awal.
  void _select(int i) {
    setState(() {
      _index = i;
      if (i == 1) _hasilOpen = false;
    });
  }

  void _bukaHasil() => setState(() => _hasilOpen = true);
  void _tutupHasil() => setState(() => _hasilOpen = false);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(onNavigate: _select),
      _hasilOpen
          ? HasilAnalisisPage(onBack: _tutupHasil)
          : CekKulitPage(onLanjut: _bukaHasil),
      const RutinitasPage(),
      const RiwayatPage(),                // tab Riwayat
      ProfilePage(onNavigate: _select),   // tab Profil
    ];

    return Scaffold(
      // IndexedStack: semua halaman tetap hidup, hanya yang aktif ditampilkan
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.face_retouching_natural_outlined), selectedIcon: Icon(Icons.face_retouching_natural), label: 'Cek Kulit'),
          NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'Rutinitas'),
          NavigationDestination(icon: Icon(Icons.show_chart), selectedIcon: Icon(Icons.show_chart), label: 'Riwayat'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}