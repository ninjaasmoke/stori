import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stori/constants.dart';

Widget customCachedNetworkImage(
    {required String url,
    String title = "",
    Color bgColor = searchBarColor,
    Color loadColor = tertiaryTextColor}) {
  return CachedNetworkImage(
    imageUrl: url.isEmpty ? IMAGE_NOT_FOUND_URL : url,
    placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: bgColor,
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loadColor),
          ),
        )),
    imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                url.isEmpty ? Colors.black45 : Colors.transparent,
                BlendMode.multiply),
          ),
          color: searchBarColor,
        ),
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          url.isEmpty ? title : "",
          style: TextStyle(
            color: primaryTextColor,
          ),
        )),
    errorWidget: (context, url, error) => Container(
        child: Icon(
      Icons.emoji_emotions,
      color: primaryTextColor,
    )),
  );
}
