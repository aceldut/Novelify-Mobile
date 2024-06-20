import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_app/models/books.dart';
import 'package:final_app/pages/book/detail_book_page.dart';
import 'package:final_app/services/bookservice.dart';
import 'package:final_app/pages/category_books_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textController;
  final BookService bookService = BookService();
  List<Book> searchResults = [];
  bool isSearching = false;

  final List<Map<String, String>> categories = [
    {
      'name': 'Romantis',
      'imagePath': 'assets/1.png',
    },
    {
      'name': 'Thriller',
      'imagePath': 'assets/2.png',
    },
    {
      'name': 'Horor',
      'imagePath': 'assets/3.png',
    },
    {
      'name': 'Komedi',
      'imagePath': 'assets/4.png',
    },
    {
      'name': 'Misteri',
      'imagePath': 'assets/5.png',
    },
    {
      'name': 'Petualangan',
      'imagePath': 'assets/6.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onSearchTextChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    // Menjalankan pencarian buku berdasarkan query menggunakan BookService
    BookService().fetchMoreBooks(query).then((books) {
      setState(() {
        searchResults = books;
      });
    }).catchError((error) {
      // Handle error jika terjadi kesalahan dalam fetchMoreBooks
      setState(() {
        searchResults.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        shadowColor: Colors.white,
        surfaceTintColor: Colors.orange,
        toolbarHeight: 108,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pencarian',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoSearchTextField(
              controller: textController,
              placeholder: 'Cari',
              backgroundColor: Colors.white,
              onChanged: onSearchTextChanged,
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade400,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isSearching ? _buildSearchResults() : _buildKategoriList(),
    );
  }

  // Widget untuk menampilkan daftar kategori buku
  Widget _buildKategoriList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            // ListView untuk menampilkan daftar kategori buku
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    // Menavigasi ke halaman CategoryBooksPage dengan kategori yang dipilih
                    Get.to(() =>
                        CategoryBooksPage(categoryName: category['name']!));
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        category['imagePath']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan hasil pencarian buku
  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            try {
              // Memuat detail buku menggunakan BookService
              Book bookDetail =
                  await bookService.fetchBookDetails(searchResults[index].id);
              // Menavigasi ke halaman BookDetailPage dengan id buku yang dipilih
              Get.to(() => BookDetailPage(bookId: bookDetail.id));
            } catch (e) {
              debugPrint('Error fetching book details: $e');
            }
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
                      searchResults[index].thumbnail,
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
                          searchResults[index].title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(searchResults[index].authors.join(", ")),
                        const SizedBox(height: 5),
                        Text(
                            "Published Date: ${searchResults[index].publishedDate}"),
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
}
