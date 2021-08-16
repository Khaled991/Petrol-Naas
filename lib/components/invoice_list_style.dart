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
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: Column(
            children: [
              ListTile(
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
                  '$billNumber',
                ),
                trailing: Text(date),
                onTap: onTap,
              ),
            ],
          ),
        ),
        Divider(height: 0, color: darkColor.withOpacity(.25)),
      ],
    );
  }
}
