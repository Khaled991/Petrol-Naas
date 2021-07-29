import 'package:flutter/material.dart';
import 'package:petrol_naas/data/invoice_data.dart';
import 'package:petrol_naas/models/invoice.dart';

import '../constants.dart';
import '../components/custom_button.dart';
import '../components/custom_dropdown.dart';
import '../components/custom_input.dart';
import '../components/expand_custom_textField.dart';
import '../components/invoice_details.dart';
import 'invoice_screen.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final List<Product> products;
  CreateInvoiceModel invoice = CreateInvoiceModel();
  Item item = Item();

  @override
  void initState() {
    // TODO: axios.get /products
    products = fakeProducts;
    super.initState();
  }

  List<String> getProductsNames() {
    return products.map((Product p) => p.itemDesc).toList();
  }

  final TextEditingController qtyController = TextEditingController();

  void onPressAddItem() {
    onChangeQty();
    invoice.items.add(item);
    qtyController.text = '';
    print(invoice.items.length);
    print(invoice.items.last.qty);
  }

  void onChangePayType(int payTypeIdx) {
    Map<int, String> payType = {
      0: '1',
      1: '3',
    };

    invoice.payType = payType[payTypeIdx]!;
  }

  void onChangeCustomer(int customerIdx) {
    //TODO: implement this function after creating customer model
    print(customerIdx);
  }

  void onChangeItem(int itemIdx) {
    //TODO: implement this function after getting items from api
    // item.itemno = invoice.items![itemIdx].itemno;
    print(itemIdx);
  }

  void onChangeQty() {
    item.qty = qtyController.text;
  }

  void onChangeNotes(String notes) {
    invoice.notes = notes;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        CustomDropdown(
          text: 'نوع الدفع',
          itemsList: <String>["نقدي كاش", "آجل"],
          onChange: onChangePayType,
        ),
        CustomDropdown(
          text: 'العميل',
          itemsList: <String>["أحمد", "خالد"],
          onChange: onChangeCustomer,
        ),
        CustomDropdown(
          text: 'الصنف',
          itemsList: getProductsNames(),
          onChange: onChangeItem,
        ),
        // SecondCustomInput(
        //   text: 'اسم العميل',
        //   enabled: false,
        // ),
        // CustomDropdown(text: 'الصنف', itemsList: getProductsNames()),
        CustomInput(
          hintText: 'الكمية',
          keyboardType: TextInputType.number,
          type: 'yellow',
          controller: qtyController,
        ),
        ExpandCustomTextField(),
        InvoiceDetails(
          title: 'الاجمالي :',
          result: '128.57',
        ),
        InvoiceDetails(
          title: 'الخصــــم :',
          result: '0.00',
        ),
        InvoiceDetails(
          title: 'الصافــي :',
          result: '128.57',
        ),
        InvoiceDetails(
          title: 'الضريبـــة :',
          result: '19.29',
        ),
        InvoiceDetails(
          title: 'القطع المجانيـة :',
          result: '0',
        ),
        InvoiceDetails(
          title: 'اجمالي الفاتورة :',
          result: '128.57',
        ),
        CustomButton(
          text: 'اضافة صنف',
          buttonColors: Color(0xff2ecc71),
          textColors: Colors.white,
          icon: Icons.add,
          onPressed: onPressAddItem,
        ),
        CustomButton(
          text: 'طباعة الفاتورة',
          buttonColors: primaryColor,
          textColors: Colors.white,
          icon: Icons.print,
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('تنبية!!'),
              content: const Text(
                'هل انت متأكد لأنه لا يمكن التعديل علي الفاتورة مجدداً',
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
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => InvoiceScreen(
                          finalPrice: 1627.25,
                        ),
                      ),
                    ),
                  },
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
    );
  }
}
