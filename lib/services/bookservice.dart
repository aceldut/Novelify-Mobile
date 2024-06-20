import 'dart:convert';
import 'package:final_app/models/books.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookService {
  final String apiKey = 'AIzaSyD2FtXMQQMxg_CiBMnuMFItXMNVj5byof8';
  List<Book> loadedBooks = [];
  int startIndex = 0;
  int maxResultsPerRequest = 20; // Misalnya, 20 item per request
  bool isLoading = false;
  bool reachedEnd = false;

  Future<List<Book>> fetchBooks(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$query&orderBy=newest&key=$apiKey&maxResults=$maxResultsPerRequest'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      // Print entire response body for debugging
      if (kDebugMode) {
        print('200 OK\n${response.body}');
      }
      return items.map((json) => Book.fromJson(json)).toList();
    } else {
      if (kDebugMode) {
        print('Failed to load books: ${response.statusCode}\n${response.body}');
      }
      throw Exception('Failed to load books');
    }
  }

  Future<Book> fetchBookDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes/$id?key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Print entire response body for debugging
      if (kDebugMode) {
        print('200 OK\n${response.body}');
      }
      return Book.fromJson(data);
    } else {
      if (kDebugMode) {
        print(
            'Failed to load book details: ${response.statusCode}\n${response.body}');
      }
      throw Exception('Failed to load book details');
    }
  }

  Future<List<Book>> fetchMoreBooks(String query) async {
  if (isLoading || reachedEnd) {
    return []; // Mengembalikan list kosong jika sedang memuat atau sudah mencapai akhir
  }

  isLoading = true;

  try {
    final response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&orderBy=newest&key=$apiKey&startIndex=$startIndex&maxResults=$maxResultsPerRequest',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Check if 'items' key exists and is not null
      if (data.containsKey('items') && data['items'] != null) {
        final List<dynamic> items = data['items'];

        // Filter books by accessViewStatus
        List<Book> books = items
            .where((json) =>
                (json['accessInfo']['accessViewStatus'] == 'FULL_PUBLIC_DOMAIN' ||
                    json['accessInfo']['accessViewStatus'] == 'SAMPLE'))
            .map((json) => Book.fromJson(json))
            .toList();

        // Update startIndex for the next request
        startIndex += maxResultsPerRequest;

        // Check if there are more books to fetch
        int totalItems = data['totalItems'] ?? 0;
        if (loadedBooks.length >= totalItems) {
          reachedEnd = true;
        }

        return books;
      } else {
        reachedEnd = true;
        return [];
      }
    } else {
      if (kDebugMode) {
        print(
            'Failed to load books: ${response.statusCode}\n${response.body}');
      }
      throw Exception('Failed to load books');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Exception during fetchMoreBooks: $e');
    }
    throw Exception('Failed to fetch books: $e');
  } finally {
    isLoading = false;
  }
}

}
