import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/memorizable_state.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class InvoiceHeader extends StatefulWidget {
  final void Function(bool state) changeLoadingState;
  const InvoiceHeader({
    required this.changeLoadingState,
    Key? key,
  }) : super(key: key);

  @override
  State<InvoiceHeader> createState() => _InvoiceHeaderState();
}

class _InvoiceHeaderState extends State<InvoiceHeader> {
  final MemorizableState<String> _firstDate = MemorizableState();
  final MemorizableState<String> _lastDate = MemorizableState();
  final MemorizableState<String> _custNo = MemorizableState();
  final MemorizableState<String> _cutName = MemorizableState();
  bool isErrorInDate = false;

  List<Invoice> prepareInvoiceList(dynamic invoiceList) {
    List<Invoice> invoices = List<Invoice>.from(
      invoiceList.map(
        (invoice) => Invoice.fromJson(invoice),
      ),
    );
    return invoices;
  }

  bool hasDateFilter() =>
      _firstDate.current != null && _lastDate.current != null;

  bool hasNameFilter() => _custNo.current != null;

  Future<void> getInvoices() async {
    try {
      final store = context.read<UserStore>();
      widget.changeLoadingState(true);

      String url =
          'http://192.168.1.2/petrolnaas/public/api/invoice?Createduserno=${store.user.userNo}';

      if (hasDateFilter()) {
        url += "&from=${_firstDate.current}&to=${_lastDate.current}";
      }
      if (hasNameFilter()) url += "&Custno=${_custNo.current}";
      Response response = await Dio().get(
        url,
      );

      final storeMyInvoices = context.read<MyInvoices>();
      var jsonRespone = response.data;
      storeMyInvoices.jsonToInvoicesList(jsonRespone);
      widget.changeLoadingState(false);
    } on DioError catch (e) {
      print(e);
      widget.changeLoadingState(false);
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
          Row(
            children: [
              if (hasDateFilter() && !isErrorInDate)
                ClearFilter(
                  onPressed: () {
                    setState(() {
                      _lastDate.resetState();
                      _firstDate.resetState();
                    });
                    getInvoices();
                  },
                  title: 'التاريخ',
                ),
              SizedBox(width: 10),
              if (hasNameFilter())
                ClearFilter(
                  onPressed: () {
                    setState(() {
                      _custNo.resetState();
                      _cutName.resetState();
                    });
                    getInvoices();
                  },
                  title: 'اسم العميل',
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
        ],
      ),
    );
  }

  void onPressFilter(StateSetter setState) {
    if (hasDateFilter()) {
      DateTime from = DateTime.parse(_firstDate.current!);
      DateTime to = DateTime.parse(_lastDate.current!);

      bool toIsGreaterThanFrom = from.compareTo(to) <= 0;
      if (!toIsGreaterThanFrom) {
        setState(() => isErrorInDate = true);
        Timer(const Duration(seconds: 3), () {
          setState(() => isErrorInDate = false);
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('التاريخ غير صحيح'),
        //     behavior: SnackBarBehavior.floating,
        //   ),
        // );
        return;
      }
      _firstDate.pervious = _firstDate.current;
      _lastDate.pervious = _lastDate.current;
    }
    getInvoices();
    Navigator.pop(context);
  }

  Future<void> showFilterModal(BuildContext context) {
    print(isErrorInDate);

    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
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
                        dropdownValue: _cutName.current,
                        itemsList: customersStore
                            .getCustomersNames(customersStore.customers),
                        text: 'اسم العميل',
                        onChange: (int idx) {
                          if (_cutName.current != null &&
                              _custNo.current != null) {
                            _cutName.pervious = _cutName.current;
                            _custNo.pervious = _custNo.current;
                          }
                          _cutName.current =
                              customersStore.customers[idx].accName;
                          _custNo.current = customersStore.customers[idx].accNo;
                        },
                      ),
                    );
                  }),
                  Divider(),
                  Text(
                    'اختر تاريخ',
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
                                  if (_firstDate.current != null) {
                                    _firstDate.pervious = _firstDate.current;
                                  }

                                  _firstDate.current =
                                      DateFormat("yyyy-MM-dd").format(date!);
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
                      if (_firstDate.current != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            _firstDate.current!,
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
                                  if (_lastDate.current != null) {
                                    _lastDate.pervious = _lastDate.current;
                                  }

                                  _lastDate.current =
                                      DateFormat("yyyy-MM-dd").format(date!);
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
                      if (_lastDate.current != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            _lastDate.current!,
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
                          onPressed: () => onPressFilter(setState),
                          text: 'تصفية النتائج',
                          textColors: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          buttonColors: redColor,
                          onPressed: () {
                            _firstDate.current = _firstDate.pervious;
                            _lastDate.current = _lastDate.pervious;
                            _custNo.current = _custNo.pervious;
                            _cutName.current = _cutName.pervious;
                            Navigator.pop(context);
                          },
                          text: 'إلغاء',
                          textColors: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (isErrorInDate)
                    Positioned(
                      top: 0,
                      child: SnackBar(
                        text:
                            'لا يمكن اختيار تاريخ نهاية المدة أصغر من تاريخ بداية المدة',
                      ),
                    ),
                ],
              );
            });
          },
        );
      },
    );
  }
}

class SnackBar extends StatelessWidget {
  final String text;
  const SnackBar({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width - 40.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Text(text, style: TextStyle(color: Colors.white, fontSize: 14.0)),
      ),
    );
  }
}

class ClearFilter extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const ClearFilter({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      height: 41,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(
              Icons.clear,
              size: 20,
              color: darkColor,
            ),
            Text(title,
                style: TextStyle(
                  fontSize: 14.0,
                  color: darkColor,
                )),
          ],
        ),
      ),
    );
  }
}
