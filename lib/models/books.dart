import 'package:html/parser.dart' as html_parser;

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
  final SaleInfo saleInfo;
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
    required this.saleInfo,
    required this.accessInfo,
    this.isFavorite = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var volumeInfo = json['volumeInfo'];
    var saleInfo = json['saleInfo'];
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
      saleInfo: SaleInfo.fromJson(saleInfo),
      accessInfo: AccessInfo.fromJson(accessInfo),
    );
  }
}

class IndustryIdentifier {
  final String type;
  final String identifier;

  IndustryIdentifier({
    required this.type,
    required this.identifier,
  });

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifier(
      type: json['type'],
      identifier: json['identifier'],
    );
  }
}

class SaleInfo {
  final String country;
  final String saleability;
  final bool isEbook;
  final ListPrice? listPrice;
  final ListPrice? retailPrice;
  final String buyLink;

  SaleInfo({
    required this.country,
    required this.saleability,
    required this.isEbook,
    this.listPrice,
    this.retailPrice,
    required this.buyLink,
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(
      country: json['country'],
      saleability: json['saleability'],
      isEbook: json['isEbook'] ?? false,
      listPrice: json['listPrice'] != null
          ? ListPrice.fromJson(json['listPrice'])
          : null,
      retailPrice: json['retailPrice'] != null
          ? ListPrice.fromJson(json['retailPrice'])
          : null,
      buyLink: json['buyLink'] ?? '',
    );
  }
}

class ListPrice {
  final double amount;
  final String currencyCode;

  ListPrice({
    required this.amount,
    required this.currencyCode,
  });

  factory ListPrice.fromJson(Map<String, dynamic> json) {
    return ListPrice(
      amount: json['amount']?.toDouble() ?? 0.0,
      currencyCode: json['currencyCode'] ?? 'Unknown',
    );
  }
}

class AccessInfo {
  final String country;
  final String viewability;
  final bool embeddable;
  final bool publicDomain;
  final String textToSpeechPermission;
  final Epub epub;
  final Pdf pdf;
  final String accessViewStatus;
  final String? webReaderLink;

  AccessInfo({
    required this.country,
    required this.viewability,
    required this.embeddable,
    required this.publicDomain,
    required this.textToSpeechPermission,
    required this.epub,
    required this.pdf,
    required this.accessViewStatus,
    required this.webReaderLink,
  });

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(
        country: json['country'],
        viewability: json['viewability'],
        embeddable: json['embeddable'] ?? false,
        publicDomain: json['publicDomain'] ?? false,
        textToSpeechPermission: json['textToSpeechPermission'],
        epub: Epub.fromJson(json['epub']),
        pdf: Pdf.fromJson(json['pdf']),
        accessViewStatus: json['accessViewStatus'],
        webReaderLink: json['webReaderLink']);
  }
}

class Epub {
  final bool isAvailable;
  final String acsTokenLink;

  Epub({
    required this.isAvailable,
    required this.acsTokenLink,
  });

  factory Epub.fromJson(Map<String, dynamic> json) {
    return Epub(
      isAvailable: json['isAvailable'] ?? false,
      acsTokenLink: json['acsTokenLink'] ?? '',
    );
  }
}

class Pdf {
  final bool isAvailable;

  Pdf({
    required this.isAvailable,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      isAvailable: json['isAvailable'] ?? false,
    );
  }
}

String parseHtmlString(String htmlString) {
  final document = html_parser.parse(htmlString);
  final String parsedString =
      html_parser.parse(document.body?.text ?? '').documentElement?.text ?? '';
  return parsedString;
}
