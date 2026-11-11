import 'package:flutter/material.dart';
import 'pages/login_page.dart';

// Titik awal aplikasi. Dijalankan pertama kali oleh Flutter.
void main() {
  runApp(const GlowmapApp());
}

class GlowmapApp extends StatelessWidget {
  const GlowmapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glowmap',
      debugShowCheckedModeBanner: false, // hilangkan pita "DEBUG"
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4F6B52), // warna utama hijau
        scaffoldBackgroundColor: const Color(0xFFFAF7F2), // latar krem
      ),
      // Halaman pertama = Login. Dari sana: Masuk/Daftar -> MainShell (Beranda)
      home: const LoginPage(),
    );
  }
}