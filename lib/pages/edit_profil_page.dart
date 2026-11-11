import 'package:flutter/material.dart';
import '../colors.dart';

// Halaman Edit Profil. StatefulWidget karena ada isian form
// dan pilihan chip yang berubah saat disentuh (setState).
class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  // Controller = penyimpan isi TextField
  final _namaC = TextEditingController(text: 'Lily');
  final _emailC = TextEditingController();
  final _umurC = TextEditingController(text: '21');

  @override
  void dispose() {
    // Controller wajib dibuang supaya tidak memory leak
    _namaC.dispose();
    _emailC.dispose();
    _umurC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        backgroundColor: kCream,
        elevation: 0,
        title: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto profil + tombol kamera kecil
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: kRoseLight,
                    child: Icon(Icons.person, size: 54, color: kRose),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: kGreen,
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Nama panggilan', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _field(_namaC, TextInputType.text),
            const SizedBox(height: 16),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _field(_emailC, TextInputType.emailAddress),
            const SizedBox(height: 16),

            const Text('Usia', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _field(_umurC, TextInputType.number),
            const SizedBox(height: 28),

            // Tombol simpan: tampilkan SnackBar lalu kembali ke Profil
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil disimpan')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper TextField bergaya putih membulat
  Widget _field(TextEditingController c, TextInputType type) {
    return TextField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}