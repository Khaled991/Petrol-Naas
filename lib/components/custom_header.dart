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
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(height: 200.0),
          Positioned(
            width: MediaQuery.of(context).size.width,
            left: -30,
            child: HeaderShepe(
              headerColor: Color(0x66f8cf34),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: -15,
            left: -15,
            child: HeaderShepe(
              headerColor: Color(0x88f8cf34),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: -30,
            child: HeaderShepe(
              scaffoldKey: _scaffoldKey,
              title: title,
              headerColor: Color(0xfff8cf34),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderShepe extends StatelessWidget {
  HeaderShepe({
    Key? key,
    GlobalKey<ScaffoldState>? scaffoldKey,
    this.title,
    required this.headerColor,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState>? _scaffoldKey;
  String? title;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: headerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 30.0,
          ),
          child: Row(
            children: [
              if (_scaffoldKey != null)
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: TextButton(
                    onPressed: () => _scaffoldKey!.currentState!.openDrawer(),
                    child: Image.asset(
                      'assets/images/menu.png',
                      width: 35.0,
                    ),
                  ),
                ),
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
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
    path.quadraticBezierTo(0, size.height, 70, size.height - 10);
    path.lineTo(size.width - 80, size.height - 55);
    path.quadraticBezierTo(
      size.width,
      size.height - 70,
      size.width,
      size.height - 130,
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
