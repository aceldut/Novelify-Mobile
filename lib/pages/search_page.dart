import 'package:final_app/models/books.dart';
import 'package:final_app/pages/book/detail_book_page.dart';
import 'package:final_app/services/bookservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    BookService().fetchMoreBooks(query).then((books) {
      setState(() {
        searchResults = books;
      });
    }).catchError((error) {
      //handle error
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
      body: isSearching ? _buildSearchResults() : _buildKategoriGrid(),
    );
  }

  Widget _buildKategoriGrid() {
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
              height: 20,
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    width: 200,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Kategori'), Text('Gambar')],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            try {
              Book bookDetail =
                  await bookService.fetchBookDetails(searchResults[index].id);
              Get.to(() => BookDetailPage(bookId: bookDetail.id));
            } catch (e) {
              debugPrint('Error fetching book details: $e');
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60, // sesuaikan lebar sesuai kebutuhan Anda
                    height: 80, // sesuaikan tinggi sesuai kebutuhan Anda
                    child: Image.network(
                      searchResults[index].thumbnail,
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
