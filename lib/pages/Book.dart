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
import 'package:stori/logic/UserLogic.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/models/UserModel.dart';

class BookPage extends StatefulWidget {
  final BookModel book;
  const BookPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> with TickerProviderStateMixin {
  late AnimationController _colorAnimation;
  late AnimationController _textAnimation;
  late Animation _colorTween, _textColorTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimation.animateTo(scrollInfo.metrics.pixels / 160);
      _textAnimation.animateTo((scrollInfo.metrics.pixels - 240) / 50);
    }
    return true;
  }

  @override
  void initState() {
    _colorAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.black)
        .animate(_colorAnimation);

    _textAnimation =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textColorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_textAnimation);
    context.read<SimilarBooksBloc>().add(FetchSimilarBooksEvent(
        bookName: widget.book.title +
            " " +
            widget.book.authors.map((e) => e).join(' ')));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (c, s) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: _colorTween.value,
            title: Text(
              widget.book.title,
              style: TextStyle(
                color: _textColorTween.value,
              ),
            ),
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
      },
    );
  }

  Widget _body(BookModel book, BuildContext context) {
    return NotificationListener(
      onNotification: _scrollListener,
      child: SingleChildScrollView(
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
                        text: 'More Like This',
                      ),
                      Tab(
                        text: 'Details',
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.88,
                    child: TabBarView(
                      children: [
                        _similarBooks(),
                        _desc(book, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  Color(0x99000000),
                  Color(0xaa000000),
                  Color(0xbb000000),
                  Color(0xcc000000),
                  Color(0xdd000000),
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
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          !context.watch<UserBloc>().currentUser.hasBooks.contains(book.id)
              ? TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryTextColor,
                  ),
                  onPressed: () {
                    context
                        .read<UserBloc>()
                        .add(UserAddHasBookEvent(bookId: book.id));
                  },
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
                )
              : TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryTextColor,
                  ),
                  onPressed: () {
                    context
                        .read<UserBloc>()
                        .add(UserRemoveHasBookEvent(bookId: book.id));
                  },
                  icon: Icon(Icons.share_arrival_time, color: darkTextColor),
                  label: Text(
                    "\tRemove from list.",
                    style: TextStyle(
                      color: darkTextColor,
                      fontFamily:
                          GoogleFonts.dmSans(fontWeight: FontWeight.w700)
                              .fontFamily,
                    ),
                  ),
                ),
          !context.watch<UserBloc>().currentUser.hasBooks.contains(book.id) &&
                  !context
                      .watch<UserBloc>()
                      .currentUser
                      .wantBooks
                      .contains(book.id)
              ? OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryTextColor),
                  ),
                  onPressed: () {
                    context
                        .read<UserBloc>()
                        .add(UserAddWantBookEvent(bookId: book.id));
                  },
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
                )
              : !context
                      .watch<UserBloc>()
                      .currentUser
                      .hasBooks
                      .contains(book.id)
                  ? OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryTextColor),
                      ),
                      onPressed: () {
                        context
                            .read<UserBloc>()
                            .add(UserRemoveWantBookEvent(bookId: book.id));
                      },
                      icon: Icon(
                        Icons.remove_circle_outline_rounded,
                        color: primaryTextColor,
                      ),
                      label: Text(
                        "\tRemove from wishlist.",
                        style: TextStyle(
                          color: primaryTextColor,
                          fontFamily:
                              GoogleFonts.dmSans(fontWeight: FontWeight.w700)
                                  .fontFamily,
                        ),
                      ),
                    )
                  : Container(),
          SizedBox(
            height: 8.0,
          ),
          Text(
            parse(book.snippet).body!.text,
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
