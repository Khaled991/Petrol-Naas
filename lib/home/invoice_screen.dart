import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:petrol_naas/widget/print.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:petrol_naas/widget/utils.dart';
import 'package:petrol_naas/widget/widget_to_image.dart';
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
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  String priceText = "";
  GlobalKey? key;
  Uint8List? bytes;
  bool isCaptured = false;

  late Print thermalPrint;

  @override
  void initState() {
    getTafqeet();
    super.initState();
    thermalPrint = Print();
  }

  Future<Uint8List> capture(key) async {
    isCaptured = true;
    final bytes = await Utils.capture(key);
    return bytes;
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
        () async {
          if (isCaptured == false && priceText != '') {
            final imgBytes = await capture(key);
            thermalPrint.print(imgBytes);
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  final String today = DateFormat("dd-MM-yyyy").format(DateTime.now());
  //TODO: Timezone Soudia arabia +3
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetToImage(
        builder: (key) {
          this.key = key;
          return SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InvoiceScreenHeader(
                            taxNo: '3004687955200002',
                            isColored: false,
                          ),
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
                          ItemsInfoTable(
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
}
