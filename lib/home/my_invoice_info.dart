import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/invoice_details.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:petrol_naas/widget/widget_to_image.dart';
import '../constants.dart';

class MyInvoiceInfo extends StatefulWidget {
  final String invno;

  const MyInvoiceInfo({
    Key? key,
    this.invno = "108639",
  }) : super(key: key);

  @override
  State<MyInvoiceInfo> createState() => _MyInvoiceInfoState();
}

class _MyInvoiceInfoState extends State<MyInvoiceInfo> {
  String? priceText;
  bool isCaptured = false;
  Invoice? invoice;

  @override
  void initState() {
    super.initState();
    getInvoiceData();
  }

  void getInvoiceData() async {
    try {
      final String url =
          "http://192.168.1.2/petrolnaas/public/api/invoice/${widget.invno}";

      Response response = await Dio().get(url);
      final jsonResponse = response.data;

      invoice = Invoice.fromJson(jsonResponse);
      getTafqeet(invoice!.header!.totAfterVat!);
    } catch (e) {
      print(e);
    }
  }

  void getTafqeet(finalPrice) async {
    try {
      var formData = FormData.fromMap({
        'coinname': 'SAR',
        'number': finalPrice,
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفاتورة'),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        shadowColor: Color(0x003d3d3d),
      ),
      body: WidgetToImage(
        builder: (key) {
          return SafeArea(
            child: Container(
              color: Colors.grey[50],
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      height: 2,
                      color: darkColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InvoiceScreenHeader(taxNo: '3004687955200002'),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الرقم : ' + widget.invno,
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: darkColor,
                                  ),
                                ),
                                Text(
                                  "التاريخ : " +
                                      (invoice?.header!.invdate!
                                              .split(" ")[0] ??
                                          ""),
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: darkColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "العميل : " + (invoice?.header!.custName! ?? ""),
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
                                items: invoice?.details!
                                        .map((InvoiceDetails invoiceDetails) =>
                                            ViewInvoiceItem(
                                              itemDesc: invoiceDetails.itemDesc,
                                              sellPrice: double.parse(
                                                  invoiceDetails.unitPrice!),
                                              qty: invoiceDetails.qty,
                                            ))
                                        .toList() ??
                                    []),
                            Divider(
                              height: 2,
                              color: darkColor,
                            ),
                            InvoiceDetailsPrices(
                              price: invoice?.header!.total! ?? "",
                              tittle: 'الاجمالي',
                            ),
                            InvoiceDetailsPrices(
                              price: invoice?.header!.discountTotal! ?? "",
                              tittle: 'الخصم',
                            ),
                            InvoiceDetailsPrices(
                              price: invoice?.header!.netTotal! ?? "",
                              tittle: 'الصافي',
                            ),
                            InvoiceDetailsPrices(
                              price: invoice?.header!.vaTamount! ?? "",
                              tittle: 'ضريبة القيمة المضافة',
                            ),
                            InvoiceDetailsPrices(
                              price: invoice?.header!.totAfterVat! ?? "",
                              tittle: 'قيمة الفاتورة',
                            ),
                            Text(
                              (priceText ?? "") + " فقط لا غير",
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
            ),
          );
        },
      ),
    );
  }
}
