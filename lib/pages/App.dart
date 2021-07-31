import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/UserBloc.dart';
import 'package:stori/services/store.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        builder: (c, s) {
          if (s is LoggedInUserState) {
            print(s.user.displayName);
            return _body(c, s);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        listener: (c, s) {},
      ),
    );
  }

  Widget _body(BuildContext c, LoggedInUserState s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Hello ${s.user.displayName}\n${s.user.username}",
            style: TextStyle(
              color: accentcolor,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          onPressed: () {
            c.read<UserBloc>().add(LogoutUserEvent());
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: Text(
            "Fetch",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          onPressed: () {
            FireStoreService service = new FireStoreService();
            service.getUser(s.user.uid);
          },
        ),
      ],
    );
  }
}
