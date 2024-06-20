import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/pages/book/detail_book_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Halaman DownloadContentPage merupakan StatelessWidget
class DownloadContentPage extends StatelessWidget {
  const DownloadContentPage({super.key});

  // Fungsi untuk mengambil daftar buku yang diunduh pengguna dari Firestore
  Future<List<Map<String, dynamic>>> fetchDownloads() async {
    // Mendapatkan pengguna yang sedang masuk
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Mengambil dokumen unduhan dari Firestore
    final downloadsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('downloads')
        .get();

    // Mengonversi dokumen yang diambil menjadi daftar peta (map)
    return downloadsSnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengatur warna latar belakang halaman sesuai dengan skema warna tema
      backgroundColor: Theme.of(context).colorScheme.surface,

      // FutureBuilder untuk menangani pengambilan data secara asinkron
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDownloads(),
        builder: (context, snapshot) {
          // Menampilkan spinner saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menampilkan pesan kesalahan jika terjadi error
          else if (snapshot.hasError) {
            return const Center(child: Text('Error Memuat Buku Yang Didownload'));
          }
          // Menampilkan pesan jika tidak ada data
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Masih Kosong'));
          }
          // Menampilkan daftar buku yang diunduh jika data tersedia
          else {
            final downloadedBooks = snapshot.data!;
            return ListView.builder(
              itemCount: downloadedBooks.length,
              itemBuilder: (context, index) {
                final book = downloadedBooks[index];
                return GestureDetector(
                  onTap: () async {
                    try {
                      // Navigasi ke halaman detail buku menggunakan Get
                      Get.to(() => BookDetailPage(bookId: book['id']));
                    } catch (e) {
                      debugPrint('Error navigating to book details: $e');
                    }
                  },
                  child: Card(
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
                              ],
                            ),
                          ),
                        ],
                      ),
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
