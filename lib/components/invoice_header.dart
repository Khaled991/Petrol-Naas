import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class InvoiceHeader extends StatefulWidget {
  const InvoiceHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<InvoiceHeader> createState() => _InvoiceHeaderState();
}

class _InvoiceHeaderState extends State<InvoiceHeader> {
  String? _firstDate;
  String? _lastDate;
  Invoice _invoice = Invoice();
  String? _custNo;

  List<Invoice> prepareInvoiceList(dynamic invoiceList) {
    List<Invoice> invoices = List<Invoice>.from(
      invoiceList.map(
        (invoice) => Invoice.fromJson(invoice),
      ),
    );
    return invoices;
  }

  Future<void> getInvoices(
      {required DateTime from, required DateTime to}) async {
    if (from != null && to != null) {
      _firstDate = DateFormat("yyyy-MM-dd").format(from);
      _lastDate = DateFormat("yyyy-MM-dd").format(to);
    }
    final store = context.read<UserStore>();

    try {
      String url =
          'http://192.168.1.2/petrolnaas/public/api/invoice?Createduserno=${store.user.userNo}';
// &from=$dateFrom&to=$dateTo
      if (_firstDate != null && _lastDate != null)
        url += "&from=$_firstDate&to=$_lastDate";
      if (_custNo != null) url += "&Custno=$_custNo";
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
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'جميع الفواتير',
            style: TextStyle(
              color: darkColor,
              fontSize: 18.0,
            ),
          ),
          TextButton(
            child: Icon(
              Icons.filter_alt_outlined,
              size: 33.0,
              color: primaryColor,
            ),
            onPressed: () => showFilterModal(context),
          ),
        ],
      ),
    );
  }

  void onPressFilter() {
    DateTime from = DateTime.parse(_firstDate ?? "");
    DateTime to = DateTime.parse(_lastDate ?? "");
    bool isUsingDateFilter = _firstDate != null && _lastDate != null;
    bool toIsGreaterThenFrom = from.compareTo(to) < 0;
    if (isUsingDateFilter) {
      if (toIsGreaterThenFrom) {
        getInvoices(to: to, from: from);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('التاريخ غير صحيح'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> showFilterModal(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext ctx, setState) {
                return Column(
                  children: [
                    Text(
                      'ترتيب الفواتير',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: darkColor,
                      ),
                    ),
                    Divider(),
                    Observer(builder: (_) {
                      final customersStore = context.watch<CustomerStore>();

                      return SizedBox(
                        width: double.infinity,
                        child: CustomDropdown(
                          itemsList: customersStore
                              .getCustomersNames(customersStore.customers),
                          text: 'اسم العميل',
                          onChange: (int) {},
                        ),
                      );
                    }),
                    Divider(),
                    Text(
                      'اختيار تاريخ',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: darkColor,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              ).then(
                                (date) {
                                  setState(() {
                                    _firstDate =
                                        DateFormat("dd-MM-yyyy").format(date!);
                                  });
                                },
                              );
                            },
                            buttonColors: primaryColor,
                            text: 'من',
                            icon: Icons.date_range_outlined,
                            textColors: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            _firstDate ?? "",
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              ).then(
                                (date) {
                                  setState(() {
                                    _lastDate =
                                        DateFormat("dd-MM-yyyy").format(date!);
                                  });
                                },
                              );
                            },
                            buttonColors: primaryColor,
                            text: 'إلي',
                            icon: Icons.date_range_outlined,
                            textColors: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            _lastDate ?? "",
                            style: TextStyle(
                              color: darkColor,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonColors: greenColor,
                            onPressed: onPressFilter,
                            text: 'تصفية النتائج',
                            textColors: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            buttonColors: redColor,
                            onPressed: () => Navigator.pop(context),
                            text: 'إلغاء',
                            textColors: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
            });
      },
    );
  }
}
