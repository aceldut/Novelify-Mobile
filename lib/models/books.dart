import 'package:html/parser.dart' as html_parser;

// Kelas utama untuk mendefinisikan data buku
class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final List<IndustryIdentifier> industryIdentifiers;
  final int pageCount;
  final String printType;
  final List<String> categories;
  final double averageRating;
  final int ratingsCount;
  final String language;
  final String thumbnail;
  final String infoLink;
  final AccessInfo accessInfo;
  bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.industryIdentifiers,
    required this.pageCount,
    required this.printType,
    required this.categories,
    required this.averageRating,
    required this.ratingsCount,
    required this.language,
    required this.thumbnail,
    required this.infoLink,
    required this.accessInfo,
    this.isFavorite = false,
  });

  // Factory method untuk membuat objek Book dari JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    var volumeInfo = json['volumeInfo'];
    var accessInfo = json['accessInfo'];

    return Book(
      id: json['id'],
      title: volumeInfo['title'] ?? 'No Title',
      authors: volumeInfo['authors'] != null
          ? List<String>.from(volumeInfo['authors'])
          : [],
      publisher: volumeInfo['publisher'] ?? 'Unknown',
      publishedDate: volumeInfo['publishedDate'] ?? 'Unknown',
      description: volumeInfo['description'] != null
          ? parseHtmlString(volumeInfo['description'])
          : 'No description available',
      industryIdentifiers: volumeInfo['industryIdentifiers'] != null
          ? List<IndustryIdentifier>.from(volumeInfo['industryIdentifiers']
              .map((item) => IndustryIdentifier.fromJson(item)))
          : [],
      pageCount: volumeInfo['pageCount'] ?? 0,
      printType: volumeInfo['printType'] ?? 'Unknown',
      categories: volumeInfo['categories'] != null
          ? List<String>.from(volumeInfo['categories'])
          : [],
      averageRating: volumeInfo['averageRating']?.toDouble() ?? 0.0,
      ratingsCount: volumeInfo['ratingsCount'] ?? 0,
      language: volumeInfo['language'] ?? 'Unknown',
      thumbnail: volumeInfo['imageLinks'] != null
          ? volumeInfo['imageLinks']['thumbnail']
          : '',
      infoLink: volumeInfo['infoLink'] ?? '',
      accessInfo: AccessInfo.fromJson(accessInfo),
    );
  }
}

// Kelas untuk identifikasi industri buku
class IndustryIdentifier {
  final String type;
  final String identifier;

  IndustryIdentifier({
    required this.type,
    required this.identifier,
  });

  // Factory method untuk membuat objek IndustryIdentifier dari JSON
  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifier(
      type: json['type'],
      identifier: json['identifier'],
    );
  }
}

// Kelas untuk informasi akses buku
class AccessInfo {
  final String country;
  final String viewability;
  final bool embeddable;
  final bool publicDomain;
  final String textToSpeechPermission;
  final String accessViewStatus;
  final String? webReaderLink;

  AccessInfo({
    required this.country,
    required this.viewability,
    required this.embeddable,
    required this.publicDomain,
    required this.textToSpeechPermission,
    required this.accessViewStatus,
    required this.webReaderLink,
  });

  // Factory method untuk membuat objek AccessInfo dari JSON
  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(
      country: json['country'],
      viewability: json['viewability'],
      embeddable: json['embeddable'] ?? false,
      publicDomain: json['publicDomain'] ?? false,
      textToSpeechPermission: json['textToSpeechPermission'],
      accessViewStatus: json['accessViewStatus'],
      webReaderLink: json['webReaderLink'],
    );
  }
}

// Fungsi untuk menghapus tag HTML dari string deskripsi
String parseHtmlString(String htmlString) {
  final document = html_parser.parse(htmlString);
  final String parsedString =
      html_parser.parse(document.body?.text ?? '').documentElement?.text ?? '';
  return parsedString;
}
