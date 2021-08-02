import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:stori/components/BookCard.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/SimilarBooksLogic.dart';
import 'package:stori/models/BookModel.dart';

class BookPage extends StatefulWidget {
  final BookModel book;
  const BookPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<SimilarBooksBloc>()
        .add(FetchSimilarBooksEvent(bookName: widget.book.title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: secondaryTextColor,
          ),
        ),
        elevation: 0,
      ),
      body: _body(widget.book, context),
    );
  }

  Widget _body(BookModel book, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _banner(book, context),
          _details(book, context),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: primaryTextColor,
                  indicatorColor: accentcolor,
                  tabs: [
                    Tab(
                      text: 'Details',
                    ),
                    Tab(
                      text: 'More Like This',
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.88,
                  child: TabBarView(
                    children: [
                      _desc(book, context),
                      _similarBooks(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner(BookModel book, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
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
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Color(0x99000000),
                  Colors.black,
                ],
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 200,
                width: 120,
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
                  Text(
                    "\t\t" +
                        (book.authors.isNotEmpty ? book.authors[0] : "Unkown"),
                    style: TextStyle(color: primaryTextColor),
                  ),
                ],
              ),
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
            style: GoogleFonts.raleway(
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          book.subTitle.isNotEmpty
              ? Text(
                  book.subTitle,
                  style: TextStyle(
                    color: tertiaryTextColor,
                    fontSize: 14,
                  ),
                )
              : Container(),
          Text(
            book.publisher +
                (book.pageCount == 0
                    ? ""
                    : " • " + book.pageCount.toString() + " pages"),
            style: TextStyle(
              color: tertiaryTextColor,
              fontSize: 14,
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: book.authors
                .map(
                  (author) => Text(
                    "•\t" + author + "\t",
                    style: TextStyle(
                      color: primaryTextColor,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryTextColor,
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.share_arrival_time, color: darkTextColor),
                  label: Text(
                    "\tI have this.",
                    style: TextStyle(
                      color: darkTextColor,
                      fontFamily:
                          GoogleFonts.dmSans(fontWeight: FontWeight.w700)
                              .fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryTextColor),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.save_alt, color: primaryTextColor),
                  label: Text(
                    "\t I want this.",
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
          SizedBox(
            height: 8.0,
          ),
          Text(
            parse(book.snippet).body!.innerHtml,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _desc(BookModel book, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Text(
        book.description,
        style: TextStyle(
          color: primaryTextColor,
        ),
      ),
    );
  }

  Widget _similarBooks() {
    List<BookModel> _similarBooks = [];
    return BlocBuilder<SimilarBooksBloc, SimilarBooksState>(builder: (c, s) {
      if (s is LoadedSimilarBooksState) {
        _similarBooks = s.similarBooks;
      }
      if (s is LoadingSimilarBooksState) {
        return Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator()
          ],
        );
      }
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 6.0,
          mainAxisExtent: 180,
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => BookPage(book: _similarBooks[index]),
                  fullscreenDialog: false,
                ),
              );
            },
            child: bookCard(_similarBooks[index])),
        itemCount: _similarBooks.length,
      );
    });
  }
}
