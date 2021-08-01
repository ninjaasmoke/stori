import 'package:flutter/material.dart';
import 'package:stori/components/CustomCachedImage.dart';
import 'package:stori/models/BookModel.dart';

Widget bookCard(BookModel book) {
  return customCachedNetworkImage(
    url: book.imageUrl,
    title: book.title,
  );
}
