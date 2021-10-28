import 'package:flutter/material.dart';
import 'package:petrol_naas/screens/receipt_voucher/receipt_voucher_screen.dart';
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
    ReceiptVoucherScreen(),
  ];
  List<String> headerTitles = ["إضافة فاتورة", "الفواتير", "سند القبض"];
  List<IconData> optionIcons = [
    Icons.add_box_outlined,
    Icons.receipt_outlined,
    Icons.receipt_long_rounded,
  ];
  late final List<DrawerOptionModel> _drawerOptions;

  @override
  void initState() {
    super.initState();
    _currentScreenIdx = 0;

    _drawerOptions = List.generate(
      bodies.length,
      (int i) => DrawerOptionModel(
        body: bodies[i],
        icon: optionIcons[i],
        title: headerTitles[i],
      ),
    ).toList();
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
        drawerOptions: _drawerOptions,
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
