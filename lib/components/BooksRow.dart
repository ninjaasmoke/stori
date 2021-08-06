import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/BookCard.dart';
import 'package:stori/constants.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/pages/Book.dart';

Widget booksRow(List<BookModel> books, String title, BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
              child: Text(
                title,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: GoogleFonts.kumbhSans(fontWeight: FontWeight.w700)
                      .fontFamily,
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: books
                .map(
                  (book) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => BookPage(book: book),
                          fullscreenDialog: false,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: bookCard(book),
                      height: 156,
                      width: 110,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );
}
