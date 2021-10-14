import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/models/invoice_header.dart';
import 'package:petrol_naas/screens/add_items_screen/add_items_screen.dart';
import 'package:petrol_naas/widget/adjustable_qty.dart';
import 'package:petrol_naas/widget/item_add_in_add_invoice.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/create_invoice.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/invoice_item.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/add_invoice_widget/expand_custom_text_field.dart';
import 'package:petrol_naas/widget/add_invoice_widget/invoice_details.dart';
import 'package:petrol_naas/widget/custom_button.dart';
import 'package:petrol_naas/widget/custom_dropdown.dart';
import 'package:petrol_naas/widget/snack_bars/show_snack_bar.dart';

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
    await getCustomers();
    await getItems();
    await getFee();
  }

  Future<void> getCustomers() async {
    try {
      final String salesman = context.read<UserStore>().user.salesman ?? '';

      changeLoadingState(true);
      Response response = await Dio().get(
        'http://5.9.215.57:8080/petrolnaas/public/api/customer?Salesman=$salesman',
      );
      if (!mounted) return;
      var jsonRespone = response.data;
      final customersStore = context.read<CustomerStore>();

      customersStore.setCustomers(prepareCustomersList(jsonRespone));
      changeLoadingState(false);
    } on DioError {
      changeLoadingState(false);
    }
  }

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  List<Customer> prepareCustomersList(dynamic customersList) {
    List<Customer> customers = List<Customer>.from(
      customersList.map(
        (customer) => Customer.fromJson(customer),
      ),
    );
    return customers;
  }

  Future<void> getItems() async {
    try {
      changeLoadingState(true);
      final userStore = context.read<UserStore>();

      Response response = await Dio().get(
          "http://5.9.215.57:8080/petrolnaas/public/api/items?sellPriceNo=${userStore.user.sellPriceNo}");
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
      Response response = await Dio().get(
        'http://5.9.215.57:8080/petrolnaas/public/api/fee',
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
    return Container(
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

  Observer _renderCustomerDropdown() {
    return Observer(builder: (_) {
      final customersStore = context.watch<CustomerStore>();

      return CustomDropdown<Customer>(
        elements: customersStore.customers,
        textProperty: 'AccName',
        label: 'العميل',
        selectedValue: _selectedCustomer,
        onChanged: setCustomerDropDownValue,
      );
    });
  }

  void setCustomerDropDownValue(customer) {
    setState(() => createInvoice.custno = customer.accNo);
    _selectedCustomer = customer;
  }

  //-----------------------------------------------------------------

  ExpandCustomTextField _renderNotesTextArea() {
    return ExpandCustomTextField(
      controller: noteController,
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
      text: 'اضافة صنف',
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
      text: 'طباعة الفاتورة',
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
          customerVATnum: _selectedCustomer!.vatNum,
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
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();

    final int listLength = addedItemsToNewInvoiceStore.items.length;

    for (int i = 0; i < listLength; i++) {
      final item = addedItemsToNewInvoiceStore.items[i];
      final qty = addedItemsToNewInvoiceStore.quantities[i];

      addItemToCreateInvoiceItems(item, qty);
    }
    removeRepeatedItemsIfExists(createInvoice.items ?? []);
  }

  void addItemToCreateInvoiceItems(Item item, int qty) {
    createInvoice.items ??= [];

    createInvoice.items!.add(
        InvoiceItem(itemno: item.itemno!, price: item.sellPrice, qty: qty));
  }

  void removeRepeatedItemsIfExists(List<dynamic> items) {
    items = items.toSet().toList();
  }

  bool isFieldsFilled() {
    return createInvoice.payType != null &&
        createInvoice.custno != null &&
        !(createInvoice.items == null || createInvoice.items!.isEmpty);
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "http://5.9.215.57:8080/petrolnaas/public/api/invoice";
      Response res = await Dio().post(url, data: createInvoice.toJson());
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


// class Acsacsav {
//   String? invNo;
//   double total = 0.0;
//   double vat = 0.0;
//   double totalPlusVat = 0.0;
//   double? fee;
//   late List<InvoiceItem> items;

//   Acsacsav(InvoiceItem item) {
//     getFee();
//     addItem(item);
//     calculateTotalAndVatAndFinalPrice();
//   }

//   Future<void> getFee() async {
//     try {
//       Response response = await Dio().get(
//         'http://5.9.215.57:8080/petrolnaas/public/api/fee',
//       );
//       final double fee = double.parse(response.data) / 100.0;
//       this.fee = fee;
//     } on DioError {
//       print('حدث خطأ ما اثناء الحصول علي الضريبة، الرجاء التواصل مع الادارة');
//     }
//   }

//   addItem(InvoiceItem item) {
//     items.add(item);
//   }

//   removeItem(InvoiceItem item) {
//     items.remove(item);
//   }

//   void calculateTotalAndVatAndFinalPrice() {
//     total = calculateNewTotal();
//     vat = getVat();
//     totalPlusVat = total + vat;
//   }

//   double calculateNewTotal() {
//     double total = 0.0;
//     for (int i = 0; i < items.length; i++) {
//       InvoiceItem item = items[i];
//       double sellPrice = item.price!;
//       int qty = item.qty!;
//       total += sellPrice * qty.toDouble();
//     }

//     return total;
//   }

//   double getVat() {
//     double vatAmount = fee! * total;
//     return vatAmount;
//   }
// }
