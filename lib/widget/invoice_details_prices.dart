import 'package:flutter/material.dart';

import '../constants.dart';

class InvoiceDetailsPrices extends StatelessWidget {
  const InvoiceDetailsPrices({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: darkColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: Text(
                description,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
