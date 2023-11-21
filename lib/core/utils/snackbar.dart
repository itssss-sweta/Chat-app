import 'package:flutter/material.dart';

void displaySnackBar(BuildContext context, {String? content, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content ?? ' ',
        style: TextStyle(
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.grey[350],
    ),
  );
}
