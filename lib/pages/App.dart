import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/BookCard.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/RecomendedBooksBloc.dart';
import 'package:stori/logic/UserLogic.dart';
import 'package:stori/models/BookModel.dart';
import 'package:stori/pages/Book.dart';
import 'package:stori/pages/Profile.dart';
import 'package:stori/pages/Search.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      builder: (c, s) {
        if (s is LoggedInUserState) {
          return Scaffold(
            appBar: _appBar(s.user.photoURL),
            body: _body(c, s),
            extendBodyBehindAppBar: true,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      listener: (c, s) {},
    );
  }

  AppBar _appBar(String? url) {
    return AppBar(
      backgroundColor: Colors.black87,
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

  Widget _body(BuildContext userContext, LoggedInUserState userState) {
    return BlocBuilder<RecBooksBloc, RecBooksState>(
      builder: (context, state) {
        if (state is LoadedRecBooksState)
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Column(
                  children: state.booksList
                      .map((e) => _booksRow(
                          e, state.topics[state.booksList.indexOf(e)]))
                      .toList(),
                )
              ],
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

  Widget _booksRow(List<BookModel> books, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: Text(
              title.replaceFirst(title[0], title[0].toUpperCase()),
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
                fontFamily:
                    GoogleFonts.raleway(fontWeight: FontWeight.w800).fontFamily,
              ),
            ),
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
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: bookCard(book),
                        height: 172,
                        width: 122,
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
}
