import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/components/SnackBarWidget.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/UserBloc.dart';
import 'package:stori/pages/Profile.dart';
import 'package:stori/pages/Search.dart';

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
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        'stori',
        style: TextStyle(
          fontFamily: TITLE_FONT,
          fontSize: 28.0,
          letterSpacing: 2.0,
          fontWeight: FontWeight.w900,
          color: accentcolor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          },
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
              backgroundColor: Colors.transparent,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _body(BuildContext c, LoggedInUserState s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
  }
}
