import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petrol_naas/components/custom_text_field.dart';
import 'package:petrol_naas/models/state_node.dart';

class HeaderTrailingModel {
  IconData icon;
  void Function()? onPressed;

  HeaderTrailingModel({
    required this.icon,
    required this.onPressed,
  });
}

class CustomHeader extends StatefulWidget {
  final String title;
  final bool? showBackButton;
  final HeaderTrailingModel? trailing;
  final StateNode<bool>? isSearchingStateNode;
  final void Function(String)? onSearchChanged;
  final TextEditingController? searchTextFieldController;

  const CustomHeader({
    Key? key,
    required this.title,
    this.trailing,
    this.showBackButton,
    this.isSearchingStateNode,
    this.onSearchChanged,
    this.searchTextFieldController,
  }) : super(key: key);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  void toggleSearch() {
    widget.isSearchingStateNode!.setValue(widget.isSearchingStateNode!.value);
    widget.searchTextFieldController!.text = "";

    widget.isSearchingStateNode!.setValue(!widget.isSearchingStateNode!.value);
  }

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
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: -15,
            left: -15,
            child: HeaderShape(
              headerColor: Color(0x88f8cf34),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: -30,
            child: HeaderShape(
              headerColor: Color(0xfff8cf34),
              child: widget.isSearchingStateNode != null &&
                      widget.isSearchingStateNode!.value == true
                  ? _renderSearchHeader()
                  : _renderDefaultHeader(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSearchHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _backButton(toggleSearch),
        Expanded(
          child: CustomTextField(
            type: CustomTextFieldTypes.transparent,
            hintText: "بحث ...",
            showClearButton: true,
            controller: widget.searchTextFieldController,
          ),
        ),
      ],
    );
  }

  Widget _renderDefaultHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.showBackButton == true
            ? _backButton()
            : _openDrawerButton(context),
        Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
        widget.trailing != null
            ? IconButton(
                icon: Icon(
                  widget.trailing!.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: widget.trailing!.icon == Icons.search
                    ? toggleSearch
                    : widget.trailing?.onPressed,
              )
            : SizedBox(
                width: 35.5,
              ),
      ],
    );
  }

  Widget _backButton([void Function()? onPressed]) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.white,
      ),
    );

    // MaterialButton(
    //   onPressed: onPressed,
    //   child: SvgPicture.asset(
    //     'assets/SVG/back.svg',
    //     color: Colors.white,
    //     width: 20.0,
    //     height: 20.0,
    //   ),
    // );
  }

  Widget _openDrawerButton(context) {
    return TextButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      child: SvgPicture.asset(
        'assets/SVG/menu.svg',
        color: Colors.white,
        width: 35.0,
      ),
    );
  }
}

class HeaderShape extends StatelessWidget {
  final Color headerColor;
  final Widget? child;
  // final GlobalKey<ScaffoldState>? _scaffoldKey;
  // final HeaderTrailingModel? trailing;
  // final String? title;
  // final bool? showBackButton;
  // final bool? isSearching;
  // final void Function()? toggleSearch;

  const HeaderShape({
    Key? key,
    required this.headerColor,
    this.child,
    // this.title,
    //   required this.showBackButton,
    //   required this.trailing,
    //   this.isSearching,
    //   this.toggleSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: headerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: child,
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
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
