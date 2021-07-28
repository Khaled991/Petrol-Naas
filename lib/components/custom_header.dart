import 'package:flutter/material.dart';

import '../constants.dart';

class CustomHeader extends StatelessWidget {
  final String title;

  const CustomHeader({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.title,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 30.0,
            bottom: 50.0,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Positioned(
                  top: 50.0,
                  left: 20.0,
                  child: TextButton(
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    child: Image.asset('assets/images/menu.png', width: 35.0),
                  ),
                ),
              ),
              Positioned(
                top: 50.0,
                left: 100.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    fontFamily: 'Changa',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 90);
    path.quadraticBezierTo(0, size.height, 80, size.height - 20);
    path.lineTo(size.width - 80, size.height - 80);
    path.quadraticBezierTo(
      size.width,
      size.height - 100,
      size.width,
      size.height - 150,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
