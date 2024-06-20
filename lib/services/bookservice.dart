import 'dart:convert';
import 'package:final_app/models/books.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Layanan untuk mengambil data buku dari Google Books API.
class BookService {
  final String apiKey =
      'AIzaSyD2FtXMQQMxg_CiBMnuMFItXMNVj5byof8'; // Ganti dengan kunci API Google Books Anda
  List<Book> loadedBooks = [];
  int startIndex = 0;
  int maxResultsPerRequest = 20; // Jumlah buku per permintaan
  bool isLoading = false;
  bool reachedEnd = false;

  /// Mengambil informasi detail sebuah buku berdasarkan ID.
  Future<Book> fetchBookDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes/$id?key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Cetak seluruh respons untuk debugging dalam mode debug
      if (kDebugMode) {
        print('200 OK\n${response.body}');
      }
      return Book.fromJson(data); // Konversi respons JSON ke objek Book
    } else {
      if (kDebugMode) {
        print(
            'Gagal memuat detail buku: ${response.statusCode}\n${response.body}');
      }
      throw Exception('Gagal memuat detail buku');
    }
  }

  /// Mengambil daftar buku berdasarkan query pencarian.
  Future<List<Book>> fetchMoreBooks(String query) async {
    if (isLoading || reachedEnd) {
      return []; // Mengembalikan list kosong jika sedang memuat atau sudah mencapai akhir
    }

    isLoading = true; // Mengatur status memuat

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$query&orderBy=newest&key=$apiKey&startIndex=$startIndex&maxResults=$maxResultsPerRequest',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Periksa apakah kunci 'items' ada dan tidak null
        if (data.containsKey('items') && data['items'] != null) {
          final List<dynamic> items = data['items'];

          // Filter buku berdasarkan accessViewStatus
          List<Book> books = items
              .where((json) => (json['accessInfo']['accessViewStatus'] ==
                      'FULL_PUBLIC_DOMAIN' ||
                  json['accessInfo']['accessViewStatus'] == 'SAMPLE'))
              .map((json) => Book.fromJson(json))
              .toList();

          // Perbarui startIndex untuk permintaan berikutnya
          startIndex += maxResultsPerRequest;

          // Periksa apakah masih ada buku yang tersedia untuk diambil
          int totalItems = data['totalItems'] ?? 0;
          if (loadedBooks.length >= totalItems) {
            reachedEnd = true;
          }

          return books;
        } else {
          reachedEnd =
              true; // Mengatur status telah mencapai akhir jika tidak ada item
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Gagal memuat buku: ${response.statusCode}\n${response.body}');
        }
        throw Exception('Gagal memuat buku');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception selama fetchMoreBooks: $e');
      }
      throw Exception('Gagal mengambil buku: $e');
    } finally {
      isLoading = false; // Mengatur ulang status memuat setelah selesai
    }
  }
}
