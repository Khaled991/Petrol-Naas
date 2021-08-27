import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:petrol_naas/widget/print/print.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:petrol_naas/widget/invoice_image/utils.dart';
import 'package:petrol_naas/widget/invoice_image/widget_to_image.dart';
import '../../constants.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceScreen extends StatefulWidget {
  final Widget? child;
  final double finalPrice;
  final double total;
  final double fee;
  final List<ViewInvoiceItem> items;
  final String customerName;
  final String invNo;
  final bool isConnected;
  const InvoiceScreen({
    Key? key,
    this.child,
    required this.finalPrice,
    required this.total,
    required this.fee,
    required this.items,
    required this.customerName,
    required this.invNo,
    required this.isConnected,
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

  Future<void> capture(key) async {
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
    final doc = pw.Document();
    final image = pw.MemoryImage(bytes!);
    final paperDimensions = await getPrintDimensions();

    final String imageFileName =
        'فاتورة ${widget.customerName}${DateTime.now()}.pdf'
            .replaceAll(" ", "-");

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
          await capture(key);
          printPDF();
        },
      );
    } catch (e) {
      // print(e);
    }
  }

  final String today = DateFormat("dd-MM-yyyy").format(DateTime.now());

  //TODO: Timezone Soudia arabia +3
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفاتورة'),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        shadowColor: Color(0x003d3d3d),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: printPDF,
          )
        ],
      ),
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
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الرقم : ${widget.invNo}',
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
                          SizedBox(height: 5),
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
                            price: (widget.finalPrice + widget.fee).toString(),
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
