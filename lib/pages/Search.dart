import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stori/components/BookCard.dart';
import 'package:stori/constants.dart';
import 'package:stori/logic/BooksLogic.dart';
import 'package:stori/models/BookModel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool searchEnabled = false;
  FocusNode _focus = new FocusNode();
  TextEditingController _controller = new TextEditingController();

  List<BookModel> books = [];

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
      body: BlocConsumer<SearchBooksBloc, SearchBooksState>(
        builder: (context, state) {
          if (state is SearchSearchBooksState) {
            books = state.books;
          }
          return _body(state);
        },
        listener: (context, state) {},
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: appBarBGColor,
      automaticallyImplyLeading: true,
      title: Text('Discover'),
    );
  }

  Widget _body(SearchBooksState s) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          _searchBar(),
          SizedBox(
            height: 12.0,
          ),
          _searchResults(books), // TODO : else render popular searches
          if (s is ErrorSearchBooksState)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  s.errorMessage,
                  style: TextStyle(
                    color: accentcolor,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _searchResults(List<BookModel> books) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      padding: new EdgeInsets.only(bottom: 78),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 6.0,
          mainAxisExtent: 200,
          crossAxisCount: 3,
        ),
        itemBuilder: (_, index) => bookCard(books[index]),
        itemCount: books.length,
      ),
    );
  }

  Widget _searchBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: MediaQuery.of(context).size.width,
      padding: searchEnabled
          ? EdgeInsets.all(0)
          : EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 52,
      child: Container(
        color: searchBarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: searchEnabled ? 12 : 20,
            ),
            Icon(
              Icons.search,
              color: lightIconColor,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: searchEnabled ? 26 : 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 120.0,
              child: TextField(
                onSubmitted: (String pattern) {
                  if (pattern.isNotEmpty)
                    context
                        .read<SearchBooksBloc>()
                        .add(SearchSearchBooksEvent(pattern: pattern));
                },
                focusNode: _focus,
                controller: _controller,
                style: TextStyle(
                  color: primaryTextColor,
                ),
                cursorColor: primaryTextColor,
                textInputAction: TextInputAction.search,
                smartQuotesType: SmartQuotesType.enabled,
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
      ),
    );
  }
}
