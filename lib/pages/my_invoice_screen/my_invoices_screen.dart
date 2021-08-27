import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/widget/snack_bars/show_snack_bar.dart';
import 'package:provider/src/provider.dart';
import 'package:petrol_naas/widget/my_invoices_screen_header.dart';
import 'package:petrol_naas/widget/invoice_list_style.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../constants.dart';
import 'my_invoice_info.dart';

class MyInvoicesScreen extends StatefulWidget {
  const MyInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<MyInvoicesScreen> createState() => _MyInvoicesScreenState();
}

class _MyInvoicesScreenState extends State<MyInvoicesScreen> {
  bool isLoading = true;
  int _page = 1;
  final ScrollController _myInvoicesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storeMyInvoices = context.read<MyInvoices>();

    if (storeMyInvoices.myInvoices.isEmpty) {
      changeLoadingState(true);
      getInvoices();
    } else {
      changeLoadingState(false);
    }

    _myInvoicesScrollController.addListener(() {
      final double currentScrollPosition =
          _myInvoicesScrollController.position.pixels;
      final double maxScrollPosition =
          _myInvoicesScrollController.position.maxScrollExtent;
      if (currentScrollPosition == maxScrollPosition) {
        _page++;
        getInvoices();
      }
    });
  }

  @override
  void dispose() {
    _myInvoicesScrollController.dispose();
    super.dispose();
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  Future<void> getInvoices() async {
    final store = context.read<UserStore>();
    try {
      String url =
          'http://5.9.215.57/petrolnaas/public/api/invoice?Createduserno=${store.user.userNo}&page=$_page';
      Response response = await Dio().get(
        url,
      );

      final storeMyInvoices = context.read<MyInvoices>();
      var jsonRespone = response.data;
      storeMyInvoices.jsonToInvoicesList(jsonRespone);
      
      changeLoadingState(false);
    } on DioError {
      ShowSnackBar(context, 'حدث خطأ ما، الرجاء المحاولة مرة اخرى');
      changeLoadingState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeMyInvoices = context.watch<MyInvoices>();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          MyInvoicesScreenHeader(changeLoadingState: changeLoadingState),
          Expanded(
            child: isLoading
                ? SingleChildScrollView(
                    child: SkeletonLoader(
                      builder: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: 50,
                              color: Colors.white,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 9,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 120,
                                    height: 9,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 9,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      items: 10,
                      period: Duration(seconds: 2),
                      highlightColor: primaryColor,
                      direction: SkeletonDirection.rtl,
                    ),
                  )
                : storeMyInvoices.myInvoices.isNotEmpty
                    ? ListView.builder(
                        controller: _myInvoicesScrollController,
                        itemCount: storeMyInvoices.myInvoices.length,
                        itemBuilder: (BuildContext context, int index) {
                          Invoice invoice = storeMyInvoices.myInvoices[index];

                          final date = invoice.header!.invdate!.split(' ')[0];
                          final invno = invoice.header!.invno!;

                          return InvoiceList(
                            tittle: invoice.header!.custName!,
                            billNumber: invno,
                            date: date,
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MyInvoiceInfo(
                                    invno: invno,
                                  ),
                                ),
                              ),
                            },
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mood_bad_outlined,
                              size: 60.0, color: darkColor.withOpacity(0.75)),
                          Text(
                            'لا توجد نتائج',
                            style: TextStyle(
                              color: darkColor.withOpacity(0.75),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
