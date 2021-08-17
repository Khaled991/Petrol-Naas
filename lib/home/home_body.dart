import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/custom_dropdown.dart';
import 'package:petrol_naas/components/custom_input.dart';
import 'package:petrol_naas/components/expand_custom_text_field.dart';
import 'package:petrol_naas/components/invoice_details.dart';
import 'package:petrol_naas/components/show_snack_bar.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/create_invoice.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/invoice_item.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/print_invoice.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';
import 'invoice_screen.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  CreateInvoice createInvoice = CreateInvoice();
  InvoiceItem invoiceItem = InvoiceItem();
  bool connected = false;
  List<ViewInvoiceItem> viewInvoiceItems = [];
  late bool isLoading;
  void changeLoadingState(bool state) => setState(() => isLoading = state);
  List<String> products = [];

  String? _selectedPayType;
  Customer? _selectedCustomer;
  Item? _selectedItem;

  final TextEditingController qtyController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCustomers() async {
    try {
      final String salesman = context.read<UserStore>().user.salesman ?? '';

      changeLoadingState(true);
      Response response = await Dio().get(
        'http://192.168.1.2/petrolnaas/public/api/customer?Salesman=$salesman',
      );
      var jsonRespone = response.data;
      final customersStore = context.read<CustomerStore>();

      customersStore.setCustomers(prepareCustomersList(jsonRespone));
      changeLoadingState(false);
    } on DioError catch (e) {
      print(e);
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
        'http://192.168.1.2/petrolnaas/public/api/items',
      );
      var jsonRespone = response.data;
      final itemsStore = context.read<ItemsStore>();

      itemsStore.setItems(prepareItemsList(jsonRespone));
      products = getProductsNames(itemsStore.items);

      changeLoadingState(false);
    } on DioError catch (e) {
      print(e);
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
    // if(createInvoice.items.firstWhere((InvoiceItem item) => false))
    print(itemIdx);
    final bool alreadyExists = itemIdx != null && itemIdx >= 0;
    if (alreadyExists) {
      setState(() {
        createInvoice.items![itemIdx].qty =
            createInvoice.items![itemIdx].qty! + invoiceItem.qty!;
      });
    } else {
      List<InvoiceItem> mergedOldAndNewItems = (createInvoice.items ?? [])
        ..add(invoiceItem);

      setState(() => createInvoice.items = mergedOldAndNewItems);
    }
  }

  void onPressAddItem() {
    // print(_selectedItem);
    final bool emptyQtyAndProduct =
        qtyController.text == '' && _selectedItem == null;
    if (emptyQtyAndProduct) {
      return ShowSnackBar(context, 'يجب إضافة كمية و اختيار صنف');
    }

    addQtyFromTextFieldToObject();
    addCurrentItemToCreateInvoiceObj();
    calculateNewTotal();

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

  double total = 0.0;

  void calculateNewTotal() {
    if (createInvoice.items == null) return;
    List<InvoiceItem> items = createInvoice.items!;
    double total = 0.0;

    for (int i = 0; i < items.length; i++) {
      InvoiceItem item = items[i];
      double sellPrice = getItemSellPrice(_selectedItem!);
      int qty = item.qty!;
      total += sellPrice * qty.toDouble();

      bool isLastItem = i == items.length - 1;
      if (isLastItem) addItemToViewInvoiceItemsList(_selectedItem!);
    }

    setState(() {
      this.total = total;
    });
  }

  double getItemSellPrice(Item item) {
    double sellPrice = item.sellPrice1 ?? 0.0;
    return sellPrice;
  }

  // Item findItemByItemNo(String itemno) {
  //   List<Item> items = context.read<ItemsStore>().items;
  //   Item item = items.firstWhere(
  //     (Item item) => item.itemno == itemno,
  //   );
  //   return item;
  // }

  void addItemToViewInvoiceItemsList(Item item) {
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
        'http://192.168.1.2/petrolnaas/public/api/fee',
      );
      setState(() {
        final double fee = double.parse(response.data) / 100.0;
        this.fee = fee;
      });
    } on DioError catch (e) {
      print("error getting fee");
    } catch (e) {
      print(e);
    }
  }

  double getVatAmount() {
    double vatAmount = fee * total;
    return vatAmount;
  }

  String invoiceTotal() {
    return (total + getVatAmount()).toStringAsFixed(2);
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
    return createInvoice.accno != null &&
        createInvoice.salesman != null &&
        createInvoice.custno != null &&
        createInvoice.whno != null &&
        createInvoice.accno != null &&
        createInvoice.items != null &&
        total != 0;
  }

  void resetData() {
    setState(() {
      createInvoice = CreateInvoice();
      viewInvoiceItems = [];
      _selectedPayType = null;
      _selectedCustomer = null;
      _selectedItem = null;
      noteController.text = '';
    });
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "http://192.168.1.2/petrolnaas/public/api/invoice";

      Response res = await Dio().post(url, data: createInvoice.toJson());
      final response = res.data;
      print(response);
      // invoice = Invoice.fromJson(jsonResponse);
      resetData();
    } catch (e) {
      print(e);
    }
  }

  void onConfirmPrint() {
    print(createInvoice);
    if (createInvoice.payType == null) {
      Navigator.pop(context, 'Cancel');
      ShowSnackBar(context, 'يجب تحديد نوع الدفع');
      return;
    }

    fillRestDataOfInvoice();

    if (!fieldsIsFilled()) {
      Navigator.pop(context, 'Cancel');
      ShowSnackBar(context, 'يجب ملئ جميع البيانات');
      return;
    }

    //TODO: make connected != true
    if (connected != false) {
      ShowSnackBar(context, 'يرجي التأكد من توصيل الطابعة');
      return;
    }

    sendInvoiceToApi();

    Navigator.pop(context, 'Cancel');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          finalPrice: double.parse(invoiceTotal()),
          fee: getVatAmount(),
          total: total,
          items: viewInvoiceItems,
          customerName: _selectedCustomer!.accName!,
        ),
      ),
    );
  }

  void setPayTypeDropDownValue(payTypeText) {
    _selectedPayType = payTypeText;

    Map<String, String> payTypeDecode = {
      "نقدي كاش": "1",
      "اجل": "3",
    };

    final String payType = payTypeDecode[payTypeText]!;

    setState(() {
      createInvoice.payType = payType;
    });
  }

  void setCustomerDropDownValue(customer) {
    setState(() => createInvoice.custno = customer.accNo);
    _selectedCustomer = customer;
  }

  void setItemDropDownValue(item) {
    setState(() => invoiceItem.itemno = item.itemno);
    _selectedItem = item;
  }

  void onPressDeleteItemFromInvoice(int idx) {
    setState(() {
      createInvoice.items!.removeAt(idx);
      viewInvoiceItems.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
                ),
              )
            : ListView(
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
                    result: total.toStringAsFixed(2),
                  ),
                  InvoiceDetails(
                    title: 'الضريبـــة :',
                    result: getVatAmount().toStringAsFixed(2),
                  ),
                  InvoiceDetails(
                    title: 'اجمالي الفاتورة :',
                    result: invoiceTotal(),
                  ),
                  CustomButton(
                    text: 'طباعة الفاتورة',
                    buttonColors: primaryColor,
                    textColors: Colors.white,
                    icon: Icons.print,
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheet(
                          onClosing: () {},
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'تنبيه!!',
                                        style: TextStyle(fontSize: 25.0),
                                      ),
                                      Text(
                                        'هل انت متأكد من الاستمرار لأنه لا يمكن التعديل علي الفاتورة مجدداً',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Divider(
                                    height: 2.0,
                                    color: primaryColor,
                                  ),
                                  PrintInvoice(connected),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          buttonColors: greenColor,
                                          onPressed: onConfirmPrint,
                                          text: 'موافق',
                                          textColors: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          buttonColors: redColor,
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          text: 'إلغاء',
                                          textColors: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

//===========================================Invoice Items Table Details===========================================

class InvoiceItemsTable extends StatelessWidget {
  List<ViewInvoiceItem> items;
  void Function(int) onPressDeleteItemFromInvoice;

  InvoiceItemsTable(
      {Key? key,
      required this.items,
      required this.onPressDeleteItemFromInvoice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: primaryColor, width: 2.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: DataTable(
              columns: [
                DataColumn(label: Text('')),
                DataColumn(label: Text('الرقم')),
                DataColumn(label: Text('اسم الصنف')),
                DataColumn(label: Text('الكمية')),
                DataColumn(label: Text('سعر')),
                DataColumn(label: Text('الاجمالي')),
                DataColumn(label: Text('القطع المجانية')),
              ],
              rows: List.generate(
                items.length,
                (int index) {
                  final ViewInvoiceItem item = items[index];
                  return DataRow(
                    cells: [
                      DataCell(TextButton(
                        onPressed: () => onPressDeleteItemFromInvoice(index),
                        child: Icon(
                          Icons.clear,
                          size: 25.0,
                          color: redColor,
                        ),
                      )),
                      DataCell(Text(item.itemno!)),
                      DataCell(Text(item.itemDesc!)),
                      DataCell(Text(item.qty.toString())),
                      DataCell(Text(item.sellPrice.toString())),
                      DataCell(Text((item.sellPrice! * item.qty!).toString())),
                      DataCell(Text(item.freeItemsQty.toString())),
                    ],
                  );
                },
              ),
              // widget.items
              //     .map(
              //       (ViewInvoiceItem item) =>
              //     )
              //     .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
