import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_app/models/books.dart';
import 'package:final_app/pages/book/detail_book_page.dart';
import 'package:final_app/repository/auth_repository/auth.dart';
import 'package:final_app/services/bookservice.dart';

/// Halaman `HomePage` adalah halaman utama yang menampilkan daftar buku trending
/// dan informasi pengguna yang sedang login.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final AuthController authController = Get.put(AuthController());
  final BookService bookService = BookService();
  final ScrollController _scrollController = ScrollController();
  List<Book> books = [];
  bool isLoading = false;
  bool hasMoreBooks = true;
  int page = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Listener untuk mendeteksi scroll terakhir dan memuat lebih banyak buku jika tersedia.
  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMoreBooks &&
        !isLoading) {
      _loadBooks();
    }
  }

  /// Memuat daftar buku dari `bookService` berdasarkan kata kunci 'Novel'.
  Future<void> _loadBooks() async {
    if (!isLoading && hasMoreBooks) {
      setState(() => isLoading = true);
      try {
        List<Book> newBooks = await bookService.fetchMoreBooks('Novel');
        if (!mounted) return; // Cek apakah widget masih terpasang
        setState(() {
          books.addAll(newBooks);
          page++;
          isLoading = false;
          hasMoreBooks = newBooks.isNotEmpty;
        });
      } catch (e) {
        if (!mounted) return; // Cek apakah widget masih terpasang
        debugPrint('Error fetching books: $e');
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(authController.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data?.data() as Map<String, dynamic>?;
          var username = userData?['username'] ?? 'User';

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, username),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Trending Books',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildBookGrid(),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Membangun bagian header dengan menyertakan salam kepada pengguna.
  Widget _buildHeader(BuildContext context, String username) {
    return Material(
      color: Colors.orange.shade400,
      elevation: 3,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, $username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selamat Membaca',
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('/profil_page');
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun grid untuk menampilkan daftar buku.
  Widget _buildBookGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemCount: books.length + (hasMoreBooks ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < books.length) {
                Book book = books[index];
                return _buildBookItem(context, book);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 20),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  /// Membangun item buku dalam grid dengan gambar buku dari URL dan judul buku.
  Widget _buildBookItem(BuildContext context, Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              try {
                Book bookDetail = await bookService.fetchBookDetails(book.id);
                Get.to(() => BookDetailPage(bookId: bookDetail.id));
              } catch (e) {
                debugPrint('Error fetching book details: $e');
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: book.thumbnail,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 220,
                height: 250,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
