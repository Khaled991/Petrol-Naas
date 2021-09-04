import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/models/invoice_header.dart';
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
import 'package:petrol_naas/widget/add_invoice_widget/invoice_item_table.dart';
import 'package:petrol_naas/widget/custom_button.dart';
import 'package:petrol_naas/widget/custom_dropdown.dart';
import 'package:petrol_naas/widget/custom_input.dart';
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
//         'http://5.9.215.57/petrolnaas/public/api/fee',
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
class _AddInvoiceState extends State<AddInvoice> {
  CreateInvoice createInvoice = CreateInvoice();
  InvoiceItem invoiceItem = InvoiceItem();
  bool isConnected = false;
  List<ViewInvoiceItem> viewInvoiceItems = [];
  late bool isLoading;
  void changeLoadingState(bool state) => setState(() => isLoading = state);
  List<String> products = [];
  String? _selectedPayType;
  Customer? _selectedCustomer;
  Item? _selectedItem;
  String? invNo;
  double _total = 0.0;
  double _vat = 0.0;
  double _totalPlusVat = 0.0;

  late TextEditingController qtyController;
  late TextEditingController noteController;
  ScrollController scrollController = ScrollController();

  double fee = 0.0;
  void asyncMethod() async {
    await getCustomers();
    await getItems();
    await getFee();
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    asyncMethod();
    qtyController = TextEditingController();
    noteController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> getCustomers() async {
    try {
      final String salesman = context.read<UserStore>().user.salesman ?? '';

      changeLoadingState(true);
      Response response = await Dio().get(
        'http://5.9.215.57/petrolnaas/public/api/customer?Salesman=$salesman',
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
      Response response = await Dio().get(
        'http://5.9.215.57/petrolnaas/public/api/items',
      );
      var jsonRespone = response.data;
      final itemsStore = context.read<ItemsStore>();

      itemsStore.setItems(prepareItemsList(jsonRespone));
      products = getProductsNames(itemsStore.items);

      changeLoadingState(false);
    } on DioError {
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

  void addCurrentItemToCreateInvoiceObj() {
    int? itemIdx = createInvoice.items
        ?.indexWhere((InvoiceItem item) => item.itemno == invoiceItem.itemno);
    final bool alreadyExists = itemIdx != null && itemIdx >= 0;

    if (alreadyExists) {
      setState(() {
        int newQty = createInvoice.items![itemIdx].qty! + invoiceItem.qty!;
        createInvoice.items![itemIdx].qty = newQty;
        invoiceItem.qty = newQty;
      });
    } else {
      List<InvoiceItem> mergedOldAndNewItems = (createInvoice.items ?? [])
        ..add(invoiceItem.copyWith());

      setState(() => createInvoice.items = mergedOldAndNewItems);
    }
  }

  void onPressAddItem() {
    final bool emptyQtyOrProduct =
        qtyController.text == '' || _selectedItem == null;
    if (emptyQtyOrProduct) {
      return ShowSnackBar(context, 'يجب إضافة كمية و اختيار صنف');
    }

    addQtyFromTextFieldToObject();
    addCurrentItemToCreateInvoiceObj();
    calculateTotalAndVatAndFinalPrice();
    addItemToViewInvoiceItemsList(_selectedItem!);

    qtyController.text = '';
    setState(() {
      _selectedItem = null;
    });
    FocusScope.of(context).requestFocus(FocusNode()); //dismiss keyboard
  }

  void onChangeCustomer(Customer customer) {
    _selectedCustomer = customer;
    createInvoice.custno = customer.accNo!;
  }

  double calculateNewTotal() {
    if (createInvoice.items == null) return 0.0;
    List<InvoiceItem> items = createInvoice.items!;
    double total = 0.0;
    for (int i = 0; i < items.length; i++) {
      InvoiceItem item = items[i];
      double sellPrice = item.price!;
      int qty = item.qty!;
      total += sellPrice * qty.toDouble();
    }

    return total;
  }

  double getVat() {
    double vatAmount = fee * _total;
    return vatAmount;
  }

  double getItemSellPrice(Item item) {
    double sellPrice = item.sellPrice1 ?? 0.0;
    return sellPrice;
  }

  void addItemToViewInvoiceItemsList(Item item) {
    int? itemIdx = viewInvoiceItems.indexWhere(
        (ViewInvoiceItem viewInvoiceItem) =>
            viewInvoiceItem.itemno == item.itemno);
    final bool alreadyExists = itemIdx >= 0;

    if (alreadyExists) {
      setState(() {
        viewInvoiceItems[itemIdx].qty = invoiceItem.qty!;
        viewInvoiceItems[itemIdx].freeItemsQty = Item.calcFreeQty(
          qty: invoiceItem.qty!,
          promotionQtyFree: item.promotionQtyFree!,
          promotionQtyReq: item.promotionQtyReq!,
        );
      });
    } else {
      setState(() {
        viewInvoiceItems.add(ViewInvoiceItem(
          itemno: item.itemno!,
          itemDesc: item.itemDesc!,
          qty: int.parse(qtyController.text),
          freeItemsQty: Item.calcFreeQty(
            qty: invoiceItem.qty!,
            promotionQtyFree: item.promotionQtyFree!,
            promotionQtyReq: item.promotionQtyReq!,
          ),
          sellPrice: item.sellPrice1!,
        ));
      });
    }
  }

  void addQtyFromTextFieldToObject() {
    invoiceItem.qty = int.parse(qtyController.text);
  }

  List<String> getProductsNames(List<Item> items) {
    return items.map((Item item) => item.itemDesc ?? "").toList();
  }

  Future<void> getFee() async {
    try {
      Response response = await Dio().get(
        'http://5.9.215.57/petrolnaas/public/api/fee',
      );
      setState(() {
        final double fee = double.parse(response.data) / 100.0;
        this.fee = fee;
      });
    } on DioError {
      ShowSnackBar(context,
          'حدث خطأ ما اثناء الحصول علي الضريبة، الرجاء التواصل مع الادارة');
    }
  }

  void calculateTotalAndVatAndFinalPrice() {
    setState(() {
      _total = calculateNewTotal();
      _vat = getVat();
      _totalPlusVat = _total + _vat;
    });
  }

  void fillRestDataOfInvoice() {
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
  }

  bool fieldsIsFilled() {
    return createInvoice.payType != null &&
        createInvoice.custno != null &&
        !(createInvoice.items == null || createInvoice.items!.isEmpty);
  }

  void scrollToTop() {
    scrollController.jumpTo(0);
  }

  void resetData() {
    setState(() {
      createInvoice = CreateInvoice();
      viewInvoiceItems = [];
      _selectedPayType = null;
      _selectedCustomer = null;
      _selectedItem = null;
      noteController.text = '';
      scrollToTop();
      calculateTotalAndVatAndFinalPrice();
    });
  }

  void changePrinterConnection(bool state) {
    setState(() {
      isConnected = state;
    });
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "http://5.9.215.57/petrolnaas/public/api/invoice";

      Response res = await Dio().post(url, data: createInvoice.toJson());
      final response = res.data;
      invNo = response;
    } catch (e) {
      // print(e);
    }
  }

  Future<void> onConfirmPrint(setState) async {
    if (!fieldsIsFilled()) {
      Navigator.pop(context, 'Cancel');
      ShowSnackBar(context, 'يجب ملئ جميع البيانات');
      return;
    }

    fillRestDataOfInvoice();

    await sendInvoiceToApi();

    if (invNo == null) {
      Navigator.pop(context, 'Cancel');
      ShowSnackBar(context, 'حدث خطأ ما، الرجاء المحاولة مرة اخرى');
      return;
    }

    Navigator.pop(context, 'Cancel');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          isConnected: isConnected,
          finalPrice: _total,
          fee: getVat(),
          total: _total,
          items: viewInvoiceItems,
          customerName: _selectedCustomer!.accName!,
          invNo: invNo!,
          payType: InoviceHeader.decodePayType(createInvoice.payType!)!,
        ),
      ),
    );

    Timer(const Duration(seconds: 4), () {
      resetData();
      FocusScope.of(context).requestFocus(FocusNode()); //dismiss keyboard
    });
  }

