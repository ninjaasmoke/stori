import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stori/models/UserModel.dart';
import 'package:stori/services/auth.dart';
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
  const LoggedInUserState({required this.user});
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

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
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
          AppUser appUser = await _fireStore.getUser(uid);

          yield LoggedInUserState(user: appUser);
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
          );
          await _fireStore.addUser(_createUser);

          AppUser _user = new AppUser(
            displayName: user.displayName,
            photoURL: user.photoURL,
            uid: user.uid,
            username: user.displayName,
          );
          yield LoggedInUserState(user: _user);
        } else {
          yield LoggedInUserState(user: _appUser);
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
        // TODO
        FireStoreService _fireStore = FireStoreService();
        await _fireStore.updateUser(event.appUser);
        yield LoggedInUserState(user: event.appUser);
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    }
  }
}
