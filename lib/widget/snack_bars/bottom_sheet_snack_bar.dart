import 'package:flutter/material.dart';

import '../../constants.dart';

class BottomSheetSnackBar extends StatelessWidget {
  final String text;
  const BottomSheetSnackBar({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width - 40.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Text(text, style: TextStyle(color: Colors.white, fontSize: 14.0)),
      ),
    );
  }
}
