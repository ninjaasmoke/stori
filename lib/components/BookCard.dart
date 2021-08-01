import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stori/constants.dart';
import 'package:stori/models/BookModel.dart';

Widget bookCard(BookModel book) {
  return CachedNetworkImage(
    imageUrl: book.imageUrl.isEmpty ? IMAGE_NOT_FOUND_URL : book.imageUrl,
    placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: searchBarColor,
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(tileColor),
          ),
        )),
    imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                book.imageUrl.isEmpty ? Colors.black45 : Colors.transparent,
                BlendMode.multiply),
          ),
          color: searchBarColor,
        ),
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          book.imageUrl.isEmpty ? book.title : "",
          style: TextStyle(
            color: primaryTextColor,
          ),
        )),
    errorWidget: (context, url, error) => Container(
        child: Icon(
      Icons.emoji_emotions,
      color: accentcolor,
    )),
  );
}
