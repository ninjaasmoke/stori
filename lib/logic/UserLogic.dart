import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/models/UserModel.dart';
import 'package:stori/services/auth.dart';
import 'package:stori/services/books.dart';
import 'package:stori/services/store.dart';

// Events
abstract class UserEvent {
  const UserEvent();
}

class FetchUserEvent extends UserEvent {
  const FetchUserEvent();
}

class LoginUserEvent extends UserEvent {
  const LoginUserEvent();
}

class LogoutUserEvent extends UserEvent {
  const LogoutUserEvent();
}

class UpdateUserEvent extends UserEvent {
  final AppUser appUser;
  const UpdateUserEvent({required this.appUser});
}

class UserAddHasBookEvent extends UserEvent {
  final String bookId;
  const UserAddHasBookEvent({required this.bookId});
}

class UserAddWantBookEvent extends UserEvent {
  final String bookId;
  const UserAddWantBookEvent({required this.bookId});
}

class UserRemoveHasBookEvent extends UserEvent {
  final String bookId;
  const UserRemoveHasBookEvent({required this.bookId});
}

class UserRemoveWantBookEvent extends UserEvent {
  final String bookId;
  const UserRemoveWantBookEvent({required this.bookId});
}

// States
abstract class UserState {
  const UserState();
}

class InitUserState extends UserState {
  const InitUserState();
}

class LoadingUserState extends UserState {
  final String loadingMessage;
  const LoadingUserState({required this.loadingMessage});
}

class LoggingInUserState extends UserState {
  final String loggingInMessage;
  const LoggingInUserState({required this.loggingInMessage});
}

class LoggingOutUserState extends UserState {
  final String loggingOutMessage;
  const LoggingOutUserState({required this.loggingOutMessage});
}

class LoggedInUserState extends UserState {
  final AppUser user;
  final String loggedInMessage;
  final List<BookModel> hasBooks;
  final List<BookModel> wantBooks;
  const LoggedInUserState(
      {required this.user,
      required this.loggedInMessage,
      required this.hasBooks,
      required this.wantBooks});
}

class LoggedOutUserState extends UserState {
  const LoggedOutUserState();
}

class UpdatingUserState extends UserState {
  final String updatingMessage;
  const UpdatingUserState({required this.updatingMessage});
}

class ErrorUserState extends UserState {
  final String errorMessage;
  const ErrorUserState({required this.errorMessage});
}

