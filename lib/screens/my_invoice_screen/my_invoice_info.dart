import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/components/with_loading.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/invoice_details.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_image/utils.dart';
import 'package:petrol_naas/widget/invoice_image/widget_to_image.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPaperScreen<T> extends StatefulWidget {
  final String invno;
  final Invoice invoice;
  final String? qrData;
  final String? closingNote;

  final Map<String, String>? summaryData;
  final Map<String, String>? headerData;
  final String docFileName;

  const PrintPaperScreen({
    Key? key,
    required this.invno,
    required this.invoice,
    this.summaryData,
    this.headerData,
    this.closingNote,
    this.qrData,
    required this.docFileName,
  }) : super(key: key);

  @override
  State<PrintPaperScreen> createState() => _PrintPaperScreenState();
}

class _PrintPaperScreenState extends State<PrintPaperScreen> {
  bool isCaptured = false;
  bool isLoading = true;
  GlobalKey? key;
  Uint8List? bytes;
  List<ViewInvoiceItem> itemsListForView = [];

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  @override
  void initState() {
    super.initState();
    prepareItemsListForView();
  }

  void prepareItemsListForView() {
    itemsListForView =
        widget.invoice.details!.map((InvoiceDetails invoiceDetails) {
      return ViewInvoiceItem(
        itemno: invoiceDetails.itemno,
        itemDesc: invoiceDetails.itemDesc,
        sellPrice: double.parse(
          invoiceDetails.unitPrice!,
        ),
        qty: invoiceDetails.qty!,
        freeItemsQty: Item.calcFreeQty(
          qty: invoiceDetails.qty!,
          promotionQtyFree: invoiceDetails.promotionQtyFree!,
          promotionQtyReq: invoiceDetails.promotionQtyReq!,
        ),
      );
    }).toList();
  }

  Future<void> capture() async {
    isCaptured = true;
    bytes = await Utils.capture(key);
    setState(() {});
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

  void printPDF() async {
    final pw.Document doc = pw.Document();
    final pw.MemoryImage image = pw.MemoryImage(bytes!);
    final Map<String, double> paperDimensions = await getPrintDimensions();

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
    await Printing.sharePdf(
        bytes: await doc.save(), filename: widget.docFileName);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.5;
    if (!isLoading) {
      Timer(
        const Duration(seconds: 1),
        () async {
          await capture();
        },
      );
    }

    return WithLoading(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'الفاتورة',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[50],
          elevation: 0,
          shadowColor: Color(0x003d3d3d),
          actions: [
            if (isCaptured)
              IconButton(
                icon: Icon(Icons.print_outlined),
                color: Colors.black,
                onPressed: printPDF,
              )
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.grey[50],
            child: ListView(
              children: [
                WidgetToImage(
                  builder: (key) {
                    this.key = key;
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          if (widget.headerData != null)
                            PrintPaperHeader(
                              data: widget.headerData ?? {},
                            ),
                          Divider(
                            height: 20.0,
                            color: darkColor,
                            thickness: 2.0,
                          ),
                          ItemsInfoTable(items: itemsListForView),
                          PrintPaperSummary(
                            data: widget.summaryData!,
                          ),
                          Tafqeet(
                            changeLoadingState: changeLoadingState,
                            price: widget.invoice.header!.totAfterVat!,
                          ),
                          if (widget.qrData != null)
                            Center(
                              child: QrImage(
                                data: widget.qrData!,
                                version: QrVersions.auto,
                                size: screenWidth,
                              ),
                            ),
                          if (widget.closingNote != null)
                            Text(widget.closingNote!),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrintPaperHeader extends StatelessWidget {
  final Map<String, String> data;

  const PrintPaperHeader({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InvoiceScreenHeader(title: 'فاتورة مبيعات ضريبية'),
        SizedBox(
          height: 20.0,
        ),
        ...data.entries
            .toList()
            .map(
              (MapEntry<String, String> mapEntry) => TopTextInvoice(
                defination: mapEntry.key,
                data: mapEntry.value,
              ),
            )
            .toList()
      ],
    );
  }
}

class PrintPaperSummary extends StatelessWidget {
  final Map<String, String> data;

  const PrintPaperSummary({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...data.entries
            .toList()
            .map(
              (MapEntry<String, String> mapEntry) => InvoiceDetailsPrices(
                description: mapEntry.value,
                title: mapEntry.key,
              ),
            )
            .toList()
        // data.forEach(
        //   (String definition, String data) => TopTextInvoice(
        //     data: '123شسؤيشستؤمنشستمنؤتسشمنؤتسشمنؤتمنمنم تسشمنؤ تنشمسؤت نمسش',
        //     defination: 'الرقم',
        //   ),
        // ),
      ],
    );
  }
}

class Tafqeet extends StatefulWidget {
  final void Function(bool) changeLoadingState;
  final String price;

  const Tafqeet({
    Key? key,
    required this.changeLoadingState,
    required this.price,
  }) : super(key: key);

  @override
  State<Tafqeet> createState() => _TafqeetState();
}

class _TafqeetState extends State<Tafqeet> {
  String priceText = "";

  @override
  void initState() {
    super.initState();
    getTafqeet();
  }

  void getTafqeet() async {
    var formData = FormData.fromMap({
      'coinname': 'SAR',
      'number': widget.price,
    });
    try {
      Response response = await Dio().post(
        'https://ahsibli.com/wp-admin/admin-ajax.php?action=date_coins_1',
        data: formData,
      );

      print(response);

      final String priceText =
          response.toString().split("<td>")[4].split("</td>")[0];
      setState(() {
        this.priceText = priceText;
      });
    } catch (e) {
      print(e);
      showSnackBar(
          context, "حدث خطأ ما، الرجاء الانتظار، جارٍ المحاولة مرة أخرى");
    } finally {
      widget.changeLoadingState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$priceText فقط لا غير",
      style: TextStyle(
        color: darkColor,
        fontSize: 17,
      ),
    );
  }
}

class TopTextInvoice extends StatelessWidget {
  final String defination;
  final String data;

  const TopTextInvoice({
    Key? key,
    required this.defination,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$defination :  ",
            style: TextStyle(
              fontSize: 19.0,
              color: darkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 19.0,
                color: darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
