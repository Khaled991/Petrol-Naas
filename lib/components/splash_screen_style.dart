import 'package:flutter/material.dart';
import '../constants.dart';
import 'background.dart';

class SplashScreenStyle extends StatelessWidget {
  const SplashScreenStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 110,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'PETROL NAAS',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 25.0,
                  fontFamily: 'Changa',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
            )
          ],
        ),
      ),
    );
  }
}
