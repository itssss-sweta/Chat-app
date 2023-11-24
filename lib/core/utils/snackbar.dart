import 'package:flutter/material.dart';

void displaySnackBar({String? content, Color? color}) {
  GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  scaffoldKey.currentState?.showSnackBar(
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
