import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/memorizable_state.dart';
import 'package:petrol_naas/widget/snack_bars/bottom_sheet_snack_bar.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class MyInvoicesScreenHeader extends StatefulWidget {
  final void Function(bool state) changeLoadingState;
  const MyInvoicesScreenHeader({
    required this.changeLoadingState,
    Key? key,
  }) : super(key: key);

  @override
  State<MyInvoicesScreenHeader> createState() => _MyInvoicesScreenHeaderState();
}

class _MyInvoicesScreenHeaderState extends State<MyInvoicesScreenHeader> {
  final MemorizableState<String> _firstDate = MemorizableState();
  final MemorizableState<String> _lastDate = MemorizableState();
  final MemorizableState<String> _custNo = MemorizableState();
  final MemorizableState<Customer> _selectedCustomer = MemorizableState();
  bool isErrorInDate = false;
  bool showNameFilterWidget = false;

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
          'http://5.9.215.57/petrolnaas/public/api/invoice?Createduserno=${store.user.userNo}';

      if (hasDateFilter()) {
        url += "&from=${_firstDate.current}&to=${_lastDate.current}";
      }
      if (hasNameFilter()) {
        url += "&Custno=${_custNo.current}";
        showNameFilterWidget = true;
      }

      Response response = await Dio().get(url);
      final storeMyInvoices = context.read<MyInvoices>();
      var jsonRespone = response.data;
      storeMyInvoices.jsonToInvoicesList(jsonRespone);
      widget.changeLoadingState(false);
    } on DioError {
      widget.changeLoadingState(false);
    }
  }

  void onPressClearNameFilter() {
    setState(() {
      _custNo.resetState();
      _selectedCustomer.resetState();
      showNameFilterWidget = false;
    });
    getInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text(
            'جميع الفواتير',
            style: TextStyle(
              color: darkColor,
              fontSize: 20.0,
            ),
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
            if (showNameFilterWidget)
              ClearFilter(
                onPressed: onPressClearNameFilter,
                title: 'اسم العميل',
              ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 33.0,
                color: primaryColor,
              ),
              onPressed: () => showFilterModal(context),
            ),
          ],
        ),
      ],
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
        return;
      }
      _firstDate.pervious = _firstDate.current;
      _lastDate.pervious = _lastDate.current;
    }
    getInvoices();
    Navigator.pop(context);
  }

  void saveCurrentCustomerInPerviousIfExists() {
    if (_selectedCustomer.current != null && _custNo.current != null) {
      _selectedCustomer.pervious = _selectedCustomer.current;
      _custNo.pervious = _custNo.current;
    }
  }

  void saveCurrentCustomer(customer) {
    _selectedCustomer.current = customer;
    _custNo.current = customer.accNo;
  }

  void setCustomerDropDownValue(customer) {
    saveCurrentCustomerInPerviousIfExists();
    setState(() {
      saveCurrentCustomer(customer);
    });
  }

  Future<void> showFilterModal(BuildContext context) {
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
                    return CustomDropdown<Customer>(
                      elements: customersStore.customers,
                      textProperty: 'AccName',
                      label: 'اسم العميل',
                      selectedValue: _selectedCustomer.current,
                      onChanged: setCustomerDropDownValue,
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
                            _selectedCustomer.current =
                                _selectedCustomer.pervious;
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
                      child: BottomSheetSnackBar(
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
