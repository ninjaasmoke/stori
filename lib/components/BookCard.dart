import 'package:flutter/material.dart';
import 'package:stori/constants.dart';
import 'package:stori/models/BookModel.dart';

Widget bookCard(BookModel book) {
  return Container(
    child: Text(
      book.title,
      style: TextStyle(
        color: primaryTextColor,
      ),
    ),
  );
}
