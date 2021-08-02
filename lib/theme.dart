import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: scaffoldBGColor,
  accentColor: Colors.grey.shade800,
  primaryColor: accentcolor,
  primarySwatch: MaterialColor(0xFFE20A16, {
    50: Color.fromRGBO(226, 10, 22, 0.1),
    100: Color.fromRGBO(226, 10, 22, 0.2),
    200: Color.fromRGBO(226, 10, 22, 0.3),
    300: Color.fromRGBO(226, 10, 22, 0.4),
    400: Color.fromRGBO(226, 10, 22, 0.5),
    500: Color.fromRGBO(226, 10, 22, 0.6),
    600: Color.fromRGBO(226, 10, 22, 0.7),
    700: Color.fromRGBO(226, 10, 22, 0.8),
    800: Color.fromRGBO(226, 10, 22, 0.9),
    900: Color.fromRGBO(226, 10, 22, 1.0),
  }),
  hoverColor: accentcolor,
  splashColor: accentcolor,
  fontFamily: GoogleFonts.poppins().fontFamily,
);
