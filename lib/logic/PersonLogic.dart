import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/services/books.dart';

abstract class PersonEvent {
  const PersonEvent();
}

class FetchPersonBooks extends PersonEvent {
  final List<String> hasBooks, wantsBooks;
  FetchPersonBooks({required this.hasBooks, required this.wantsBooks});
}

abstract class PersonState {
  const PersonState();
}

class InitPersonState extends PersonState {
  const InitPersonState();
}

class FetchedPersonBooksState extends PersonState {
  final List<BookModel> hasBooks, wantBooks;
  const FetchedPersonBooksState(
      {required this.hasBooks, required this.wantBooks});
}

class LoadingPersonBooksState extends PersonState {
  final String loadingMessage;
  const LoadingPersonBooksState({required this.loadingMessage});
}

class ErrorPersonBooksState extends PersonState {
  final String errorMessage;
  const ErrorPersonBooksState({required this.errorMessage});
}

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(InitPersonState());

  List<BookModel> hasBooks = [];
  List<BookModel> wantBooks = [];

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async* {
    if (event is FetchPersonBooks) {
      yield LoadingPersonBooksState(loadingMessage: 'Fetching user data...');
      try {
        hasBooks = [];
        wantBooks = [];
        for (var hBook in event.hasBooks) {
          BookModel _book = await BooksClient().getBook(pattern: hBook);
          hasBooks.add(_book);
          yield FetchedPersonBooksState(
              hasBooks: hasBooks, wantBooks: wantBooks);
        }
        for (var wBook in event.wantsBooks) {
          BookModel _book = await BooksClient().getBook(pattern: wBook);
          wantBooks.add(_book);
          yield FetchedPersonBooksState(
              hasBooks: hasBooks, wantBooks: wantBooks);
        }
        yield FetchedPersonBooksState(hasBooks: hasBooks, wantBooks: wantBooks);
      } catch (e) {
        yield ErrorPersonBooksState(errorMessage: e.toString());
      }
    }
  }
}
