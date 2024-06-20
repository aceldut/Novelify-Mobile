import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/services/bookservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_app/models/books.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Kelas BookDetailPage adalah StatefulWidget yang menerima bookId sebagai parameter
class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({
    super.key,
    required this.bookId,
  });

  @override
  BookDetailPageState createState() => BookDetailPageState();
}

class BookDetailPageState extends State<BookDetailPage> {
  late bool isFavorite;
  late Book bookDetail;
  bool isLoading = true;
  bool isWebViewVisible = false; // Untuk mengatur visibilitas WebView
  final BookService bookService = BookService();

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  // Fungsi untuk mengambil detail buku dari layanan buku
  Future<void> fetchBookDetails() async {
    try {
      final book = await bookService.fetchBookDetails(widget.bookId);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final favoritesRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('favorites');
        final favoriteDoc = await favoritesRef.doc(book.id).get();
        final favoriteStatus = favoriteDoc.exists;
        if (!mounted) return;
        setState(() {
          bookDetail = book;
          isFavorite = favoriteStatus;
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          bookDetail = book;
          isFavorite = false;
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Gagal Memuat Detail Buku: $e');
      }
    }
  }

  // Fungsi untuk mengubah status favorit
  void toggleFavoriteStatus() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('favorites');

      if (isFavorite) {
        // Menambahkan buku ke favorit
        favoritesRef.doc(bookDetail.id).set({
          'id': bookDetail.id,
          'title': bookDetail.title,
          'authors': bookDetail.authors,
          'thumbnail': bookDetail.thumbnail,
        });
      } else {
        // Menghapus buku dari favorit
        favoritesRef.doc(bookDetail.id).delete();
      }
    }
  }

  // Fungsi untuk mengubah visibilitas WebView
  void toggleWebView() {
    setState(() {
      isWebViewVisible = !isWebViewVisible;
    });

    if (isWebViewVisible) {
      addToHistory();
    }
  }

  // Fungsi untuk menambahkan buku ke riwayat
  void addToHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final historyRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('history');

      try {
        await historyRef.doc(bookDetail.id).set({
          'id': bookDetail.id,
          'title': bookDetail.title,
          'authors': bookDetail.authors,
          'thumbnail': bookDetail.thumbnail,
          'publishedDate': bookDetail.publishedDate,
          'timestamp':
              FieldValue.serverTimestamp(), // Menyimpan timestamp saat ini
        });
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal Menambahkan Buku di History: $error')),
          );
        }
      }
    }
  }

  // Fungsi untuk mengunduh buku
  void downloadBook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final downloadsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('downloads');

      // Memeriksa apakah buku sudah diunduh
      final existingDownload = await downloadsRef.doc(bookDetail.id).get();
      if (existingDownload.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buku Sudah Tersimpan Di Perpustakaan')),
          );
        }
      } else {
        // Menambahkan buku ke unduhan
        try {
          await downloadsRef.doc(bookDetail.id).set({
            'id': bookDetail.id,
            'title': bookDetail.title,
            'authors': bookDetail.authors,
            'thumbnail': bookDetail.thumbnail,
            'publishedDate': bookDetail.publishedDate,
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Buku Berhasil Didownload')),
            );
          }
        } catch (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal Mendownload buku: $error')),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLoading ? 'Memuat...' : bookDetail.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: Colors.orange.shade400,
        elevation: 3,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        shadowColor: Colors.white,
        actions: <Widget>[
          IconButton(
            onPressed: downloadBook,
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Visibility(
                  visible: !isWebViewVisible,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menampilkan gambar thumbnail buku
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: bookDetail.thumbnail,
                              width: 220,
                              height: 250,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Menampilkan penulis buku
                        Row(
                          children: [
                            const Text(
                              'By: ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                bookDetail.authors.join(', '),
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Menampilkan tanggal publikasi dan jumlah halaman
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Publish Date: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  bookDetail.publishedDate,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10), // Spacer antara kolom
                            Row(
                              children: [
                                const Text(
                                  'Halaman: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${bookDetail.pageCount}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Menampilkan deskripsi buku
                        const Text(
                          'Deskripsi: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          bookDetail.description,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10),
                        // Tombol untuk membaca buku dan menambahkan ke favorit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                              ),
                              onPressed: toggleWebView,
                              child: const Text('Read Book'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: toggleFavoriteStatus,
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  // Warna ketika tombol ditekan
                                  return isFavorite
                                      ? Colors.red.shade700
                                      : Colors.grey.shade400;
                                }
                                // Warna default
                                return isFavorite ? Colors.red : Colors.grey;
                              })),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white, // Warna ikon
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Menampilkan WebView untuk membaca buku
                Visibility(
                  visible: isWebViewVisible,
                  child: WebView(
                    initialUrl: bookDetail.accessInfo.webReaderLink,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              ],
            ),
    );
  }
}
