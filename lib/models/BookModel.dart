import 'dart:convert';

class BookModel {
  final String id;
  final String title;
  final String subTitle;
  final List<dynamic> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final int pageCount;
  final String imageUrl;
  final String thumbnailUrl;
  final String snippet;

  BookModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.snippet,
  });

  static BookModel fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json["id"],
      title: json["volumeInfo"]["title"] ?? "",
      subTitle: json["volumeInfo"]["subtitle"] ?? "",
      authors:
          json["volumeInfo"] != null ? json["volumeInfo"]["authors"] ?? [] : [],
      publisher: json["volumeInfo"]["publisher"] ?? "",
      publishedDate: json["volumeInfo"]["publishedDate"] ?? "",
      description: json["volumeInfo"]["description"] ?? "",
      pageCount: json["volumeInfo"]["pageCount"] ?? 0,
      imageUrl: json["volumeInfo"]["imageLinks"] != null
          ? json["volumeInfo"]["imageLinks"]["thumbnail"] ?? ""
          : "",
      thumbnailUrl: json["volumeInfo"]["imageLinks"] != null
          ? json["volumeInfo"]["imageLinks"]["smallThumbnail"] ?? ""
          : "",
      snippet: json["searchInfo"] != null
          ? json["searchInfo"]["textSnippet"] ?? ""
          : "",
    );
  }
}

class Books {
  final List<BookModel> books;

  Books({
    required this.books,
  });

  static Books fromJson(Map<String, dynamic> json) {
    print(jsonDecode(json["items"]));

    List<BookModel> _books = [];

    return new Books(
      books: _books,
    );
  }
}