  void setPayTypeDropDownValue(String? payTypeText) {
    final String? payType = InoviceHeader.encodePayType(payTypeText);
    if (payType != null) {
      setState(() {
        createInvoice.payType = payType;
      });
    }
  }

  void setCustomerDropDownValue(customer) {
    setState(() => createInvoice.custno = customer.accNo);
    _selectedCustomer = customer;
  }

  void setItemDropDownValue(item) {
    setState(() {
      invoiceItem.itemno = item.itemno;
      invoiceItem.price = item.sellPrice1;
    });
    _selectedItem = item;
  }

  void onPressDeleteItemFromInvoice(int idx) {
    setState(() {
      createInvoice.items!.removeAt(idx);
      viewInvoiceItems.removeAt(idx);
    });
    calculateTotalAndVatAndFinalPrice();
  }

  Widget _customloading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: isLoading
            ? _customloading()
            : ListView(
                controller: scrollController,
                padding: EdgeInsets.all(0),
                children: [
                  CustomDropdown<String>(
                    elements: <String>["نقدي كاش", "آجل"],
                    label: 'نوع الدفع',
                    selectedValue: _selectedPayType,
                    onChanged: setPayTypeDropDownValue,
                  ),
                  Observer(builder: (_) {
                    final customersStore = context.watch<CustomerStore>();

                    return CustomDropdown<Customer>(
                      elements: customersStore.customers,
                      textProperty: 'AccName',
                      label: 'العميل',
                      selectedValue: _selectedCustomer,
                      onChanged: setCustomerDropDownValue,
                    );
                  }),
                  Observer(builder: (_) {
                    final itemsStore = context.watch<ItemsStore>();

                    return CustomDropdown<Item>(
                      elements: itemsStore.items,
                      textProperty: 'itemDesc',
                      label: 'الصنف',
                      selectedValue: _selectedItem,
                      onChanged: setItemDropDownValue,
                    );
                  }),
                  CustomInput(
                    hintText: 'الكمية',
                    keyboardType: TextInputType.number,
                    type: 'yellow',
                    controller: qtyController,
                  ),
                  CustomButton(
                    text: 'اضافة صنف',
                    buttonColors: greenColor,
                    textColors: Colors.white,
                    icon: Icons.add,
                    onPressed: onPressAddItem,
                  ),
                  InvoiceItemsTable(
                    items: viewInvoiceItems,
                    onPressDeleteItemFromInvoice: onPressDeleteItemFromInvoice,
                  ),
                  ExpandCustomTextField(
                    controller: noteController,
                  ),
                  InvoiceDetails(
                    title: 'الاجمالي :',
                    result: _total.toStringAsFixed(2),
                  ),
                  InvoiceDetails(
                    title: 'الضريبـــة :',
                    result: _vat.toStringAsFixed(2),
                  ),
                  InvoiceDetails(
                    title: 'اجمالي الفاتورة :',
                    result: _totalPlusVat.toStringAsFixed(2),
                  ),
                  CustomButton(
                    text: 'طباعة الفاتورة',
                    buttonColors: primaryColor,
                    textColors: Colors.white,
                    icon: Icons.print,
                    onPressed: () => _showPrintAlert(context),
                  ),
                ],
              ),
      ),
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
            child: Text('الغاء',
                style: TextStyle(color: primaryColor, fontSize: 16.0)),
          ),
          TextButton(
            onPressed: () => onConfirmPrint(setState),
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
}
