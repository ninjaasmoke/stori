import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/services/books.dart';

abstract class RecBooksEvent {
  const RecBooksEvent();
}

class FetchRecBooksEvent extends RecBooksEvent {
  const FetchRecBooksEvent();
}

abstract class RecBooksState {
  const RecBooksState();
}

class InitRecBooksState extends RecBooksState {
  const InitRecBooksState();
}

class LoadingRecBooksState extends RecBooksState {
  final String loadingMessage;
  const LoadingRecBooksState({required this.loadingMessage});
}

class LoadedRecBooksState extends RecBooksState {
  final List<BookModel> fiction,
      scientific,
      culture,
      indian,
      children,
      life,
      adventure;
  const LoadedRecBooksState({
    required this.scientific,
    required this.fiction,
    required this.children,
    required this.culture,
    required this.indian,
    required this.life,
    required this.adventure,
  });
}

class ErrorRecBooksState extends RecBooksState {
  final String errorMessage;
  const ErrorRecBooksState({required this.errorMessage});
}

class RecBooksBloc extends Bloc<RecBooksEvent, RecBooksState> {
  RecBooksBloc() : super(InitRecBooksState());

  List<BookModel> fiction = [],
      scientific = [],
      culture = [],
      indian = [],
      children = [],
      life = [],
      adventure = [];

  @override
  Stream<RecBooksState> mapEventToState(RecBooksEvent event) async* {
    if (event is FetchRecBooksEvent) {
      yield LoadingRecBooksState(loadingMessage: 'Fetching books...');
      try {
        BooksClient booksClient = new BooksClient();
        fiction =
            await booksClient.getBooks(pattern: 'fiction', maxResults: 15);
        scientific =
            await booksClient.getBooks(pattern: 'scientific', maxResults: 15);
        culture =
            await booksClient.getBooks(pattern: 'culture', maxResults: 15);
        indian = await booksClient.getBooks(pattern: 'indian', maxResults: 15);
        children =
            await booksClient.getBooks(pattern: 'children', maxResults: 15);
        life = await booksClient.getBooks(pattern: 'life', maxResults: 15);
        adventure =
            await booksClient.getBooks(pattern: 'adventure', maxResults: 15);
        yield LoadedRecBooksState(
          scientific: scientific,
          fiction: fiction,
          children: children,
          culture: culture,
          indian: indian,
          life: life,
          adventure: adventure,
        );
      } catch (e) {
        yield ErrorRecBooksState(errorMessage: e.toString());
      }
    }
  }
}
