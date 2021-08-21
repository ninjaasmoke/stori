import 'dart:convert';

class BookModel {
  final String id;
  final String title;
  final String subTitle;
  final List<dynamic> authors;
  final List<dynamic> categories;
  final String publisher;
  final String publishedDate;
  final String description;
  final int pageCount;
  final String imageUrl;
  final String thumbnailUrl;
  final String snippet;
  final List<String> similarBooks;

  BookModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.authors,
    required this.categories,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.snippet,
    required this.similarBooks,
  });

  static BookModel fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json["id"],
      title: json["volumeInfo"]["title"] ?? "",
      subTitle: json["volumeInfo"]["subtitle"] ?? "",
      authors:
          json["volumeInfo"] != null ? json["volumeInfo"]["authors"] ?? [] : [],
      categories: json["volumeInfo"] != null
          ? json["volumeInfo"]["categories"] ?? []
          : [],
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
      similarBooks: [],
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
