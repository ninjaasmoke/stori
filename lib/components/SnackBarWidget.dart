import 'package:flutter/material.dart';
import 'package:stori/constants.dart';

SnackBar customSnackBar({required String text, int milli = 300}) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(),
    ),
    duration: Duration(milliseconds: milli),
    backgroundColor: snackBarcolor,
  );
}
