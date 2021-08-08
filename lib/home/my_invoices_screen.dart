import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:provider/src/provider.dart';

import 'package:petrol_naas/components/invoice_header.dart';
import 'package:petrol_naas/components/invoice_list_style.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/models/invoice.dart';

import 'my_invoices_info.dart';

class MyInvoicesScreen extends StatefulWidget {
  const MyInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<MyInvoicesScreen> createState() => _MyInvoicesScreenState();
}

class _MyInvoicesScreenState extends State<MyInvoicesScreen> {
  @override
  void initState() {
    super.initState();
    getInvoices();
  }

  @override
  void dispose() {
    //TODO: delete MyInvoices
    super.dispose();
  }

  Future<void> getInvoices() async {
    final store = context.read<UserStore>();

    try {
      String url =
          'http://192.168.1.2/petrolnaas/public/api/invoice?Createduserno=${store.user.userNo}';
      Response response = await Dio().get(
        url,
      );

      final storeMyInvoices = context.read<MyInvoices>();
      var jsonRespone = response.data;
      storeMyInvoices.jsonToInvoicesList(jsonRespone);
      print(storeMyInvoices);
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeMyInvoices = context.watch<MyInvoices>();

    return Column(
      children: [
        InvoiceHeader(),
        Expanded(
          child: Observer(builder: (_) {
            return ListView.builder(
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
                        builder: (_) => MyInvoicesInfo(
                          invno: invno,
                        ),
                      ),
                    ),
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
