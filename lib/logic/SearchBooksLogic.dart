import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/services/books.dart';

abstract class SearchBooksEvent {
  const SearchBooksEvent();
}

class SearchSearchBooksEvent extends SearchBooksEvent {
  final String pattern;
  const SearchSearchBooksEvent({required this.pattern});
}

abstract class SearchBooksState {
  const SearchBooksState();
}

class InitSearchBooksState extends SearchBooksState {
  const InitSearchBooksState();
}

class LoadingSearchBooksState extends SearchBooksState {
  final String loadingMessage;
  const LoadingSearchBooksState({required this.loadingMessage});
}

class SearchSearchBooksState extends SearchBooksState {
  final List<BookModel> books;
  const SearchSearchBooksState({required this.books});
}

class RecomendedSearchBooksState extends SearchBooksState {
  final List<BookModel> books;
  const RecomendedSearchBooksState({required this.books});
}

class ErrorSearchBooksState extends SearchBooksState {
  final String errorMessage;
  const ErrorSearchBooksState({required this.errorMessage});
}

class SearchBooksBloc extends Bloc<SearchBooksEvent, SearchBooksState> {
  SearchBooksBloc() : super(InitSearchBooksState());

  List<BookModel> searchBooks = [];

  @override
  Stream<SearchBooksState> mapEventToState(SearchBooksEvent event) async* {
    if (event is SearchSearchBooksEvent) {
      yield LoadingSearchBooksState(loadingMessage: 'Searching...');
      try {
        // TODO: pagination
        List<BookModel> books = await BooksClient()
            .getBooks(pattern: event.pattern, maxResults: 39);
        if (books.length != 0) {
          yield SearchSearchBooksState(books: books);
        } else {
          yield ErrorSearchBooksState(errorMessage: 'No books found');
        }
      } catch (e) {
        yield ErrorSearchBooksState(errorMessage: e.toString());
      }
    }
  }
}
