import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/services/books.dart';
import 'package:stori/services/store.dart';

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
  final List<List<BookModel>> booksList;
  final List<String> topics;
  final BookModel bookOfDay;
  const LoadedRecBooksState({
    required this.booksList,
    required this.topics,
    required this.bookOfDay,
  });
}

class ErrorRecBooksState extends RecBooksState {
  final String errorMessage;
  const ErrorRecBooksState({required this.errorMessage});
}

class RecBooksBloc extends Bloc<RecBooksEvent, RecBooksState> {
  RecBooksBloc() : super(InitRecBooksState());

  List<List<BookModel>> booksTopics = [];

  @override
  Stream<RecBooksState> mapEventToState(RecBooksEvent event) async* {
    if (event is FetchRecBooksEvent) {
      yield LoadingRecBooksState(loadingMessage: 'Fetching books...');
      try {
        BooksClient booksClient = new BooksClient();
        FireStoreService fireStoreService = FireStoreService();
        List<String> topics = await (fireStoreService.getTopics());
        int max = 3;
        int randomNumber = Random().nextInt(max) + 1;
        String titleBookOfDay = await (fireStoreService.getBookOfDay());
        BookModel bookOfDay =
            await booksClient.getBook(pattern: titleBookOfDay);
        yield LoadedRecBooksState(
          topics: topics,
          bookOfDay: bookOfDay,
          booksList: booksTopics,
        );
        for (var topic in topics) {
          booksTopics.add(
            await booksClient.getBooks(
              pattern: topic,
              startIndex: randomNumber,
            ),
          );
          yield LoadedRecBooksState(
            topics: topics,
            bookOfDay: bookOfDay,
            booksList: booksTopics,
          );
        }
      } catch (e) {
        yield ErrorRecBooksState(errorMessage: e.toString());
      }
    }
  }
}
