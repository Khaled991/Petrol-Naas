import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

String prepareDateToPrint(String date) {
  DateTime invoiceDate = DateTime.parse(date);
  String dateString = DateFormat("dd-MM-yyyy").format(invoiceDate);

  return dateString;
}

String prepareTimeToPrint(String date) {
  DateTime invoiceDate = DateTime.parse(date);
  String dateString = DateFormat("hh:mma").format(invoiceDate);

  return dateString;
}

String prepareDateAndTimeToPrint(String date) {
  DateTime invoiceDate = DateTime.parse(date);
  String dateString = DateFormat("dd-MM-yyyy hh:mma").format(invoiceDate);

  return dateString;
}
