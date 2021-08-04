import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/UserLogic.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (c, s) {
        return Scaffold(
          body: _body(c, s),
        );
      },
      listener: (c, s) {},
    );
  }

  Widget _body(BuildContext context, UserState state) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg/bg.jpg'),
          // fit:
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff000000),
            Color(0xbb000000),
            Color(0xbb000000),
            Color(0xcc000000),
            Color(0xdd000000),
            Colors.black,
            Colors.black,
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _banner(),
            _loginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _banner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'stori',
          style: TextStyle(
            fontFamily: TITLE_FONT,
            fontSize: 40.0,
            fontWeight: FontWeight.w900,
            color: accentcolor,
          ),
        ),
        _appIntro(),
      ],
    );
  }

  Widget _appIntro() {
    return Text(
      "Something about the app . . .",
      style: TextStyle(
        color: primaryTextColor,
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('assets/gIcon.png'),
            ),
            SizedBox(
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Center(
                child: Text(
                  "Continue with Google",
                  style: GoogleFonts.kumbhSans(
                    color: darkTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 14,
            ),
          ],
        ),
        onPressed: () {
          context.read<UserBloc>().add(LoginUserEvent());
        },
      ),
    );
  }
}
