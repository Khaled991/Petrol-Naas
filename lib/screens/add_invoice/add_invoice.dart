import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/models/invoice_header.dart';
import 'package:petrol_naas/screens/add_items_screen/add_items_screen.dart';
import 'package:petrol_naas/widget/adjustable_qty.dart';
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

class _AddInvoiceState extends State<AddInvoice> {
  CreateInvoice createInvoice = CreateInvoice();
  InvoiceItem invoiceItem = InvoiceItem();
  bool isConnected = false;
  List<ViewInvoiceItem> viewInvoiceItems = [];
  late bool isLoading;
  void changeLoadingState(bool state) => setState(() => isLoading = state);
  List<String> items = [];
  String? _selectedPayType;
  Customer? _selectedCustomer;
  String? invNo;

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
      items = getItemsNames(itemsStore.items);

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

  void onPressAddItem(List<Item> items) {
    // Navigator.of(context)
    //     .push(
    //       MaterialPageRoute(
    //         builder: (BuildContext context) {
    //           return Dialog(child: AddItemScreen());
    //         },
    //         fullscreenDialog: true,
    //       ),
    //     )
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AddItemScreen(),
      ),
    );
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

  double getItemSellPrice(Item item) {
    double sellPrice = item.sellPrice ?? 0.0;
    return sellPrice;
  }

  void addQtyFromTextFieldToObject() {
    invoiceItem.qty = int.parse(qtyController.text);
  }

  List<String> getItemsNames(List<Item> items) {
    return items.map((Item item) => item.itemDesc ?? "").toList();
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

      addItemToViewInvoiceItems(item, qty);
      addItemToCreateInvoiceItems(item, qty);
    }
  }

  void addItemToViewInvoiceItems(Item item, int qty) {
    viewInvoiceItems.add(ViewInvoiceItem(
      itemno: item.itemno!,
      itemDesc: item.itemDesc!,
      qty: qty,
      freeItemsQty: Item.calcFreeQty(
        qty: qty,
        promotionQtyFree: item.promotionQtyFree!,
        promotionQtyReq: item.promotionQtyReq!,
      ),
      sellPrice: item.sellPrice!,
    ));
  }

  void addItemToCreateInvoiceItems(Item item, int qty) {
    createInvoice.items ??= [];

    createInvoice.items!.add(
        InvoiceItem(itemno: item.itemno!, price: item.sellPrice, qty: qty));
  }

  InvoiceItem addedItemsToNewInvoiceToInvoiceItem(Item item, int qty) {
    return InvoiceItem(itemno: item.itemno, qty: qty, price: item.sellPrice);
  }

  bool isFieldsFilled() {
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
      noteController.text = '';
      scrollToTop();
    });
  }

  void changePrinterConnection(bool state) {
    setState(() {
      isConnected = state;
    });
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "http://5.9.215.57:8080/petrolnaas/public/api/invoice";

      Response res = await Dio().post(url, data: createInvoice.toJson());
      final response = res.data;
      invNo = response;
    } catch (e) {
      // print(e);
    }
  }

  Future<void> onSubmitPrint(StateSetter setState) async {
    fillRestDataOfInvoice();

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

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          isConnected: isConnected,
          items: viewInvoiceItems,
          customerName: _selectedCustomer!.accName!,
          customerVATnum: _selectedCustomer!.vatNum,
          invNo: invNo!,
          payType: InoviceHeader.decodePayType(createInvoice.payType!)!,
          fee: addedItemsToNewInvoiceStore.calculateVat(fee),
          total: addedItemsToNewInvoiceStore.calculateTotalPrice(),
        ),
      ),
    )
        .then((_) {
      final addedItemsToNewInvoiceStore =
          context.read<AddedItemsToNewInvoiceStore>();
      addedItemsToNewInvoiceStore.reset();

      asyncMethod();
    });

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
      invoiceItem.price = item.sellPrice;
    });
  }

  void onPressDeleteItemFromInvoice(int idx) {
    setState(() {
      createInvoice.items!.removeAt(idx);
      viewInvoiceItems.removeAt(idx);
    });
  }

  Widget _customLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
      ),
    );
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
                // Observer(builder: (_) {
                //   final itemsStore = context.watch<ItemsStore>();

                //   return CustomDropdown<Item>(
                //     elements: itemsStore.items,
                //     textProperty: ['itemno', 'itemDesc'],
                //     label: 'الصنف',
                //     selectedValue: _selectedItem,
                //     onChanged: setItemDropDownValue,
                //   );
                // }),
                // CustomInput(
                //   hintText: 'الكمية',
                //   keyboardType: TextInputType.number,
                //   type: 'yellow',
                //   controller: qtyController,
                // ),
                // InvoiceItemsTable(
                //   items: viewInvoiceItems,
                //   onPressDeleteItemFromInvoice: onPressDeleteItemFromInvoice,
                // ),
                ExpandCustomTextField(
                  controller: noteController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 20.0,
                  ),
                  child: Observer(builder: (_) {
                    final addedItemsToNewInvoiceStore =
                        context.watch<AddedItemsToNewInvoiceStore>();

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
                        ...List.generate(
                          addedItemsToNewInvoiceStore.items.length,
                          (index) {
                            final item =
                                addedItemsToNewInvoiceStore.items[index];
                            final qty =
                                addedItemsToNewInvoiceStore.quantities[index];
                            return ItemAddedInAddInvoice(
                              index: index,
                              item: item,
                              qty: qty,
                            );
                          },
                        ).toList()
                      ],
                    );
                  }),
                ),
                CustomButton(
                  text: 'اضافة صنف',
                  buttonColors: greenColor,
                  textColors: Colors.white,
                  icon: Icons.add,
                  onPressed: () => onPressAddItem(<Item>[]),
                ),

                Observer(builder: (_) {
                  final addedItemsToNewInvoiceStore =
                      context.watch<AddedItemsToNewInvoiceStore>();

                  return InvoiceDetails(
                    title: 'الاجمالي :',
                    result: addedItemsToNewInvoiceStore.totalPrice
                        .toStringAsFixed(2),
                  );
                }),
                Observer(builder: (_) {
                  final addedItemsToNewInvoiceStore =
                      context.watch<AddedItemsToNewInvoiceStore>();

                  return InvoiceDetails(
                    title: 'الضريبـــة :',
                    result:
                        addedItemsToNewInvoiceStore.vat(fee).toStringAsFixed(2),
                  );
                }),
                Observer(builder: (_) {
                  final addedItemsToNewInvoiceStore =
                      context.watch<AddedItemsToNewInvoiceStore>();

                  return InvoiceDetails(
                    title: 'اجمالي الفاتورة :',
                    result: addedItemsToNewInvoiceStore
                        .invoiceTotal(fee)
                        .toStringAsFixed(2),
                  );
                }),
                CustomButton(
                  text: 'طباعة الفاتورة',
                  buttonColors: primaryColor,
                  textColors: Colors.white,
                  icon: Icons.print,
                  onPressed: () => _showPrintAlert(context),
                ),
              ],
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
}

