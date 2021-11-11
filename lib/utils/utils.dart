import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void navigatePush(BuildContext context, Widget widgetToNavigate) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widgetToNavigate),
  );
}

void navigatePushReplace(BuildContext context, Widget widgetToNavigate) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widgetToNavigate),
  );
}
