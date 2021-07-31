import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/constants.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Stori',
          style: TextStyle(
            fontFamily: TITLE_FONT,
            letterSpacing: 4.0,
            fontSize: 40.0,
            fontWeight: FontWeight.w900,
            color: accentcolor,
          ),
        ),
      ),
    );
  }
}