// Bloc Logic
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(InitUserState());

  UserState get initialState => InitUserState();

  late AppUser currentUser;
  List<BookModel> hasBooks = [];
  List<BookModel> wantBooks = [];
  // RemoteConfig remoteConfig = RemoteConfig.instance;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    // await remoteConfig.setDefaults(<String, dynamic>{
    //   'welcome_message': 'default welcome',
    // });
    // bool updated = await remoteConfig.fetchAndActivate();
    // if (updated) {
    //   // the config has been updated, new parameter values are available.
    //   print(remoteConfig.getString('welcome_message'));
    // } else {
    //   // the config values were previously updated.
    //   print("Old vals");
    //   print(remoteConfig.getString('welcome_message'));
    // }

    if (event is FetchUserEvent) {
      yield LoadingUserState(loadingMessage: 'Fetching user...');
      try {
        SharedPreferences _prefs = await SharedPreferences.getInstance();

        // User? _user = await signInWithGoogle();

        bool? isLoggedIn = _prefs.getBool('isLoggedIn');
        String? uid = _prefs.getString('uid');

        if (isLoggedIn == true && uid != null && uid.isNotEmpty) {
          print("User is logged in");
          FireStoreService _fireStore = FireStoreService();
          AppUser _appUser = await _fireStore.getUser(uid);

          if (_appUser.uid != null && _appUser.uid!.isNotEmpty) {
            currentUser = _appUser;
            for (var hBook in currentUser.hasBooks) {
              BookModel _book = await BooksClient().getBook(pattern: hBook);
              hasBooks.add(_book);
            }
            for (var wBook in currentUser.wantBooks) {
              BookModel _book = await BooksClient().getBook(pattern: wBook);
              wantBooks.add(_book);
            }
            yield LoggedInUserState(
              user: _appUser,
              hasBooks: hasBooks,
              wantBooks: wantBooks,
              loggedInMessage: 'Welcome back, ${currentUser.username}',
            );
          } else {
            yield LoggedOutUserState();
          }
        } else {
          yield LoggedOutUserState();
        }
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is LoginUserEvent) {
      yield LoggingInUserState(loggingInMessage: 'Logging in...');
      try {
        User? user = await signInWithGoogle();
        FireStoreService _fireStore = FireStoreService();
        AppUser _appUser = await _fireStore.getUser(user!.uid);
        if (_appUser.uid == null || _appUser.uid!.isEmpty) {
          AppUser _createUser = new AppUser(
            displayName: user.displayName,
            photoURL: user.photoURL,
            uid: user.uid,
            username: user.displayName,
            hasBooks: [],
            wantBooks: [],
          );
          await _fireStore.addUser(_createUser);
          currentUser = _createUser;
          for (var hBook in currentUser.hasBooks) {
            BookModel _book = await BooksClient().getBook(pattern: hBook);
            hasBooks.add(_book);
          }
          for (var wBook in currentUser.wantBooks) {
            BookModel _book = await BooksClient().getBook(pattern: wBook);
            wantBooks.add(_book);
          }
          yield LoggedInUserState(
            user: _createUser,
            loggedInMessage: 'Welcome ${currentUser.username}',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        } else {
          currentUser = _appUser;
          for (var hBook in currentUser.hasBooks) {
            BookModel _book = await BooksClient().getBook(pattern: hBook);
            hasBooks.add(_book);
          }
          for (var wBook in currentUser.wantBooks) {
            BookModel _book = await BooksClient().getBook(pattern: wBook);
            wantBooks.add(_book);
          }
          yield LoggedInUserState(
            user: _appUser,
            loggedInMessage: 'Welcome back, ${currentUser.username}',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        }
        SharedPreferences _prefs = await SharedPreferences.getInstance();

        _prefs.setBool('isLoggedIn', true);
        _prefs.setString('uid', user.uid);
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is LogoutUserEvent) {
      yield LoggingOutUserState(loggingOutMessage: 'Logging out...');
      try {
        await signOutGoogle();
        SharedPreferences _prefs = await SharedPreferences.getInstance();

        _prefs.setBool('isLoggedIn', false);
        _prefs.setString('uid', "");
        yield LoggedOutUserState();
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is UpdateUserEvent) {
      yield UpdatingUserState(updatingMessage: 'Updating user...');

      try {
        FireStoreService _fireStore = FireStoreService();
        await _fireStore.updateUser(event.appUser);
        currentUser = event.appUser;
        yield LoggedInUserState(
          user: event.appUser,
          loggedInMessage: 'Welcome ${currentUser.username}',
          hasBooks: hasBooks,
          wantBooks: wantBooks,
        );
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is UserAddHasBookEvent) {
      yield UpdatingUserState(updatingMessage: 'Adding book...');
      try {
        if (currentUser.hasBooks.contains(event.bookId)) {
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'You already have this book!  Check "Your Books".',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        } else if (currentUser.wantBooks.contains(event.bookId)) {
          BookModel _book = await BooksClient().getBook(pattern: event.bookId);

          // Remove book from wantBooks List
          FireStoreService _fireStore = FireStoreService();
          await _fireStore.removeBook(
            currentUser.uid ?? '',
            'wantBooks',
            event.bookId,
          );
          wantBooks.removeWhere((element) => element.id == event.bookId);
          currentUser.wantBooks.remove(event.bookId);

          // Add book to hasBooks List
          await _fireStore.addBook(
            currentUser.uid ?? '',
            'hasBooks',
            event.bookId,
          );
          hasBooks.add(_book);
          currentUser.hasBooks.add(event.bookId);
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'Glad you found it!',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        } else {
          FireStoreService _fireStore = FireStoreService();
          await _fireStore.addBook(
            currentUser.uid ?? '',
            'hasBooks',
            event.bookId,
          );
          currentUser.hasBooks.add(event.bookId);
          BookModel _book = await BooksClient().getBook(pattern: event.bookId);
          hasBooks.add(_book);
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'Soo cool!!! Added book to your list.',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
          if (currentUser.hasBooks.length == 1) {
            yield LoggedInUserState(
              user: currentUser,
              loggedInMessage: 'It will be in "Your Books" section.',
              hasBooks: hasBooks,
              wantBooks: wantBooks,
            );
          }
        }
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is UserAddWantBookEvent) {
      yield UpdatingUserState(updatingMessage: 'Adding book...');
      try {
        FireStoreService _fireStore = FireStoreService();
        if (currentUser.wantBooks.contains(event.bookId)) {
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'Book already in wanted books list!',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        } else if (currentUser.hasBooks.contains(event.bookId)) {
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'You already have this book!',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        } else {
          await _fireStore.addBook(
            currentUser.uid ?? '',
            'wantBooks',
            event.bookId,
          );
          BookModel _book = await BooksClient().getBook(pattern: event.bookId);
          wantBooks.add(_book);
          currentUser.wantBooks.add(event.bookId);
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'Added book to wanted books!',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
          if (currentUser.wantBooks.length == 1) {
            yield LoggedInUserState(
              user: currentUser,
              loggedInMessage: 'It will be in "Your Books" section.',
              hasBooks: hasBooks,
              wantBooks: wantBooks,
            );
          }
        }
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is UserRemoveHasBookEvent) {
      yield UpdatingUserState(updatingMessage: 'Removing book...');
      try {
        if (currentUser.hasBooks.contains(event.bookId)) {
          FireStoreService _fireStore = FireStoreService();
          await _fireStore.removeBook(
            currentUser.uid ?? '',
            'hasBooks',
            event.bookId,
          );
          hasBooks.removeWhere((element) => element.id == event.bookId);
          currentUser.hasBooks.remove(event.bookId);
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'Removed book from your list.',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        }
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is UserRemoveWantBookEvent) {
      yield UpdatingUserState(updatingMessage: 'Removing book...');
      try {
        if (currentUser.wantBooks.contains(event.bookId)) {
          FireStoreService _fireStore = FireStoreService();
          await _fireStore.removeBook(
            currentUser.uid ?? '',
            'wantBooks',
            event.bookId,
          );
          wantBooks.removeWhere((element) => element.id == event.bookId);
          currentUser.wantBooks.remove(event.bookId);
          yield LoggedInUserState(
            user: currentUser,
            loggedInMessage: 'Removed book from your list.',
            hasBooks: hasBooks,
            wantBooks: wantBooks,
          );
        }
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    }
  }
}
