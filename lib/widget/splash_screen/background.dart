import 'package:flutter/cupertino.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;
  const SplashBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/shape1.png',
              width: size.width * 0.5,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/shape2.png',
              width: size.width * 0.2,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/shape3.png',
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
