import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/models/UserModel.dart';

// Events
abstract class UserEvent {
  const UserEvent();
}

class FetchUserEvent extends UserEvent {
  const FetchUserEvent();
}

class LoginUserEvent extends UserEvent {
  final User user;
  const LoginUserEvent({required this.user});
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
  final User user;
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
        User _user = new User(displayName: '', uid: '', username: '');
        yield LoggedInUserState(user: _user);
      } catch (e) {
        yield ErrorUserState(errorMessage: e.toString());
      }
    }
  }
}
