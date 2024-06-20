import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/models/books.dart';
import 'package:final_app/pages/book/detail_book_page.dart';
import 'package:final_app/services/bookservice.dart';

class CategoryBooksPage extends StatefulWidget {
  final String categoryName;

  const CategoryBooksPage({super.key, required this.categoryName});

  @override
  State<CategoryBooksPage> createState() => _CategoryBooksPageState();
}

class _CategoryBooksPageState extends State<CategoryBooksPage>
    with AutomaticKeepAliveClientMixin {
  final BookService bookService = BookService();
  final ScrollController _scrollController = ScrollController();
  List<Book> books = [];
  bool isLoading = false;
  bool hasMoreBooks = true;
  int startIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchBooksByCategory();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Memeriksa jika user telah mencapai akhir daftar dan memuat lebih banyak buku jika masih ada
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMoreBooks &&
        !isLoading) {
      fetchBooksByCategory();
    }
  }

  // Mengambil buku berdasarkan kategori dan menambahkan hasil ke daftar buku
  Future<void> fetchBooksByCategory() async {
    if (!isLoading && hasMoreBooks) {
      setState(() => isLoading = true);
      try {
        List<Book> fetchedBooks =
            await bookService.fetchMoreBooks(widget.categoryName);
        if (!mounted) return; // Memeriksa apakah widget masih terpasang
        setState(() {
          books.addAll(fetchedBooks);
          startIndex += bookService.maxResultsPerRequest;
          isLoading = false;
          hasMoreBooks =
              fetchedBooks.length == bookService.maxResultsPerRequest;
        });
      } catch (e) {
        if (!mounted) return; // Memeriksa apakah widget masih terpasang
        debugPrint('Error fetching books by category: $e');
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade400,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isLoading && books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Memuat lebih banyak buku ketika user mencapai akhir daftar
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !isLoading) {
                  fetchBooksByCategory();
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: books.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == books.length) {
                    // Menampilkan indikator loading jika sedang memuat lebih banyak buku
                    return const Center(child: CircularProgressIndicator());
                  }
                  final book = books[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman detail buku saat item di tap
                      Get.to(() => BookDetailPage(bookId: book.id));
                    },
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                book.thumbnail,
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(book.authors.join(", ")),
                                  const SizedBox(height: 5),
                                  Text("Published Date: ${book.publishedDate}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
