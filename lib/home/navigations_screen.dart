import 'package:flutter/material.dart';
import 'package:petrol_naas/components/custom_drawer.dart';
import 'package:petrol_naas/components/custom_header.dart';
import 'package:petrol_naas/home/home_body.dart';
import 'invoice_screen.dart';

class NavigationsScreen extends StatefulWidget {
  final Widget? child;
  const NavigationsScreen({Key? key, this.child}) : super(key: key);

  @override
  _NavigationsScreenState createState() => _NavigationsScreenState();
}

class _NavigationsScreenState extends State<NavigationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentScreenIdx;
  List<Widget> bodies = [HomeBody(), InvoiceScreen()];
  List<String> headerTitles = ["أضافة فاتورة", "الفواتير"];

  @override
  void initState() {
    _currentScreenIdx = 0;
    super.initState();
  }

  void changeBodyIdx(int idx) {
    setState(() {
      _currentScreenIdx = idx;
    });
  }

  Widget _getBody() => bodies[_currentScreenIdx];
  String _getTitle() => headerTitles[_currentScreenIdx];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xf),
      key: _scaffoldKey,
      drawer: CustomDrawer(
        changeBodyIdx: changeBodyIdx,
      ),
      body: Column(
        children: [
          CustomHeader(
            scaffoldKey: _scaffoldKey,
            title: _getTitle(),
          ),
          Expanded(
            child: _getBody(),
          ),
        ],
      ),
    );
  }
}
