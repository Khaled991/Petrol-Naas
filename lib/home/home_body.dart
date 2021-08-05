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
import 'package:petrol_naas/models/invoice_item.dart';
import 'package:petrol_naas/models/item.dart';
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

      items.setCustomers(prepareItemsList(jsonRespone));
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
    //TODO:handle empty quantity
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
    Map<int, int> payType = {
      0: 1,
      1: 3,
    };
    createInvoice = createInvoice.copyWith(payType: payType[payTypeIdx]!);
  }

  void onChangeCustomer(String customerNo) {
    createInvoice = createInvoice.copyWith(custno: customerNo);
  }

  double getItemSellPrice(String itemno) {
    final List<Item> items = context.read<ItemsStore>().items;
    double sellPrice = items
            .firstWhere(
              (Item item) => item.itemno == itemno,
            )
            .sellPrice1 ??
        0.0;
    return sellPrice;
  }

  double total = 0.0;

  void getTotalSaleHeader() {
    if (createInvoice.items == null) return;
    List<InvoiceItem> items = createInvoice.items!;
    double total = 0;
    for (int i = 0; i < items.length; i++) {
      InvoiceItem item = items[i];
      double sellPrice = getItemSellPrice(item.itemno!);
      int qty = item.qty!;
      total += sellPrice * qty.toDouble();
    }
    setState(() {
      this.total = total;
    });
  }

  int calcFreeQty() {
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
    print('createInvoice');
    print(createInvoice);
  }

  List<String> getCustomersNames(List<Customer> customers) {
    print(customers);
    return customers
        .map((Customer customer) => customer.accName ?? "")
        .toList();
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
        print('feeeee');
        print(fee);
        this.fee = fee;
      });
      throw Error();
    } on DioError catch (e) {
      print("error getting fee");
      print(e);
    } catch (e) {
      print("error by Error");
      print(e);
    }
  }

  double getVatAmount() {
    double vatAmount = fee * total;
    return vatAmount;
  }

  String invoiceTotal() {
    return (total + getVatAmount()).toString();
  }

  void onPressedPrint() {
    //TODO  if this obj is not null CreateInvoice
    onChangeNotes();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvoiceScreen(
          finalPrice: double.parse(invoiceTotal()),
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
              itemsList: getCustomersNames(customersStore.customers),
              onChange: (int idx) =>
                  onChangeCustomer(customersStore.customers[idx].accNo!),
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
          ExpandCustomTextField(
            controller: noteController,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
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
                    DataColumn(label: Text('الصنف')),
                    DataColumn(label: Text('سعر')),
                    DataColumn(label: Text('القطع المجانية')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('oil 8')),
                        DataCell(Text('50')),
                        DataCell(Text('5')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          InvoiceDetails(
            title: 'الاجمالي :',
            result: total.toString(),
            // result: 'getTotalSaleHeader.toString()',
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
