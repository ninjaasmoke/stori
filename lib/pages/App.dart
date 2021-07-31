import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/components/SnackBarWidget.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/UserBloc.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (c, s) {
        if (s is LoggedInUserState) {
          return Scaffold(
            appBar: _appBar(s.user.photoURL),
            body: _body(c, s),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      listener: (c, s) {
        if (s is LoggedInUserState) {
          ScaffoldMessenger.of(c).showSnackBar(
            customSnackBar(
              text: "Welcome ${s.user.displayName}",
              milli: 2000,
            ),
          );
        }
      },
    );
  }

  AppBar _appBar(String? url) {
    return AppBar(
      backgroundColor: appBarBGColor,
      leadingWidth: 100,
      leading: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        alignment: Alignment.center,
        child: Text(
          'stori',
          style: TextStyle(
            fontFamily: TITLE_FONT,
            fontSize: 28.0,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w900,
            color: accentcolor,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.search,
          ),
        ),
        IconButton(
          iconSize: 16.0,
          icon: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              radius: 18.0,
              backgroundImage: NetworkImage(url!),
            ),
          ),
          onPressed: () {},
        ),
      ],
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
      ],
    );
  }
}
