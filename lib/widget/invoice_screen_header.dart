import 'package:flutter/material.dart';

import '../constants.dart';

class InvoiceScreenHeader extends StatelessWidget {
  const InvoiceScreenHeader({
    Key? key,
    required this.taxNo,
  }) : super(key: key);
  final String taxNo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: darkColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
              child: Text(
                'Petrol Naas مصنع بترول ناس',
                style: TextStyle(
                  fontSize: 20.0,
                  color: darkColor,
                ),
              ),
            ),
            Text(
              'الرقم الضريبي : $taxNo',
              style: TextStyle(
                fontSize: 16.0,
                color: darkColor,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: darkColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'دخال مبيعات',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: darkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/images/logo.png',
          width: 100,
        ),
      ],
    );
  }
}
