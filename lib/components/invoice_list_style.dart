import 'package:flutter/material.dart';

import '../constants.dart';

class InvoiceList extends StatelessWidget {
  const InvoiceList({
    Key? key,
    required this.tittle,
    required this.onTap,
    required this.date,
    required this.billNumber,
  }) : super(key: key);

  final String tittle;
  final String date;
  final String billNumber;
  // final int billNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8.0,
        0,
        8.0,
        13.0,
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_outlined,
                size: 40,
                color: primaryColor,
              ),
            ],
          ),
          title: Text(
            tittle,
            style: TextStyle(
              color: darkColor,
            ),
          ),
          subtitle: Text(
            '$billNumber\n$date',
          ),
          isThreeLine: true,
          onTap: onTap,
        ),
      ),
    );
  }
}
