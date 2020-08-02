import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Widget avatar;
  final String text;

  Category({
    @required this.id,
    @required this.title,
    this.avatar,
    this.text
  });
}