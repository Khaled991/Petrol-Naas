import 'package:flutter/material.dart';
import 'package:petrol_naas/widget/header/custom_drawer.dart';
import 'package:petrol_naas/widget/header/custom_header.dart';
import 'package:petrol_naas/screens/add_invoice/add_invoice.dart';
import '../my_invoice_screen/my_invoices_screen.dart';

class NavigationsScreen extends StatefulWidget {
  final Widget? child;
  const NavigationsScreen({Key? key, this.child}) : super(key: key);

  @override
  _NavigationsScreenState createState() => _NavigationsScreenState();
}

class _NavigationsScreenState extends State<NavigationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentScreenIdx;
  List<Widget> bodies = [
    AddInvoice(),
    MyInvoicesScreen(),
  ];
  List<String> headerTitles = ["إضافة فاتورة", "الفواتير", "إضافة صنف"];

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
