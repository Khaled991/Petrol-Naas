import 'package:flutter/cupertino.dart';

class InvoiceDetails extends StatelessWidget {
  const InvoiceDetails({
    Key? key,
    required this.title,
    required this.result,
  }) : super(key: key);
  final String title;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Text(
            result,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
