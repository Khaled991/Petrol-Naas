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
  Item item = Item();
  List<ViewInvoiceItem> viewInvoiceItems = [];
  late bool isLoading;
  void changeLoadingState(bool state) => setState(() => isLoading = state);
  List<String> products = [];
  Item selectedProduct = Item();

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

  void onPressAddItem() {
    print(selectedProduct);
    if (qtyController.text == '' && selectedProduct == null) {
      ShowSnackBar(context, 'يجب إضافة كمية و اختيار صنف');

      return;
    }

    handleQty();

    List<InvoiceItem> mergedOldAndNewItems = createInvoice.items ?? [];
    mergedOldAndNewItems.add(invoiceItem);

    setState(
      () {
        createInvoice = createInvoice.copyWith(items: mergedOldAndNewItems);
      },
    );
    handleTotalSaleHeader();
    qtyController.text = '';
    setState(() {
      selectedProduct = Item();
    });
    FocusScope.of(context).requestFocus(FocusNode()); //dismiss keyboard
  }

  void onChangePayType(int payTypeIdx) {
    Map<int, int> payTypeDecode = {
      0: 1,
      1: 3,
    };

    final int payType = payTypeDecode[payTypeIdx]!;

    setState(() {
      createInvoice = createInvoice.copyWith(payType: payType);
    });
  }

  Customer selectedCustomer = Customer();

  void onChangeCustomer(Customer customer) {
    selectedCustomer = customer;
    createInvoice = createInvoice.copyWith(custno: customer.accNo!);
  }

  double total = 0.0;

  void handleTotalSaleHeader() {
    if (createInvoice.items == null) return;
    List<InvoiceItem> items = createInvoice.items!;
    double total = 0;

    for (int i = 0; i < items.length; i++) {
      InvoiceItem item = items[i];
      // Item itemFromAvailableItems = findItemByItemNo(item.itemno!);
      double sellPrice = getItemSellPrice(selectedProduct);
      int qty = item.qty!;
      total += sellPrice * qty.toDouble();

      bool isLastItem = i == items.length - 1;
      if (isLastItem) addItemToViewInvoiceItemsList(selectedProduct);
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

  void onChangeItem(int idx) {
    final itemsStore = context.read<ItemsStore>();
    Item item = itemsStore.items[idx];
    setState(() {
      invoiceItem = invoiceItem.copyWith(itemno: item.itemno);
      selectedProduct = item;
    });
  }

  void handleQty() {
    invoiceItem = invoiceItem.copyWith(qty: int.parse(qtyController.text));
  }

  void changeNotes() {
    createInvoice = createInvoice.copyWith(notes: noteController.text);
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

      throw Error();
    } on DioError catch (e) {
      print("error getting fee");
    } catch (e) {
      print("error by Error");
    }
  }

  double getVatAmount() {
    double vatAmount = fee * total;
    return vatAmount;
  }

  String invoiceTotal() {
    return (total + getVatAmount()).toString();
  }

  void fillRestDataOfInvoice() {
    final userStore = context.read<UserStore>();
    if (createInvoice.payType == 1) {
      createInvoice = createInvoice.copyWith(accno: userStore.user.cashAccno!);
    } else {
      createInvoice = createInvoice.copyWith(accno: selectedCustomer.accNo!);
    }
    createInvoice = createInvoice.copyWith(userno: userStore.user.userNo!);
    createInvoice = createInvoice.copyWith(salesman: userStore.user.salesman!);
    createInvoice = createInvoice.copyWith(whno: userStore.user.whno!);
  }

  bool fieldsIsFilled() {
    return createInvoice.accno != null &&
        createInvoice.salesman != null &&
        createInvoice.custno != null &&
        createInvoice.whno != null &&
        createInvoice.payType != null &&
        createInvoice.accno != null &&
        createInvoice.items != null &&
        selectedCustomer.accName != null &&
        total != 0;
  }

  Future<void> sendInvoiceToApi() async {
    try {
      const String url = "http://192.168.1.2/petrolnaas/public/api/invoice";

      Response res = await Dio().post(url, data: createInvoice.toJson());
      final response = res.data;
      print(response);

      // invoice = Invoice.fromJson(jsonResponse);
    } catch (e) {
      print(e);
    }
  }

  void onPressedPrint() {
    changeNotes();
    fillRestDataOfInvoice();
    print(createInvoice);
    if (!fieldsIsFilled()) {
      Navigator.pop(context, 'Cancel');
      ShowSnackBar(context, 'يجب ملئ جميع البيانات');
      return;
    }

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
          customerName: selectedCustomer.accName!,
        ),
      ),
    );
    createInvoice = CreateInvoice();
    // selectedCustomer.accName = '';
    // createInvoice.payType = null;
    // viewInvoiceItems = [];
    // total = 0.0;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
                  CustomDropdown(
                    text: 'نوع الدفع',
                    itemsList: <String>["نقدي كاش", "آجل"],
                    onChange: onChangePayType,
                    dropdownValue: createInvoice.payType == 3
                        ? 'آجل'
                        : createInvoice.payType == 1
                            ? 'نقدي كاش'
                            : null,
                  ),
                  Observer(builder: (_) {
                    final customersStore = context.watch<CustomerStore>();
                    return CustomDropdown(
                      text: 'العميل',
                      itemsList: customersStore
                          .getCustomersNames(customersStore.customers),
                      onChange: (int idx) =>
                          onChangeCustomer(customersStore.customers[idx]),
                      dropdownValue: selectedCustomer.accName,
                    );
                  }),
                  CustomDropdown(
                    text: 'الصنف',
                    itemsList: products,
                    onChange: onChangeItem,
                    dropdownValue: selectedProduct.itemDesc,
                  ),
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
                  InvoiceItemsTableDetails(items: viewInvoiceItems),
                  ExpandCustomTextField(
                    controller: noteController,
                  ),
                  InvoiceDetails(
                    title: 'الاجمالي :',
                    result: total.toString(),
                  ),
                  InvoiceDetails(
                    title: 'الضريبـــة :',
                    result: getVatAmount().toString(),
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
                        print(createInvoice);
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
                                          onPressed: onPressedPrint,
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

class InvoiceItemsTableDetails extends StatefulWidget {
  final List<ViewInvoiceItem> items;
  const InvoiceItemsTableDetails({Key? key, required this.items})
      : super(key: key);
  @override
  State<InvoiceItemsTableDetails> createState() =>
      _InvoiceItemsTableDetailsState();
}

class _InvoiceItemsTableDetailsState extends State<InvoiceItemsTableDetails> {
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
                DataColumn(label: Text('الرقم')),
                DataColumn(label: Text('اسم الصنف')),
                DataColumn(label: Text('الكمية')),
                DataColumn(label: Text('سعر')),
                DataColumn(label: Text('الاجمالي')),
                DataColumn(label: Text('القطع المجانية')),
              ],
              rows: widget.items
                  .map(
                    (ViewInvoiceItem item) => DataRow(
                      cells: [
                        DataCell(Text(item.itemno!)),
                        DataCell(Text(item.itemDesc!)),
                        DataCell(Text(item.qty.toString())),
                        DataCell(Text(item.sellPrice.toString())),
                        DataCell(
                            Text((item.sellPrice! * item.qty!).toString())),
                        DataCell(Text(item.freeItemsQty.toString())),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
