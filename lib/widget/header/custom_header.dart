import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const CustomHeader({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.title,
    this.showBackButton = false,
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
            child: HeaderShape(
              headerColor: Color(0x66f8cf34),
              showBackButton: showBackButton,
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: -15,
            left: -15,
            child: HeaderShape(
              headerColor: Color(0x88f8cf34),
              showBackButton: showBackButton,
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: -30,
            child: HeaderShape(
              scaffoldKey: _scaffoldKey,
              title: title,
              showBackButton: showBackButton,
              headerColor: Color(0xfff8cf34),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderShape extends StatelessWidget {
  const HeaderShape({
    Key? key,
    GlobalKey<ScaffoldState>? scaffoldKey,
    this.title,
    required this.showBackButton,
    required this.headerColor,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState>? _scaffoldKey;
  final String? title;
  final Color headerColor;
  final bool showBackButton;

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
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_scaffoldKey != null)
                showBackButton ? _backButton(context) : _openDrawerButton(),
              if (title != null)
                Center(
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              SizedBox(
                width: 35.5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: SvgPicture.asset(
        "assets/SVG/back.svg",
        color: Colors.white,
        semanticsLabel: "Back Button",
        height: 20.0,
      ),
    );
  }

  Widget _openDrawerButton() {
    return TextButton(
      onPressed: () => _scaffoldKey!.currentState!.openDrawer(),
      child: Image.asset(
        'assets/images/menu.png',
        width: 35.0,
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
