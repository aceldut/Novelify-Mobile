import 'package:flutter/material.dart';

// Halaman Informasi Aplikasi
class InformasiPage extends StatelessWidget {
  const InformasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(
        title: const Text(
          'Informasi Aplikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Tentang Aplikasi
            Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Aplikasi ini adalah aplikasi manajemen buku yang menyediakan fitur pencarian, '
              'penyimpanan buku favorit, dan membaca buku secara online. Dengan aplikasi ini, '
              'pengguna dapat dengan mudah mencari dan membaca buku dari berbagai kategori.',
            ),
            SizedBox(height: 20),
            // Bagian Tentang Pengembang
            Text(
              'Tentang Pengembang',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Informasi Pengembang 1
            DeveloperInfo(
              name: 'Marcellio Aurel Christian',
              role: 'Lead Developer / 22082010019',
              imageUrl: 'assets/marcel.jpg',
              description:
                  'Sebagai Lead Developer untuk Novelify yang inovatif, saya bertanggung jawab untuk memimpin tim pengembang dalam menciptakan platform yang efisien, skalabel, dan menarik bagi pengguna. Peran ini mengharuskan kombinasi keterampilan teknis yang kuat, kepemimpinan yang efektif, dan kemampuan untuk bekerja dalam lingkungan yang dinamis dan kolaboratif.',
            ),
            SizedBox(height: 20),
            // Informasi Pengembang 2
            DeveloperInfo(
              name: 'Nabila Ahlisya',
              role: 'UI/UX Designer / 22082010017',
              imageUrl: 'assets/nabila.jpg',
              description:
                  'Sebagai UI/UX Designer untuk Novelify, Saya bertanggung jawab untuk merancang antarmuka pengguna yang intuitif dan menarik, serta menciptakan pengalaman pengguna yang luar biasa. Saya bekerja sama dengan tim pengembang, produk, dan pemangku kepentingan lainnya untuk memastikan aplikasi ini mudah digunakan dan memenuhi kebutuhan pengguna.',
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk menampilkan informasi pengembang
class DeveloperInfo extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final String description;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Menampilkan avatar pengembang
        CircleAvatar(
          backgroundImage: AssetImage(imageUrl),
          radius: 50,
        ),
        const SizedBox(width: 20),
        // Menampilkan detail pengembang
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                role,
              ),
              const SizedBox(height: 10),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }
}
