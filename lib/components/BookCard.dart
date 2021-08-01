import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/models/BookModel.dart';

Widget bookCard(BookModel book) {
  return customCachedNetworkImage(
    url: book.imageUrl,
    title: book.title,
  );
}
