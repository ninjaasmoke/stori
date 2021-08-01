import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/constants.dart';
import 'package:stori/models/BookModel.dart';

class BookPage extends StatelessWidget {
  final BookModel book;
  const BookPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: primaryTextColor,
            ),
          ),
        ],
      ),
      body: _body(book, context),
    );
  }

  Widget _body(BookModel book, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _banner(book, context),
          _details(book, context),
        ],
      ),
    );
  }

  Widget _banner(BookModel book, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: customCachedNetworkImage(
              url: book.imageUrl,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.58,
            width: MediaQuery.of(context).size.width,
            color: Color(0x96000000),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.58,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xf000000),
                  Color(0xf000000),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 192,
                width: 142,
                child: customCachedNetworkImage(
                  url: book.imageUrl,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    book.publishedDate.split('-')[0],
                    style: TextStyle(
                      color: primaryTextColor,
                    ),
                  ),
                  if (book.authors.isNotEmpty)
                    SizedBox(
                      width: 6.0,
                    ),
                  if (book.authors.isNotEmpty)
                    Text(
                      "•",
                      style: TextStyle(
                        color: primaryTextColor,
                      ),
                    ),
                  Row(
                    children: book.authors
                        .map(
                          (author) => Text(
                            "\t\t" + author,
                            style: TextStyle(
                              color: primaryTextColor,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: accentcolor,
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.save_alt, color: primaryTextColor),
                        label: Text(
                          "I HAVE THIS",
                          style: TextStyle(
                            color: primaryTextColor,
                            fontFamily:
                                GoogleFonts.dmSans(fontWeight: FontWeight.w700)
                                    .fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _details(BookModel book, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            book.subTitle,
            style: TextStyle(
              color: tertiaryTextColor,
              fontSize: 14,
            ),
          ),
          Text(
            book.publisher + " • " + book.pageCount.toString() + " pages",
            style: TextStyle(
              color: tertiaryTextColor,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            book.snippet,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}