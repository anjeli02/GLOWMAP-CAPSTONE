import 'package:flutter/material.dart';
import 'pages/main_shell.dart'; // halaman induk yang memegang menu bawah

// main() adalah titik awal program. Dart selalu mulai dari sini.
// runApp() menjalankan widget yang kita berikan sebagai akar aplikasi.
void main() => runApp(const GlowmapApp());

// Widget akar aplikasi. StatelessWidget karena pengaturan dasarnya tidak berubah.
class GlowmapApp extends StatelessWidget {
  const GlowmapApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp = pembungkus utama aplikasi bergaya Material Design.
    // Dia mengatur judul, tema, dan halaman pertama yang dibuka.
    return MaterialApp(
      title: 'Glowmap',
      debugShowCheckedModeBanner: false, // sembunyikan pita "DEBUG" di pojok
      theme: ThemeData(
        useMaterial3: true,
        // Warna latar semua halaman (Scaffold) jadi krem
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        // Membuat skema warna otomatis dari 1 warna dasar (hijau)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F6B52)),
      ),
      home: const MainShell(), // halaman pertama yang tampil
    );
  }
}