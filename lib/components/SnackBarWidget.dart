import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/constants.dart';

SnackBar customSnackBar({required String text, int milli = 1000}) {
  return SnackBar(
    content: Text(
      text,
      style: GoogleFonts.nunitoSans(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    duration: Duration(milliseconds: milli),
    backgroundColor: snackBarcolor,
  );
}
