import 'package:flutter/material.dart';
import 'package:petrol_naas/widget/screen_layout.dart';

class MyReceipts extends StatelessWidget {
  const MyReceipts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: "سندات القبض",
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Text("سنداsت"),
      ),
    );
  }
}
