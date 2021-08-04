import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/services/books.dart';

abstract class SimilarBooksEvent {
  const SimilarBooksEvent();
}

class FetchSimilarBooksEvent extends SimilarBooksEvent {
  final String bookName;
  const FetchSimilarBooksEvent({required this.bookName});
}

abstract class SimilarBooksState {
  const SimilarBooksState();
}

class InitSimilarBooksState extends SimilarBooksState {
  const InitSimilarBooksState();
}

class LoadingSimilarBooksState extends SimilarBooksState {
  final String loadingMessage;
  const LoadingSimilarBooksState({required this.loadingMessage});
}

class LoadedSimilarBooksState extends SimilarBooksState {
  final List<BookModel> similarBooks;
  const LoadedSimilarBooksState({
    required this.similarBooks,
  });
}

class ErrorSimilarBooksState extends SimilarBooksState {
  final String errorMessage;
  const ErrorSimilarBooksState({required this.errorMessage});
}

class SimilarBooksBloc extends Bloc<SimilarBooksEvent, SimilarBooksState> {
  SimilarBooksBloc() : super(InitSimilarBooksState());

  @override
  Stream<SimilarBooksState> mapEventToState(SimilarBooksEvent event) async* {
    if (event is FetchSimilarBooksEvent) {
      yield LoadingSimilarBooksState(
          loadingMessage: 'Fetching similar books...');
      try {
        List<BookModel> _books = await BooksClient().getBooks(
          pattern: event.bookName,
          startIndex: 1,
          maxResults: 9,
        );
        yield LoadedSimilarBooksState(similarBooks: _books);
      } catch (e) {
        yield ErrorSimilarBooksState(errorMessage: e.toString());
      }
    }
  }
}
