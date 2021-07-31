import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stori/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool searchEnabled = false;
  FocusNode _focus = new FocusNode();
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      searchEnabled = !searchEnabled;
    });
  }

  void _loseFocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: appBarBGColor,
      automaticallyImplyLeading: true,
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 120),
          height: !searchEnabled ? 0 : 8.0,
        ),
        _searchBar(),
        AnimatedContainer(
          duration: Duration(milliseconds: 120),
          height: !searchEnabled ? 0 : 16.0,
        ),
        TextButton(
          onPressed: () {
            _loseFocus();
          },
          child: Text("something..."),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      width: MediaQuery.of(context).size.width,
      margin: searchEnabled ? EdgeInsets.all(0) : EdgeInsets.all(16.0),
      height: searchEnabled ? 48 : 40,
      color: searchBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 120),
            width: searchEnabled ? 12 : 20,
          ),
          Icon(
            Icons.search,
            color: lightIconColor,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 120),
            width: searchEnabled ? 26 : 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 120.0,
            child: TextField(
              focusNode: _focus,
              controller: _controller,
              style: TextStyle(
                color: primaryTextColor,
              ),
              cursorColor: primaryTextColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(0),
                hintText: "Search for books, people, etc.",
                hintStyle: TextStyle(
                  color: tertiaryTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
