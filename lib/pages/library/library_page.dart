import 'package:final_app/components/my_tabbar.dart';
import 'package:flutter/material.dart';

// Definisi kelas LibraryPage yang merupakan StatelessWidget
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold menyediakan struktur dasar untuk halaman
      appBar: AppBar(
        elevation: 3,
        // Mengatur bentuk AppBar dengan sudut bawah melengkung
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          'Perpustakaan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Menonaktifkan tombol kembali secara otomatis
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange.shade400,
      ),
      // Mengatur warna latar belakang halaman
      backgroundColor: Theme.of(context).colorScheme.surface,
      // Menggunakan komponen MyTabBar sebagai isi dari halaman
      body: const MyTabBar(),
    );
  }
}
