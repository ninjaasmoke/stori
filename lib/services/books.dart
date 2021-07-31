import 'dart:convert';

import 'package:stori/constants.dart';
import 'package:stori/models/BookModel.dart';
import 'package:http/http.dart' as http;

class BooksClient {
  Future<List<BookModel>> getBooks({
    required String pattern,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    var url = Uri.parse(
      '$BOOKS_GOOGLE_URI_V1?q=$pattern&startIndex=$startIndex&maxResults=$maxResults',
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
    }

    return _books;
  }
}
