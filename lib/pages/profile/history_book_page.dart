// Mengimpor paket yang diperlukan
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryBookPage extends StatelessWidget {
  const HistoryBookPage({super.key});

  // Fungsi untuk mengambil riwayat pengguna dari Firestore
  Future<List<Map<String, dynamic>>> fetchHistory() async {
    // Mendapatkan pengguna yang sedang masuk
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Pengguna tidak masuk');
    }

    // Mengambil dokumen riwayat dari Firestore diurutkan berdasarkan timestamp
    final historySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .get();

    // Mengonversi dokumen yang diambil menjadi daftar peta (map)
    return historySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      // FutureBuilder untuk menangani pengambilan data secara asinkron
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchHistory(),
        builder: (context, snapshot) {
          // Menampilkan spinner saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menampilkan pesan kesalahan jika terjadi error
          else if (snapshot.hasError) {
            return const Center(child: Text('Kesalahan saat memuat riwayat'));
          }
          // Menampilkan pesan jika tidak ada data
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada riwayat ditemukan'));
          }
          // Menampilkan daftar riwayat jika data ada
          else {
            final historyBooks = snapshot.data!;
            return ListView.builder(
              itemCount: historyBooks.length,
              itemBuilder: (context, index) {
                final book = historyBooks[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // Menampilkan gambar thumbnail buku
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            book['thumbnail'],
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Menampilkan detail buku
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menampilkan judul buku
                              Text(
                                book['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Menampilkan penulis buku
                              Text(
                                book['authors'].join(', '),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              // Menampilkan tanggal publikasi buku
                              Text(
                                'Published: ${book['publishedDate']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
