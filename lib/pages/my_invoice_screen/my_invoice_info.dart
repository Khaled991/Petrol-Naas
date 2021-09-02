import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/invoice_details.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_image/utils.dart';
import 'package:petrol_naas/widget/invoice_image/widget_to_image.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:petrol_naas/widget/print/print.dart';
import '../../constants.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  bool isLoading = true;
  bool isConnected = false;
  late Print thermalPrint;
  GlobalKey? key;
  Uint8List? bytes;
  List<ViewInvoiceItem> itemsListForView = [];

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  @override
  void initState() {
    super.initState();
    getInvoiceData();
    thermalPrint = Print();
  }

  void prepareItemsListForView() {
    itemsListForView = invoice?.details!.map((InvoiceDetails invoiceDetails) {
          return ViewInvoiceItem(
            itemDesc: invoiceDetails.itemDesc,
            sellPrice: double.parse(
              invoiceDetails.unitPrice!,
            ),
            qty: invoiceDetails.qty! + invoiceDetails.freeQty!,
            freeItemsQty: Item.calcFreeQty(
              qty: invoiceDetails.qty!,
              promotionQtyFree: invoiceDetails.promotionQtyFree!,
              promotionQtyReq: invoiceDetails.promotionQtyReq!,
            ),
          );
        }).toList() ??
        [];
  }

  Future<void> capture() async {
    if (isCaptured) return;
    isCaptured = true;
    bytes = await Utils.capture(key);
  }

  Future<Map<String, double>> getPrintDimensions() async {
    final codec = await instantiateImageCodec(bytes!);
    final frameInfo = await codec.getNextFrame();
    final currentWidth = frameInfo.image.width;
    final currentHeight = frameInfo.image.height;
    final double ratio = currentHeight / currentWidth;
    const double newWidth = 300.0;
    final double newHeight = newWidth * ratio;
    return <String, double>{"width": newWidth, "height": newHeight};
  }

  printPDF() async {
    final pw.Document doc = pw.Document();
    final pw.MemoryImage image = pw.MemoryImage(bytes!);
    final Map<String, double> paperDimensions = await getPrintDimensions();

    final String imageFileName =
        'فاتورة ${invoice?.header!.custName! ?? ""}${DateTime.now()}.pdf'
            .replaceAll("/", "-");
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
            paperDimensions["width"]!, paperDimensions["height"]!),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );
    await Printing.sharePdf(bytes: await doc.save(), filename: imageFileName);
  }

  void changePrinterConnection(bool state) {
    setState(() {
      isConnected = state;
    });
  }

  void getInvoiceData() async {
    try {
      changeLoadingState(true);
      final String url =
          "http://5.9.215.57/petrolnaas/public/api/invoice/${widget.invno}";
      Response response = await Dio().get(url);
      final jsonResponse = response.data;
      invoice = Invoice.fromJson(jsonResponse);
      getTafqeet(invoice!.header!.totAfterVat!);
      prepareItemsListForView();
    } catch (e) {
      // print(e);
    }
  }

  void getTafqeet(finalPrice) async {
    try {
      changeLoadingState(true);
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
      changeLoadingState(false);
      Timer(
        const Duration(seconds: 1),
        () async {
          await capture();
        },
      );
    } catch (e) {
      changeLoadingState(false);
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
        actions: [
          if (isCaptured)
            IconButton(
              icon: Icon(Icons.share),
              onPressed: printPDF,
            )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe8bd34)),
              ),
            )
          : SafeArea(
              child: Container(
                color: Colors.grey[50],
                child: ListView(
                  children: [
                    WidgetToImage(builder: (key) {
                      this.key = key;
                      return Padding(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  "العميل : " +
                                      (invoice?.header!.custName! ?? ""),
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: darkColor,
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  color: darkColor,
                                ),
                                ItemsInfoTable(items: itemsListForView),
                                Divider(
                                  height: 20,
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
                                  style: TextStyle(
                                    color: darkColor,
                                    fontSize: 17,
                                  ),
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
                      );
                    }),
                    // CustomButton(
                    //   text: 'طباعة الفاتورة',
                    //   buttonColors: primaryColor,
                    //   textColors: Colors.white,
                    //   icon: Icons.print,
                    //   onPressed: () => onPressPrint,
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}