class ItemAddedInAddInvoice extends StatefulWidget {
  final Item item;
  int qty;
  final int index;

  ItemAddedInAddInvoice({
    Key? key,
    required this.item,
    this.qty = 0,
    required this.index,
  }) : super(key: key);

  @override
  _ItemAddedInAddInvoiceState createState() => _ItemAddedInAddInvoiceState();
}

class _ItemAddedInAddInvoiceState extends State<ItemAddedInAddInvoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(right: 15.0, top: 5.0, bottom: 5.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.itemDesc!,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPressRemoveItem,
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Text("رقم الصنف : ${widget.item.itemno!}"),
              Text("الكمية المتاحة : ${widget.item.availableQty!}"),
              Text("${widget.item.sellPrice!} : السعر"),
              Text(
                  "${calculateTotalPrice(widget.item.sellPrice!, widget.qty)} : الاجمالي"),
              if (widget.item.promotionQtyFree != 0 &&
                  widget.item.promotionQtyReq != 0)
                Text(
                  "الكمية المجانية : ${Item.calcFreeQty(
                    qty: widget.qty,
                    promotionQtyFree: widget.item.promotionQtyFree!,
                    promotionQtyReq: widget.item.promotionQtyReq!,
                  )}",
                ),
            ],
          ),
          Positioned(
            bottom: 5.0,
            left: 15.0,
            child: AdjustableQuantity(
              setQty: setQty,
              qty: widget.qty,
              maxQty: widget.item.availableQty!,
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalPrice(double price, int qty) => price * qty;

  void setQty(int newQty) {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.editQuantityByIndex(newQty, widget.index);

    setState(() {
      widget.qty = newQty;
    });
  }

  void onPressRemoveItem() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.removeItemByIndex(widget.index);
  }
}
