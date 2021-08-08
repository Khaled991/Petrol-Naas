import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/utils.dart';
import 'package:petrol_naas/widget/widget_to_image.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import '../constants.dart';

class InvoiceScreen extends StatefulWidget {
  final Widget? child;
  final double finalPrice;
  final double total;
  final double fee;
  final List<ViewInvoiceItem> items;
  final String customerName;

  const InvoiceScreen({
    Key? key,
    this.child,
    required this.finalPrice,
    required this.total,
    required this.fee,
    required this.items,
    required this.customerName,
  }) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String priceText = "";
  GlobalKey? key;
  Uint8List? bytes;
  bool isCaptured = false;

  @override
  void initState() {
    getTafqeet();
    super.initState();
  }

  Future<void> capture(key) async {
    isCaptured = true;
    final bytes = await Utils.capture(key);
    setState(() {
      this.bytes = bytes;
    });
  }

  void getTafqeet() async {
    try {
      var formData = FormData.fromMap({
        'coinname': 'SAR',
        'number': widget.finalPrice,
      });
      Response response = await Dio().post(
        'https://ahsibli.com/wp-admin/admin-ajax.php?action=date_coins_1',
        data: formData,
      );
      final String priceText =
          response.toString().split("<td>")[4].split("</td>")[0];
      setState(() {
        this.priceText = priceText;
      });
      Timer(
        const Duration(seconds: 1),
        () {
          if (isCaptured == false && priceText != '') {
            capture(key);
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  final String today = DateFormat("dd-mm-yyyy").format(DateTime.now());
  //TODO: Timezone Soudia arabia
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetToImage(
        builder: (key) {
          this.key = key;
          return SafeArea(
            child: ListView(
              children: [
                // buildImage(bytes),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          InvoiceScreenHeader(taxNo: '3004687955200002'),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الرقم : 100200',
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: darkColor,
                                ),
                              ),
                              Text(
                                'التاريخ : ' + today,
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: darkColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'العميل : ${widget.customerName}',
                            style: TextStyle(
                              fontSize: 19.0,
                              color: darkColor,
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: darkColor,
                          ),
                          ItemsInfo(
                            items: widget.items,
                          ),
                          Divider(
                            height: 2,
                            color: darkColor,
                          ),
                          InvoiceDetailsPrices(
                            price: widget.total.toString(),
                            tittle: 'الاجمالي',
                          ),
                          InvoiceDetailsPrices(
                            price: '0.00',
                            tittle: 'الخصم',
                          ),
                          InvoiceDetailsPrices(
                            price: widget.total.toString(),
                            tittle: 'الصافي',
                          ),
                          InvoiceDetailsPrices(
                            price: widget.fee.toString(),
                            tittle: 'ضريبة القيمة المضافة',
                          ),
                          InvoiceDetailsPrices(
                            price: widget.finalPrice.toString(),
                            tittle: 'قيمة الفاتورة',
                          ),
                          Text(
                            priceText + " فقط لا غير",
                            style: TextStyle(color: darkColor, fontSize: 17),
                          ),
                          Text(
                            'الرجاء احضار الفاتورة عند الاسترجاع أو الاستبدال خلال أسبوع',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildImage(Uint8List? bytes) =>
      bytes != null ? Image.memory(bytes) : Container();
}

//===========================================Items info===========================================

class ItemsInfo extends StatefulWidget {
  final List<ViewInvoiceItem> items;

  ItemsInfo({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<ItemsInfo> createState() => _ItemsInfoState();
}

class _ItemsInfoState extends State<ItemsInfo> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      horizontalMargin: 10.0,
      columns: [
        DataColumn(label: Text('الاجمالي')),
        DataColumn(label: Text('سعر')),
        DataColumn(label: Text('الكمية')),
        DataColumn(label: Text('اسم الصنف')),
      ],
      rows: widget.items
          .map(
            (ViewInvoiceItem item) => DataRow(
              cells: [
                DataCell(Text((item.sellPrice! * item.qty!).toString())),
                DataCell(Text(item.sellPrice.toString())),
                DataCell(Text(item.qty.toString())),
                DataCell(Text(item.itemDesc!)),
              ],
            ),
          )
          .toList(),
    );
  }
}

//===========================================invoice details prices===========================================

class InvoiceDetailsPrices extends StatelessWidget {
  const InvoiceDetailsPrices({
    Key? key,
    required this.tittle,
    required this.price,
  }) : super(key: key);
  final String tittle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: darkColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: Text(
                price,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
        Text(
          tittle,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}

//===========================================Header===========================================

class InvoiceScreenHeader extends StatelessWidget {
  const InvoiceScreenHeader({
    Key? key,
    required this.taxNo,
  }) : super(key: key);
  final String taxNo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: darkColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
              child: Text(
                'Petrol Naas مصنع بترول ناس',
                style: TextStyle(
                  fontSize: 20.0,
                  color: darkColor,
                ),
              ),
            ),
            Text(
              'الرقم الضريبي : $taxNo',
              style: TextStyle(
                fontSize: 16.0,
                color: darkColor,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: darkColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'دخال مبيعات',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: darkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/images/logo.png',
          width: 100,
        ),
      ],
    );
  }
}
