import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/pages/book/detail_book_page.dart';

class FavoritContentPage extends StatelessWidget {
  const FavoritContentPage({super.key});

  // Fungsi untuk mengambil daftar buku favorit pengguna dari Firestore
  Future<List<Map<String, dynamic>>> fetchFavorites() async {
    // Mendapatkan pengguna yang sedang masuk
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    // Mengambil dokumen favorit dari Firestore
    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    // Mengonversi dokumen yang diambil menjadi daftar peta (map)
    return favoritesSnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengatur warna latar belakang halaman sesuai dengan skema warna tema
      backgroundColor: Theme.of(context).colorScheme.surface,

      // FutureBuilder untuk menangani pengambilan data secara asinkron
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFavorites(),
        builder: (context, snapshot) {
          // Menampilkan spinner saat menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Menampilkan pesan kesalahan jika terjadi error
          else if (snapshot.hasError) {
            return const Center(child: Text('Error Memuat Buku'));
          }
          // Menampilkan pesan jika tidak ada data
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Masih Kosong'));
          }
          // Menampilkan daftar buku favorit jika data tersedia
          else {
            final favoriteBooks = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
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
