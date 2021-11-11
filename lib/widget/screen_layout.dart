import 'package:flutter/material.dart';
import 'package:petrol_naas/models/state_node.dart';

import 'header/custom_drawer.dart';
import 'header/custom_header.dart';

class ScreenLayout extends StatefulWidget {
  final String title;
  final HeaderTrailingModel? trailing;
  final Widget child;
  final bool? showBackButton;
  final StateNode<String>? searchStateNode;

  final TextEditingController? searchTextFieldController;

  final StateNode<bool>? isSearchingStateNode;
  final void Function(String)? onSearchChanged;

  const ScreenLayout({
    Key? key,
    required this.title,
    this.trailing,
    required this.child,
    this.showBackButton,
    this.searchStateNode,
    this.isSearchingStateNode,
    this.onSearchChanged,
    this.searchTextFieldController,
  }) : super(key: key);

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Column(
        children: [
          CustomHeader(
            isSearchingStateNode: widget.isSearchingStateNode,
            onSearchChanged: widget.onSearchChanged,
            showBackButton: widget.showBackButton,
            title: widget.title,
            searchTextFieldController: widget.searchTextFieldController,
            trailing: widget.trailing != null
                ? HeaderTrailingModel(
                    icon: widget.trailing!.icon,
                    onPressed: widget.trailing!.onPressed,
                  )
                : null,
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
