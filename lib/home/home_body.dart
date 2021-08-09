import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/custom_dropdown.dart';
import 'package:petrol_naas/components/custom_input.dart';
import 'package:petrol_naas/components/expand_custom_text_field.dart';
import 'package:petrol_naas/components/invoice_details.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/create_invoice.dart';
import 'package:petrol_naas/models/customer.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/invoice_item.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:provider/src/provider.dart';
import '../constants.dart';
import 'invoice_screen.dart';

// ignore: must_be_immutable
class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  CreateInvoice createInvoice = CreateInvoice();
  InvoiceItem invoiceItem = InvoiceItem();

  Item item = Item();
  List<ViewInvoiceItem> viewInvoiceItems = [];

  final TextEditingController qtyController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // final store = context.read<

  // List<InvoiceItem> prepareinvoiceItemList(dynamic invoiceItemsList) {
  //   List<InvoiceItem> invoiceItems = List<InvoiceItem>.from(
  //     invoiceItemsList.map(
  //       (customer) => InvoiceItem.fromJson(customer),
  //     ),
  //   );
  //   return invoiceItems;
  // }

  // Future<void> getInvoiceItem() async {
  //   try {
  //     Response response = await Dio().get(
  //       'http://192.168.1.2/petrolnaas/public/api/invoice',
  //     );

  //     var jsonRespone = jsonDecode(response.toString());
  //     // ref.read(invoiceItemProvider).state = prepareinvoiceItemList(jsonRespone);
  //   } on DioError catch (e) {
  //     print(e);
  //   }
  // }
  double fee = 0.0;
  void asyncMethod() async {
    await getCustomers();
    await getItems();
    await getFee();
  }

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  Future<void> getCustomers() async {
    try {
      final String salesman = context.read<UserStore>().user.salesman ?? '';
      Response response = await Dio().get(
        'http://192.168.1.2/petrolnaas/public/api/customer?Salesman=$salesman',
      );
      var jsonRespone = response.data;
      print(jsonRespone);

      final customersStore = context.read<CustomerStore>();

      customersStore.setCustomers(prepareCustomersList(jsonRespone));
    } on DioError catch (e) {
      print(e);
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
      Response response = await Dio().get(
        'http://192.168.1.2/petrolnaas/public/api/items',
      );
      var jsonRespone = response.data;
      final items = context.read<ItemsStore>();

      items.setItems(prepareItemsList(jsonRespone));
    } on DioError catch (e) {
      print(e);
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
    if (qtyController.text == '' && createInvoice.items == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يجب إضافة كمية او اختيار صنف'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    onChangeQty();
    List<InvoiceItem> mergedOldAndNewItems = createInvoice.items ?? [];
    mergedOldAndNewItems.add(invoiceItem);
    setState(
      () {
        createInvoice = createInvoice.copyWith(items: mergedOldAndNewItems);
      },
    );
    getTotalSaleHeader();
    qtyController.text = '';
  }

  void onChangePayType(int payTypeIdx) {
    Map<int, int> payTypeDecode = {
      0: 1,
      1: 3,
    };

    final int payType = payTypeDecode[payTypeIdx]!;

    createInvoice = createInvoice.copyWith(payType: payType);
  }

  Customer selectedCustomer = Customer();

  void onChangeCustomer(Customer customer) {
    selectedCustomer = selectedCustomer.copyWith(accName: customer.accName!);
    String customerNo = customer.accNo!;
    createInvoice = createInvoice.copyWith(custno: customerNo);
  }

  double total = 0.0;

  void getTotalSaleHeader() {
    if (createInvoice.items == null) return;
    List<InvoiceItem> items = createInvoice.items!;
    double total = 0;

    for (int i = 0; i < items.length; i++) {
      InvoiceItem item = items[i];
      Item itemFromAvailableItems = findItemByItemNo(item.itemno!);

      double sellPrice = getItemSellPrice(itemFromAvailableItems);
      int qty = item.qty!;
      total += sellPrice * qty.toDouble();

      bool isLastItem = i == items.length - 1;
      if (isLastItem) addItemToViewInvoiceItemsList(itemFromAvailableItems);
    }

    setState(() {
      this.total = total;
    });
  }

  double getItemSellPrice(Item item) {
    double sellPrice = item.sellPrice1 ?? 0.0;
    return sellPrice;
  }

  Item findItemByItemNo(String itemno) {
    List<Item> items = context.read<ItemsStore>().items;
    Item item = items.firstWhere(
      (Item item) => item.itemno == itemno,
    );
    return item;
  }

  void addItemToViewInvoiceItemsList(Item item) {
    viewInvoiceItems.add(ViewInvoiceItem(
      itemno: item.itemno!,
      itemDesc: item.itemDesc!,
      qty: int.parse(qtyController.text),
      freeItemsQty: calcFreeQty(item),
      sellPrice: item.sellPrice1!,
    ));
  }

  int calcFreeQty(Item item) {
    int promotionQtyFree = item.promotionQtyFree!;
    int promotionQtyReq = item.promotionQtyReq!;
    int qty = invoiceItem.qty!;

    int freeQty = 0;
    if (promotionQtyFree != 0) {
      int free = (qty / promotionQtyReq) as int;
      freeQty = free * promotionQtyFree;
    }
    return freeQty;
  }

  void onChangeItem(String itemNo) {
    invoiceItem = invoiceItem.copyWith(itemno: itemNo);
  }

  void onChangeQty() {
    invoiceItem = invoiceItem.copyWith(qty: int.parse(qtyController.text));
  }

  void onChangeNotes() {
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

  void fillRestDataOfInvoice(int payType) {
    final userStore = context.read<UserStore>();
    // accno
    if (payType == 1) {
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
      final String url = "http://192.168.1.2/petrolnaas/public/api/invoice";

      Response res = await Dio().post(url, data: createInvoice.toJson());
      final response = res.data;
      print(response);

      // invoice = Invoice.fromJson(jsonResponse);

    } catch (e) {
      print(e);
    }
  }

  void onPressedPrint() {
    onChangeNotes();
    int? payType = createInvoice.payType;

    if (payType == null) {
      Navigator.pop(context, 'Cancel');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يجب اختيار وسيلة دفع'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    fillRestDataOfInvoice(payType);

    if (!fieldsIsFilled()) {
      Navigator.pop(context, 'Cancel');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يجب ملء جميع البيانات'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          CustomDropdown(
            text: 'نوع الدفع',
            itemsList: <String>["نقدي كاش", "آجل"],
            onChange: onChangePayType,
          ),
          Observer(builder: (_) {
            final customersStore = context.watch<CustomerStore>();
            return CustomDropdown(
              text: 'العميل',
              itemsList:
                  customersStore.getCustomersNames(customersStore.customers),
              onChange: (int idx) =>
                  onChangeCustomer(customersStore.customers[idx]),
            );
          }),
          Observer(builder: (_) {
            final itemsStore = context.watch<ItemsStore>();
            return CustomDropdown(
              text: 'الصنف',
              itemsList: getProductsNames(itemsStore.items),
              onChange: (int idx) {
                onChangeItem(itemsStore.items[idx].itemno!);
              },
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
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('تنبيه!!'),
                content: const Text(
                  'هل انت متأكد من الاستمرار لأنه لا يمكن التعديل علي الفاتورة مجدداً',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      'الغاء',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: onPressedPrint,
                    child: const Text(
                      'موفق',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
