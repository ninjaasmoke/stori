import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/components/BooksRow.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/PersonLogic.dart';
import 'package:stori/models/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonProfilePage extends StatelessWidget {
  final AppUser person;
  final double dist;
  const PersonProfilePage({Key? key, required this.person, required this.dist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // automaticallyImplyLeading: true,
      ),
      body: _body(context),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  Widget _profile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: customCachedNetworkImage(url: this.person.photoURL!),
            ),
          ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Text(
          '\n${person.displayName}',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$dist km away from you.',
          style: TextStyle(
            color: tertiaryTextColor,
            fontSize: 16.0,
          ),
        ),
        Text(
          '${person.email}',
          style: TextStyle(
            color: tertiaryTextColor,
            fontSize: 16.0,
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                _launchURL('mailto:${person.email}');
              },
              child: Text(
                'Contact',
                style: TextStyle(
                  color: accentcolor,
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                ),
              ),
            ),
            Text('\t\t\t'),
            GestureDetector(
              onTap: () async {
                _launchURL('mailto:iumapplications@gmail.com');
              },
              child: Text(
                'Report',
                style: TextStyle(
                  color: accentcolor,
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _booksData(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
      builder: (c, s) {
        if (s is FetchedPersonBooksState) {
          return Column(
            children: [
              if (s.hasBooks.isNotEmpty)
                booksRow(
                  s.hasBooks,
                  "Has these",
                  context,
                ),
              if (s.wantBooks.isNotEmpty)
                booksRow(
                  s.wantBooks,
                  // this.person.username!.split(' ')[0] +
                  "Wants these",
                  context,
                ),
              if (s.hasBooks.isEmpty && s.wantBooks.isEmpty)
                Text(
                  "\nSeems like this person has no books!",
                  style: TextStyle(
                    color: primaryTextColor,
                  ),
                ),
            ],
          );
        }
        if (s is LoadingPersonBooksState)
          return Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s.loadingMessage,
                  style: TextStyle(
                    color: tertiaryTextColor,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                SizedBox(
                  height: 14.0,
                  width: 14.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ],
            ),
          );
        return Padding(
          padding: const EdgeInsets.all(40.0),
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profile(),
          _booksData(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\nBe respectful when contacting the person.\n',
              style: GoogleFonts.raleway(
                color: tertiaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
