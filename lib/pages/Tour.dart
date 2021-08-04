import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/UserLogic.dart';

class TourPage extends StatefulWidget {
  const TourPage({Key? key}) : super(key: key);

  @override
  _TourPageState createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  double _btnOpacity = 0.0, _textOpacity = 0.0, _nameOpacity = 0.0;
  int _currentIndex = 0;
  bool _startTour = false;

  late PageController _pageController;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => {
        Timer(Duration(milliseconds: 400), () {
          setState(() {
            _nameOpacity = 1.0;
          });
        }),
        Timer(Duration(milliseconds: 1200), () {
          setState(() {
            _textOpacity = 1.0;
          });
        }),
        Timer(Duration(milliseconds: 2000), () {
          setState(() {
            _btnOpacity = 1.0;
          });
        }),
      },
    );
    _pageController = new PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is NewLoggedInUserState) {
          return !_startTour
              ? _firstPage(state.user.username!)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$index",
                                style: TextStyle(color: accentcolor),
                              ),
                            ],
                          );
                        },
                        itemCount: 10,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: primaryTextColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0))),
                      onPressed: () {
                        setState(() {
                          _pageController.animateToPage(
                            _currentIndex += 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                        });
                      },
                      child: Text(
                        "\t\tNext\t\t",
                        style: TextStyle(
                          color: darkTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }

  Widget _firstPage(String name) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                opacity: _nameOpacity,
                duration: Duration(milliseconds: 400),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hi, ',
                      style: GoogleFonts.kumbhSans(
                        fontSize: 32.0,
                        color: primaryTextColor,
                      ),
                    ),
                    Text(
                      name.split(' ')[0],
                      style: GoogleFonts.kumbhSans(
                        fontSize: 32.0,
                        color: accentcolor,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _textOpacity,
                duration: Duration(milliseconds: 400),
                child: Text(
                  "\nSince you just created an account, would you like to take a tour?",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 20.0,
                    color: primaryTextColor,
                    height: 1.4,
                  ),
                ),
              )
            ],
          ),
          SizedBox(),
          AnimatedOpacity(
            duration: Duration(milliseconds: 400),
            opacity: _btnOpacity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: primaryTextColor,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0))),
                  onPressed: () {
                    context.read<UserBloc>().add(FetchUserEvent());
                  },
                  child: Text(
                    "Nah, I'm good.",
                    style: TextStyle(
                      color: primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: primaryTextColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0))),
                  onPressed: () {
                    setState(() {
                      _startTour = true;
                    });
                  },
                  child: Text(
                    "\t\tYeah!\t\t",
                    style: TextStyle(
                      color: darkTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
