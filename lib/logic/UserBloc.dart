import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stori/models/UserModel.dart';
import 'package:stori/services/auth.dart';

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

class LoggedInUserState extends UserState {
  final AppUser user;
  const LoggedInUserState({required this.user});
}

class LoggedOutUserState extends UserState {
  const LoggedOutUserState();
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

        bool? isLoggedIn = _prefs.getBool('isLoggedIn');

        if (isLoggedIn == true) {
          User? user = await signInWithGoogle();
          AppUser appUser = new AppUser(
            displayName: user!.displayName,
            uid: user.uid,
            username: user.email,
          );
          yield LoggedInUserState(user: appUser);
        } else {
          yield LoggedOutUserState();
        }
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is LoginUserEvent) {
      yield LoadingUserState(loadingMessage: 'Logging in...');
      try {
        User? user = await signInWithGoogle();
        AppUser appUser = new AppUser(
          displayName: user!.displayName,
          uid: user.uid,
          username: user.email,
        );
        SharedPreferences _prefs = await SharedPreferences.getInstance();

        _prefs.setBool('isLoggedIn', true);

        yield LoggedInUserState(user: appUser);
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    } else if (event is LogoutUserEvent) {
      yield LoadingUserState(loadingMessage: 'Logging out...');
      try {
        await signOutGoogle();
        SharedPreferences _prefs = await SharedPreferences.getInstance();

        _prefs.setBool('isLoggedIn', false);
        yield LoggedOutUserState();
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    }
  }
}
