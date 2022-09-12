import 'package:flutter/material.dart';

class GlobalSnackBar {
  final String text;

  GlobalSnackBar({required this.text});

  static show(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
