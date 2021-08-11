import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/components/splash_screen_style.dart';
import 'package:petrol_naas/home/sign_in.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(microseconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SignIn(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SplashScreenStyle(),
    );
  }
}
