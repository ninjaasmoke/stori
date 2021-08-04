import 'dart:convert';

import 'package:stori/constants.dart';
import 'package:stori/models/BookModel.dart';
import 'package:http/http.dart' as http;

class BooksClient {
  Future<List<BookModel>> getBooks({
    required String pattern,
    int startIndex = 0,
    int maxResults = 40,
  }) async {
    var url = Uri.parse(
      '$BOOKS_GOOGLE_URI_V1?q=$pattern&startIndex=$startIndex&maxResults=$maxResults',
      // '$BOOKS_GOOGLE_URI_V1?q=$pattern',
    );

    List<BookModel> _books = [];

    try {
      var response = await http.get(url);
      if (response is http.Response) {
        if (response.statusCode == 200) {
          String body = response.body;
          for (var item in jsonDecode(body)["items"]) {
            _books.add(BookModel.fromJson(item));
          }
        }
      }
    } catch (e) {
      print(e);
      throw Error();
    }

    return _books;
  }

  Future<BookModel> getBook({
    required String pattern,
  }) async {
    var url = Uri.parse(
      '$BOOKS_GOOGLE_URI_V1?q=$pattern&startIndex=0&maxResults=1',
    );

    BookModel _book = BookModel(
      id: '',
      title: '',
      subTitle: '',
      authors: [],
      categories: [],
      publisher: '',
      publishedDate: '',
      description: '',
      pageCount: 0,
      imageUrl: '',
      thumbnailUrl: '',
      snippet: '',
    );

    try {
      var response = await http.get(url);
      if (response is http.Response) {
        if (response.statusCode == 200) {
          String body = response.body;
          for (var item in jsonDecode(body)["items"]) {
            _book = (BookModel.fromJson(item));
          }
        }
      }
    } catch (e) {
      print(e);
      throw Error();
    }

    return _book;
  }
}
