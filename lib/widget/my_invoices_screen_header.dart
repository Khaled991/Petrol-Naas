import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/my_invoice/my_invoices.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/filters.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/memorizable_state.dart';
import 'package:petrol_naas/widget/snack_bars/bottom_sheet_snack_bar.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import '../constants.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class MyInvoicesScreenHeader extends StatefulWidget {
  final void Function(bool state) changeLoadingState;
  final void Function() getInvoices;
  final Filters filters;
  final void Function() setFirstPage;
  final Function() moveScrollToTop;

  const MyInvoicesScreenHeader({
    required this.changeLoadingState,
    required this.filters,
    required this.getInvoices,
    required this.setFirstPage,
    required this.moveScrollToTop,
    Key? key,
  }) : super(key: key);

  @override
  State<MyInvoicesScreenHeader> createState() => _MyInvoicesScreenHeaderState();
}

class _MyInvoicesScreenHeaderState extends State<MyInvoicesScreenHeader> {
  final MemorizableState<Customer> _selectedCustomer = MemorizableState();
  bool thereIsError = false;
  bool showNameFilterWidget = false;
  String _errorMessage = "";

  List<Invoice> prepareInvoiceList(dynamic invoiceList) {
    List<Invoice> invoices = List<Invoice>.from(
      invoiceList.map(
        (invoice) => Invoice.fromJson(invoice),
      ),
    );
    return invoices;
  }

  void onPressClearNameFilter() {
    widget.changeLoadingState(true);
    final invoicesStore = context.read<MyInvoices>();
    invoicesStore.resetList();

    setState(() {
      widget.setFirstPage();
      widget.filters.resetCustNoFilter();
      _selectedCustomer.resetState();
      showNameFilterWidget = false;
    });
    widget.getInvoices();
  }

  void onPressClearDateFilter() {
    widget.changeLoadingState(true);
    final invoicesStore = context.read<MyInvoices>();
    invoicesStore.resetList();

    setState(() {
      widget.setFirstPage();
      widget.filters.lastDate.resetState();
      widget.filters.firstDate.resetState();
    });
    widget.getInvoices();
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
            if (widget.filters.hasDateFilter() && !thereIsError)
              ClearFilter(
                onPressed: onPressClearDateFilter,
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

  void showError(message, StateSetter setState) {
    enableError(setState);
    _errorMessage = message;
    disableError(setState);
  }

  void enableError(StateSetter setState) {
    setState(() {
      thereIsError = true;
    });
  }

  void disableError(StateSetter setState) {
    Timer(const Duration(seconds: 3), () {
      setState(() => thereIsError = false);
    });
  }

  void onPressFilter(StateSetter setState) {
    if (!(widget.filters.hasCustomerFilter() ||
        widget.filters.hasDateFilter())) {
      return showError("من فضلك اختر تصفية", setState);
    }

    widget.setFirstPage();

    final invoicesStore = context.read<MyInvoices>();
    invoicesStore.resetList();

    if (widget.filters.hasCustomerFilter()) {
      showNameFilterWidget = true;
    }
    if (widget.filters.hasDateFilter()) {
      DateTime from = DateTime.parse(widget.filters.firstDate.current!);
      DateTime to = DateTime.parse(widget.filters.lastDate.current!);

      bool toIsGreaterThanFrom = from.compareTo(to) <= 0;
      if (!toIsGreaterThanFrom) {
        return showError(
          'لا يمكن اختيار تاريخ نهاية المدة أصغر من تاريخ بداية المدة',
          setState,
        );
      }
    }

    widget.changeLoadingState(true);

    widget.filters.confirmFilters();

    widget.getInvoices();
    Navigator.pop(context);
    widget.moveScrollToTop();
  }

  void saveCurrentCustomerInPerviousIfExists() {
    if (_selectedCustomer.current != null &&
        widget.filters.custNo.current != null) {
      _selectedCustomer.pervious = _selectedCustomer.current;
      widget.filters.confirmCustomerFilter();
    }
  }

  void saveCurrentCustomer(customer) {
    _selectedCustomer.current = customer;
    widget.filters.custNo.current = customer.accNo;
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
                                  if (widget.filters.firstDate.current !=
                                      null) {
                                    widget.filters.confirmDateFilter();
                                  }

                                  widget.filters.firstDate.current =
                                      DateFormat("yyyy-MM-dd").format(date!);
                                });
                              },
                            );
                          },
                          buttonColors: primaryColor,
                          label: 'من',
                          icon: Icons.date_range_outlined,
                          textColors: Colors.white,
                        ),
                      ),
                      if (widget.filters.firstDate.current != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            widget.filters.firstDate.current!,
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
                                  if (widget.filters.lastDate.current != null) {
                                    widget.filters.lastDate
                                        .assignCurrentToPervious();
                                  }

                                  widget.filters.lastDate.current =
                                      DateFormat("yyyy-MM-dd").format(date!);
                                });
                              },
                            );
                          },
                          buttonColors: primaryColor,
                          label: 'إلي',
                          icon: Icons.date_range_outlined,
                          textColors: Colors.white,
                        ),
                      ),
                      if (widget.filters.lastDate.current != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            widget.filters.lastDate.current!,
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
                          label: 'تصفية النتائج',
                          textColors: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          buttonColors: redColor,
                          onPressed: () {
                            widget.filters.cancelFilters();
                            _selectedCustomer.current =
                                _selectedCustomer.pervious;
                            Navigator.pop(context);
                          },
                          label: 'إلغاء',
                          textColors: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (thereIsError)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 50.0, maxWidth: double.infinity),
                      child: BottomSheetSnackBar(
                        text: _errorMessage,
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
