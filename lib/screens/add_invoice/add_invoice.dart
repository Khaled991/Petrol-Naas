import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/models/invoice_header.dart';
import 'package:petrol_naas/screens/add_items_screen/add_items_screen.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/widget/item_add_in_add_invoice.dart';
import 'package:petrol_naas/widget/screen_layout.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/create_invoice.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/invoice_item.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/widget/add_invoice_widget/expand_custom_text_field.dart';
import 'package:petrol_naas/widget/add_invoice_widget/invoice_details.dart';
import 'package:petrol_naas/widget/custom_button.dart';
import 'package:petrol_naas/widget/custom_dropdown.dart';

import '../../constants.dart';
import '../invoice_screen/invoice_screen.dart';

class AddInvoice extends StatefulWidget {
  const AddInvoice({
    Key? key,
  }) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  CreateInvoice createInvoice = CreateInvoice();
  bool isConnected = false;
  late bool isLoading;
  Customer? _selectedCustomer;
  String? invNo;
  double fee = 0.0;

  late TextEditingController qtyController;
  late TextEditingController noteController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    initalizeCustomersAndItemsAndFee();
    qtyController = TextEditingController();
    noteController = TextEditingController();
  }

  void initalizeCustomersAndItemsAndFee() async {
    await getItems();
    await getFee();
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  Future<void> getItems() async {
    try {
      changeLoadingState(true);
      final userStore = context.read<UserStore>();

      Response response = await Dio(dioOptions).get(
          "/items?sellPriceNo=${userStore.user.sellPriceNo}&whno=${userStore.user.whno}");
      var jsonRespone = response.data;
      final itemsStore = context.read<ItemsStore>();
      itemsStore.setItems(prepareItemsList(jsonRespone));

      changeLoadingState(false);
    } on DioError catch (error) {
      // ignore: avoid_print
      print(error);
      changeLoadingState(false);
    }
  }

  List<Item> prepareItemsList(dynamic itemsList) {
    List<Item> items = List<Item>.from(
      itemsList.map(
        (item) => Item.fromJson(item),
      ),
    );
    return items;
  }

  Future<void> getFee() async {
    try {
      Response response = await Dio(dioOptions).get(
        '/fee',
      );
      setState(() {
        final double fee = double.parse(response.data) / 100.0;
        this.fee = fee;
      });
    } on DioError {
      showSnackBar(context,
          'حدث خطأ ما اثناء الحصول علي الضريبة، الرجاء التواصل مع الادارة');
    }
  }

  @override
  void dispose() {
    super.dispose();
    qtyController.dispose();
    noteController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      showBackButton: true,
      title: "إضافة فاتورة",
      child: Container(
        color: Colors.white,
        child: isLoading
            ? _customLoading()
            : ListView(
                controller: scrollController,
                padding: EdgeInsets.all(0),
                children: [
                  _renderPayTypeDropdown(),
                  _renderCustomerDropdown(),
                  _renderNotesTextArea(),
                  _renderItemsList(),
                  _renderAddItemButton(),
                  _renderTotal(),
                  _renderVat(),
                  _renderInoviceTotal(),
                  _renderPrintButton(),
                ],
              ),
      ),
    );
  }

  //-----------------------------------------------------------------

  Widget _customLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
      ),
    );
  }

  //-----------------------------------------------------------------

  CustomDropdown<String> _renderPayTypeDropdown() {
    return CustomDropdown<String>(
      elements: <String>["نقدي كاش", "آجل"],
      label: 'نوع الدفع',
      selectedValue: InoviceHeader.decodePayType(createInvoice.payType),
      onChanged: setPayTypeDropDownValue,
    );
  }

  void setPayTypeDropDownValue(String? payTypeText) {
    final String? payType = InoviceHeader.encodePayType(payTypeText);
    if (payType != null) {
      setState(() {
        createInvoice.payType = payType;
      });
    }
  }

  //-----------------------------------------------------------------

  Widget _renderCustomerDropdown() {
    final customerStore = context.read<CustomerStore>();
    final List<Customer> customers = customerStore.customers;

    final borderStyle = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: primaryColor,
          style: BorderStyle.solid,
          width: 1.2,
        ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "العميل",
              style: TextStyle(
                fontSize: 18.0,
                color: darkColor,
              ),
            ),
          ),
          DropdownFormField<Customer>(
            onChanged: setCustomerDropDownValue,
            findFn: (dynamic str) async => customers,
            filterFn: (dynamic customer, str) =>
                customer.accName.toLowerCase().indexOf(str.toLowerCase()) >= 0,
            dropdownItemFn: (dynamic customer, position, focused,
                    dynamic lastSelectedItem, onTap) =>
                ListTile(
              title: Text(customer.accName),
              subtitle: Text(
                customer?.remainingBalance.toStringAsFixed(2) ?? '',
              ),
              tileColor:
                  focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            ),
            displayItemFn: (dynamic customer) => Text(
              customer?.accName ?? '',
              style: TextStyle(fontSize: 16),
            ),
            // TODO: next line
            // searchTextStyle: TextStyle(fontFamily: "Changa", color: Colors.red),
            decoration: InputDecoration(
              floatingLabelStyle: TextStyle(color: Colors.black54),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: primaryColor,
              focusColor: primaryColor,
              hoverColor: primaryColor,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle,
              focusedErrorBorder: borderStyle,
              border: borderStyle,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              isDense: true,
              suffixIcon: Icon(
                Icons.expand_more,
                color: primaryColor,
                size: 25.0,
              ),
              labelText: "العميل",
              labelStyle: TextStyle(color: Colors.black45),
            ),
            dropdownHeight: 120,
          ),
        ],
      ),
    );
    // Observer(builder: (_) {
    //   final customersStore = context.watch<CustomerStore>();

    //   return CustomDropdown<Customer>(
    //     elements: customersStore.customers,
    //     textProperty: ['AccName', "remainingBalance"],
    //     label: 'العميل',
    //     selectedValue: _selectedCustomer,
    //     onChanged: setCustomerDropDownValue,
    //   );
    // });
  }

  Future<List<Customer>> getData(filter) async {
    final customerStore = context.read<CustomerStore>();

    return customerStore.customers;
  }

  void setCustomerDropDownValue(customer) {
    createInvoice.custno = customer.accNo;
    _selectedCustomer = customer;
  }

  //-----------------------------------------------------------------

  ExpandCustomTextField _renderNotesTextArea() {
    return ExpandCustomTextField(
      controller: noteController,
      label: 'ملاحظات',
    );
  }

  //-----------------------------------------------------------------

  Padding _renderItemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 20.0,
      ),
      child: Observer(builder: (_) {
        final addedItemsToNewInvoiceStore =
            context.watch<AddedItemsToNewInvoiceStore>();

        final List<Item> items = addedItemsToNewInvoiceStore.items;
        final List<int> quantities = addedItemsToNewInvoiceStore.quantities;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأصناف',
              style: TextStyle(
                fontSize: 18.0,
                color: darkColor,
              ),
            ),
            ..._renderAddItemsList(items, quantities)
          ],
        );
      }),
    );
  }

  List<Widget> _renderAddItemsList(List<Item> items, List<int> quantities) {
    return List.generate(
      items.length,
      (index) {
        final item = items[index];
        final qty = quantities[index];
        return ItemAddedInAddInvoice(
          index: index,
          item: item,
          qty: qty,
        );
      },
    ).toList();
  }

  //-----------------------------------------------------------------

  CustomButton _renderAddItemButton() {
    return CustomButton(
      label: 'اضافة صنف',
      buttonColors: greenColor,
      textColors: Colors.white,
      icon: Icons.add,
      onPressed: () => onPressAddItem(<Item>[]),
    );
  }

  void onPressAddItem(List<Item> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddItemScreen(),
      ),
    );
  }

  //-----------------------------------------------------------------

  Observer _renderTotal() {
    return Observer(builder: (_) {
      final addedItemsToNewInvoiceStore =
          context.watch<AddedItemsToNewInvoiceStore>();

      final double totalPrice = addedItemsToNewInvoiceStore.totalPrice;

      return InvoiceDetails(
        title: 'الاجمالي :',
        result: totalPrice.toStringAsFixed(2),
      );
    });
  }

  //-----------------------------------------------------------------

  Observer _renderVat() {
    return Observer(builder: (_) {
      final addedItemsToNewInvoiceStore =
          context.watch<AddedItemsToNewInvoiceStore>();
      final double vat = addedItemsToNewInvoiceStore.vat(fee);

      return InvoiceDetails(
        title: 'الضريبـــة :',
        result: vat.toStringAsFixed(2),
      );
    });
  }

  //-----------------------------------------------------------------

  Observer _renderInoviceTotal() {
    return Observer(builder: (_) {
      final addedItemsToNewInvoiceStore =
          context.watch<AddedItemsToNewInvoiceStore>();
      final total = addedItemsToNewInvoiceStore.invoiceTotal(fee);

      return InvoiceDetails(
        title: 'اجمالي الفاتورة :',
        result: total.toStringAsFixed(2),
      );
    });
  }

  //-----------------------------------------------------------------

  CustomButton _renderPrintButton() {
    return CustomButton(
      label: 'طباعة الفاتورة',
      buttonColors: primaryColor,
      textColors: Colors.white,
      icon: Icons.print,
      onPressed: () => _showPrintAlert(context),
    );
  }

  Future<String?> _showPrintAlert(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'تنبيه!!',
          style: TextStyle(fontSize: 25.0),
        ),
        content: const Text(
          'هل انت متأكد من الاستمرار لأنه لا يمكن التعديل علي الفاتورة مجدداً',
          style: TextStyle(fontSize: 18.0),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              'الغاء',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
              ),
            ),
          ),
          TextButton(
            onPressed: () => onSubmitPrint(setState),
            child: Text(
              'متابعة',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSubmitPrint(StateSetter setState) async {
    fillInRestDataOfInvoice();

    if (!isFieldsFilled()) {
      Navigator.pop(context, 'Cancel');
      showSnackBar(context, 'يجب ملئ جميع البيانات');
      return;
    }

    if (isExceedsCreditLimit() && createInvoice.payType == "3") {
      final remainingAcceptableCredit = _selectedCustomer!.creditLimit! -
          _selectedCustomer!.remainingBalance!;

      Navigator.pop(context, 'Cancel');
      showSnackBar(context,
          'لقد تخطيت الحد الأقصى للائتمان، أقصى مبلغ يمكن الشراء به بالآجل هو: $remainingAcceptableCredit ريال سعودي');
      return;
    }

    await sendInvoiceToApi();

    if (invNo == null) {
      Navigator.pop(context, 'Cancel');
      showSnackBar(context, 'حدث خطأ ما، الرجاء المحاولة مرة اخرى');
      return;
    }
    Navigator.pop(context, 'Cancel');

    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();

    final String payType = InoviceHeader.decodePayType(createInvoice.payType!)!;
    final double vat = addedItemsToNewInvoiceStore.calculateVat(fee);
    final double totalPrice = addedItemsToNewInvoiceStore.calculateTotalPrice();

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          isConnected: isConnected,
          customerName: _selectedCustomer!.accName!,
          customerVATnum: _selectedCustomer!.vaTnum,
          invNo: invNo!,
          payType: payType,
          vat: vat,
          total: totalPrice,
        ),
      ),
    )
        .then((_) {
      resetPerviousData();
    });
  }

  void fillInRestDataOfInvoice() {
    final userStore = context.read<UserStore>();
    if (createInvoice.payType == "1") {
      createInvoice.accno = userStore.user.cashAccno!;
    } else if (createInvoice.payType == "3") {
      createInvoice.accno = _selectedCustomer!.accNo!;
    }
    createInvoice.userno = userStore.user.userNo!;
    createInvoice.salesman = userStore.user.salesman!;
    createInvoice.whno = userStore.user.whno!;
    createInvoice.notes = noteController.text;
    createInvoice.sellPriceNo = userStore.user.sellPriceNo!;
    fillInItemsToViewInAddInviceAndInvoiceToBePrinted();
  }

  void fillInItemsToViewInAddInviceAndInvoiceToBePrinted() {
    clearAddItemsFromCreateInvoiceObj();

    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();

    final int listLength = addedItemsToNewInvoiceStore.items.length;

    for (int i = 0; i < listLength; i++) {
      final item = addedItemsToNewInvoiceStore.items[i];
      final qty = addedItemsToNewInvoiceStore.quantities[i];

      addItemToCreateInvoiceItems(item, qty);
    }
  }

  void clearAddItemsFromCreateInvoiceObj() {
    createInvoice.items = [];
  }

  void addItemToCreateInvoiceItems(Item item, int qty) {
    createInvoice.items ??= [];
    final int freeQty = Item.calcFreeQty(
        qty: qty,
        promotionQtyReq: item.promotionQtyReq!,
        promotionQtyFree: item.promotionQtyFree!);

    createInvoice.items!
        .add(InvoiceItem(itemno: item.itemno!, freeQty: freeQty, qty: qty));
  }

  bool isFieldsFilled() {
    return createInvoice.payType != null &&
        createInvoice.custno != null &&
        !(createInvoice.items == null || createInvoice.items!.isEmpty);
  }

  bool isExceedsCreditLimit() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    final total = addedItemsToNewInvoiceStore.invoiceTotal(fee);

    final remainingAcceptableCredit =
        _selectedCustomer!.creditLimit! - _selectedCustomer!.remainingBalance!;
    return total > remainingAcceptableCredit;
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "/invoice";
      Response res =
          await Dio(dioOptions).post(url, data: createInvoice.toJson());
      final response = res.data;
      invNo = response;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void resetPerviousData() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.reset();
    createInvoice = CreateInvoice();
    _selectedCustomer = null;
    noteController.text = '';
    initalizeCustomersAndItemsAndFee();

    scrollToTop();
  }

  void scrollToTop() {
    scrollController.jumpTo(0);
  }
}
