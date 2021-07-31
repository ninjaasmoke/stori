import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/services/books.dart';

abstract class BooksEvent {
  const BooksEvent();
}

class SearchBooksEvent extends BooksEvent {
  final String pattern;
  const SearchBooksEvent({required this.pattern});
}

abstract class BooksState {
  const BooksState();
}

class InitBooksState extends BooksState {
  const InitBooksState();
}

class LoadingBooksState extends BooksState {
  final String loadingMessage;
  const LoadingBooksState({required this.loadingMessage});
}

class SearchBooksState extends BooksState {
  final List<BookModel> books;
  const SearchBooksState({required this.books});
}

class RecomendedBooksState extends BooksState {
  final List<BookModel> books;
  const RecomendedBooksState({required this.books});
}

class ErrorBooksState extends BooksState {
  final String errorMessage;
  const ErrorBooksState({required this.errorMessage});
}

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc() : super(InitBooksState());

  List<BookModel> searchBooks = [];

  @override
  Stream<BooksState> mapEventToState(BooksEvent event) async* {
    if (event is SearchBooksEvent) {
      yield LoadingBooksState(loadingMessage: 'Searching...');
      try {
        // TODO
        List<BookModel> books =
            await BooksClient().getBooks(pattern: event.pattern);
        if (books.length != 0) {
          yield SearchBooksState(books: books);
        } else {
          yield ErrorBooksState(errorMessage: 'No books found');
        }
      } catch (e) {
        yield ErrorBooksState(errorMessage: e.toString());
      }
    }
  }
}
