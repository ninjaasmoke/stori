import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/BookCard.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/RecomendedBooksBloc.dart';
import 'package:stori/logic/UserLogic.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/pages/Book.dart';
import 'package:stori/pages/Profile.dart';
import 'package:stori/pages/Search.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with TickerProviderStateMixin {
  late AnimationController _colorAnimation;
  late Animation _colorTween;

  @override
  void initState() {
    _colorAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.black)
        .animate(_colorAnimation);
    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical &&
        scrollInfo.metrics.pixels < 400) {
      _colorAnimation.animateTo(scrollInfo.metrics.pixels / 240);
    }
    return true;
  }

  int _currentBodyIndex = 0;

  void _babTapHandle(int index) {
    setState(() {
      _currentBodyIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (c, s) {
        if (s is LoggedInUserState) {
          return AnimatedBuilder(
              animation: _colorTween,
              builder: (co, st) {
                return Scaffold(
                  appBar: _appBar(s.user.photoURL, c, _colorTween.value),
                  body: IndexedStack(
                    index: _currentBodyIndex,
                    children: [
                      _recBooksBody(c, s),
                      _myBooksBody(c, s),
                    ],
                  ),
                  extendBodyBehindAppBar: true,
                  bottomNavigationBar: _bottomNavBar(),
                );
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      listener: (c, s) {},
    );
  }

  AppBar _appBar(String? url, BuildContext context, Color appbgcolor) {
    return AppBar(
      backgroundColor: appbgcolor,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        'stori',
        style: TextStyle(
          fontFamily: TITLE_FONT,
          fontSize: 28.0,
          letterSpacing: 2.0,
          fontWeight: FontWeight.w900,
          color: accentcolor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          },
          icon: Icon(
            CupertinoIcons.search,
          ),
        ),
        IconButton(
          iconSize: 16.0,
          icon: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              radius: 18.0,
              backgroundImage: url != null
                  ? NetworkImage(url)
                  : NetworkImage(IMAGE_NOT_FOUND_URL),
              backgroundColor: Colors.transparent,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
      ],
    );
  }

  BottomNavigationBar _bottomNavBar() {
    return BottomNavigationBar(
      elevation: 0,
      onTap: _babTapHandle,
      currentIndex: _currentBodyIndex,
      backgroundColor: bottomNavBarColor,
      unselectedItemColor: unselectedIconColor,
      selectedItemColor: primaryTextColor,
      selectedFontSize: 11.0,
      unselectedFontSize: 11.0,
      iconSize: 18.0,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: SizedBox(
              height: 16.0,
              width: 16.0,
              child: ImageIcon(
                AssetImage(
                  _currentBodyIndex == 0
                      ? 'assets/icons/home_.png'
                      : 'assets/icons/home.png',
                ),
              ),
            ),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Icon(
              _currentBodyIndex == 1
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
            ),
          ),
          label: "Your Books",
        ),
      ],
    );
  }

  Widget _recBooksBody(BuildContext userContext, LoggedInUserState userState) {
    return BlocBuilder<RecBooksBloc, RecBooksState>(
      builder: (context, state) {
        if (state is LoadedRecBooksState)
          return NotificationListener<ScrollNotification>(
            onNotification: _scrollListener,
            child: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          state.bookOfDay.imageUrl.isNotEmpty
                              ? state.bookOfDay.imageUrl
                              : IMAGE_NOT_FOUND_URL,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: darkgradiedColor,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BookPage(
                                book: state.bookOfDay,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 120,
                              height: 180,
                              child: customCachedNetworkImage(
                                url: state.bookOfDay.imageUrl,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.bookOfDay.title,
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 18.0,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Book of the day • " + state.bookOfDay.authors[0],
                              style: TextStyle(
                                color: tertiaryTextColor,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: state.booksList
                        .map(
                          (e) => _booksRow(
                            e,
                            state.topics[state.booksList.indexOf(e)],
                            userContext,
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          );
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(accentcolor),
          ),
        );
      },
    );
  }

  Widget _booksRow(List<BookModel> books, String title, BuildContext context) {
    return Padding(
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
                    fontFamily:
                        GoogleFonts.kumbhSans(fontWeight: FontWeight.w700)
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

  Widget _myBooksBody(BuildContext context, LoggedInUserState userState) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        if (userState is LoggedInUserState && userState.hasBooks.isNotEmpty)
          _booksRow(
            userState.hasBooks.reversed.toList(),
            "Books you have",
            context,
          ),
        if (userState is LoggedInUserState && userState.wantBooks.isNotEmpty)
          _booksRow(
            userState.wantBooks.reversed.toList(),
            "Books you want",
            context,
          ),
      ],
    );
  }
}
