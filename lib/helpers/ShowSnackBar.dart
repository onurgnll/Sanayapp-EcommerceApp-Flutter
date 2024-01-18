import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(right: 40, left: 40, bottom: 35.0),
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 24),
    ),
    duration: Duration(seconds: 2),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
