import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/BookCard.dart';
import 'package:stori/components/BooksRow.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/constants.dart';
import 'package:stori/helper/utils.dart';
import 'package:stori/logic/ClosestLogic.dart';
import 'package:stori/logic/PersonLogic.dart';
import 'package:stori/logic/RecomendedBooksBloc.dart';
import 'package:stori/logic/UserLogic.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/models/UserModel.dart';
import 'package:stori/pages/Book.dart';
import 'package:stori/pages/PersonProfile.dart';
import 'package:stori/pages/Profile.dart';
import 'package:stori/pages/Search.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with TickerProviderStateMixin {
  late AnimationController _colorAnimation
      //  _pulseAnimation
      ;
  late Animation _colorTween;

  @override
  void initState() {
    _colorAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: appBarBGColor)
        .animate(_colorAnimation);
    // _pulseAnimation = new AnimationController(
    //   vsync: this,
    // );
    // _startAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _colorAnimation.dispose();
    // _pulseAnimation.dispose();
    super.dispose();
  }

  // void _startAnimation() {
  //   _pulseAnimation.stop();
  //   _pulseAnimation.reset();
  //   _pulseAnimation.repeat(
  //     period: Duration(milliseconds: 400),
  //   );
  // }

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

  List<AppUser> users = [];

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
                    _recBooksBody(c),
                    _myBooksBody(c, s),
                  ],
                ),
                extendBodyBehindAppBar: true,
                bottomNavigationBar: _bottomNavBar(),
              );
            },
          );
        }
        if (s is UpdatingUserState) {
          return AnimatedBuilder(
            animation: _colorTween,
            builder: (co, st) {
              return Scaffold(
                appBar: _appBar(s.user.photoURL, c, _colorTween.value),
                body: IndexedStack(
                  index: _currentBodyIndex,
                  children: [
                    _recBooksBody(c),
                    _myBooksBody(c, s),
                  ],
                ),
                extendBodyBehindAppBar: true,
                bottomNavigationBar: _bottomNavBar(),
              );
            },
          );
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
        SizedBox(
          width: 4.0,
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

  Widget _recBookOfDay(BuildContext context, BookModel bookOfDay) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
            bookOfDay.imageUrl.isNotEmpty
                ? bookOfDay.imageUrl
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
            colors: darkgradientColor,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => BookPage(
                  book: bookOfDay,
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
                  url: bookOfDay.imageUrl,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bookOfDay.title,
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
                "Book of the day • " + bookOfDay.authors[0],
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
    );
  }

  Widget _recBooksBody(BuildContext userContext) {
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
                  _recBookOfDay(context, state.bookOfDay),
                  Column(
                    children: state.booksList
                        .map(
                          (e) => booksRow(
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

  Widget _myBooksBody(BuildContext context, UserState userState) {
    return NotificationListener<ScrollNotification>(
      onNotification: _scrollListener,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            if (userState is LoggedInUserState && userState.hasBooks.isNotEmpty)
              booksRow(
                userState.hasBooks.reversed.toList(),
                "Books you have",
                context,
              ),
            if (userState is LoggedInUserState &&
                userState.wantBooks.isNotEmpty)
              booksRow(
                userState.wantBooks.reversed.toList(),
                "Books you want",
                context,
              ),
            if (userState is LoggedInUserState)
              // CustomPaint(
              //   painter: new SpritePainter(_pulseAnimation),
              //   child: new SizedBox(
              //     width: 200.0,
              //     height: 200.0,
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
                child: BlocConsumer<ClosestPeopleBloc, ClosestPeopleState>(
                    builder: (c, s) {
                      if (s is InitClosestPeopleState) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  c
                                      .read<ClosestPeopleBloc>()
                                      .add(FetchClosestPeopleEvent());
                                },
                                child: Text(
                                  "Find people to exchange books.",
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w700,
                                    color: darkTextColor,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: primaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (s is FetchedClosestPeopleState) {
                        users = s.people;
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  "People around you",
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: GoogleFonts.kumbhSans(
                                            fontWeight: FontWeight.w700)
                                        .fontFamily,
                                  ),
                                ),
                              ),
                              (s is FetchingClosestPeopleState)
                                  ? Container(
                                      height: 48.0,
                                      width: 48.0,
                                      padding: EdgeInsets.all(14.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        c
                                            .read<ClosestPeopleBloc>()
                                            .add(FetchClosestPeopleEvent());
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: lightIconColor,
                                      ),
                                    ),
                            ],
                          ),
                          Column(
                            children: users.map((user) {
                              if (user.uid == userState.user.uid) {
                                return Container();
                              }
                              double distanceBwUsers = distance(
                                  userState.user.location, user.location);
                              return ListTile(
                                onTap: () {
                                  context.read<PersonBloc>().add(
                                        FetchPersonBooks(
                                          hasBooks: user.hasBooks,
                                          wantsBooks: user.wantBooks,
                                        ),
                                      );
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => PersonProfilePage(
                                        person: user,
                                        dist: distanceBwUsers,
                                      ),
                                    ),
                                  );
                                },
                                title: Text(
                                  user.username!,
                                  style: GoogleFonts.dmSans(
                                    color: primaryTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '$distanceBwUsers km',
                                  style: GoogleFonts.dmSans(
                                    color: secondaryTextColor,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  child: customCachedNetworkImage(
                                    url: user.photoURL!,
                                  ),
                                ),
                                trailing: Icon(
                                  CupertinoIcons.forward,
                                  size: 20.0,
                                  color: tertiaryTextColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                    listener: (c, s) {}),
              ),
            if (userState is LoggedInUserState &&
                userState.wantBooks.isEmpty &&
                userState.hasBooks.isEmpty)
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Text(
                    "Find some books that you like!",
                    style: TextStyle(color: tertiaryTextColor),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
