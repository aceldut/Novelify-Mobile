import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_app/services/bookservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_app/models/books.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  bool isWebViewVisible = false; // To toggle WebView visibility
  final BookService bookService = BookService();

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    try {
      final book = await bookService.fetchBookDetails(widget.bookId);
      final prefs = await SharedPreferences.getInstance();
      final favoriteStatus = prefs.getBool(book.id) ?? false;
      setState(() {
        bookDetail = book;
        isFavorite = favoriteStatus;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load book details: $e');
      }
    }
  }

  void toggleFavoriteStatus() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(bookDetail.id, isFavorite);
  }

  void toggleWebView() {
    setState(() {
      isWebViewVisible = !isWebViewVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            isLoading ? 'Loading...' : bookDetail.title,
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.download))
          ]),
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
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: bookDetail.thumbnail,
                              width: 220,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                  WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
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
