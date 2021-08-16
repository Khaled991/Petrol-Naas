import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:provider/src/provider.dart';

import 'package:petrol_naas/components/invoice_header.dart';
import 'package:petrol_naas/components/invoice_list_style.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../constants.dart';
import 'my_invoice_info.dart';

class MyInvoicesScreen extends StatefulWidget {
  const MyInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<MyInvoicesScreen> createState() => _MyInvoicesScreenState();
}

class _MyInvoicesScreenState extends State<MyInvoicesScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getInvoices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  Future<void> getInvoices() async {
    final store = context.read<UserStore>();
    changeLoadingState(true);
    try {
      String url =
          'http://192.168.1.2/petrolnaas/public/api/invoice?Createduserno=${store.user.userNo}';
      Response response = await Dio().get(
        url,
      );

      final storeMyInvoices = context.read<MyInvoices>();
      var jsonRespone = response.data;
      storeMyInvoices.jsonToInvoicesList(jsonRespone);
      changeLoadingState(false);
    } on DioError catch (e) {
      print(e);
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
          InvoiceHeader(changeLoadingState: changeLoadingState),
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
                      items: 8,
                      period: Duration(seconds: 2),
                      highlightColor: primaryColor,
                      direction: SkeletonDirection.rtl,
                    ),
                  )
                : ListView.builder(
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
                  ),
          ),
        ],
      ),
    );
  }
}
