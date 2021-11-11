import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/screens/sign_in/sign_in.dart';
import 'package:petrol_naas/widget/splash_screen/splash_screen_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2), () {
      // Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              // TestCompoennt(),

              SignIn(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenStyle(),
    );
  }
}

// class TestCompoennt extends StatefulWidget {
//   const TestCompoennt({Key? key}) : super(key: key);

//   @override
//   _TestCompoenntState createState() => _TestCompoenntState();
// }

// class _TestCompoenntState extends State<TestCompoennt> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             TextFieldTestComponent(),
//             TextButton(
//                 onPressed: () {
//                   setState(() {});
//                 },
//                 child: Text("PRess"))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TextFieldTestComponent extends StatelessWidget {
//   const TextFieldTestComponent({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField();
//   }
// }
