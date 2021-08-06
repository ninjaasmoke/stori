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
        backgroundColor: appBarBGColor,
        // title: Text('${person.username!.split(' ')[0]}'),
        automaticallyImplyLeading: true,
      ),
      body: _body(context),
    );
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  Widget _profile() {
    return Container(
      height: 124.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${person.displayName}',
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
              Row(
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
                      'Report User',
                      style: TextStyle(
                        color: accentcolor,
                        decoration: TextDecoration.underline,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
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
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _profile(),
          _booksData(context),
          Center(
            child: Text(
              '\n\n"Make them an offer they can\'t refuse"',
              style: GoogleFonts.kumbhSans(
                color: tertiaryTextColor,
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
