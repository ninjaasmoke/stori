import 'package:stori/services/books.dart';

class BookRepository {
  static final BookRepository _bookRepository = new BookRepository._();
  static const int _perPage = 10;

  BookRepository._();

  factory BookRepository() {
    return _bookRepository;
  }

  Future<dynamic> getBooks({required String pattern, required int page}) async {
    try {
      return await BooksClient().getBooks(
        pattern: pattern,
        startIndex: page,
        maxResults: _perPage,
      );
    } catch (e) {
      return e.toString();
    }
  }
}
