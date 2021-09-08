import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/models/invoice.dart';
import 'package:petrol_naas/models/invoice_details.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_image/utils.dart';
import 'package:petrol_naas/widget/invoice_image/widget_to_image.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:petrol_naas/widget/snack_bars/show_snack_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyInvoiceInfo extends StatefulWidget {
  final String invno;
  final Invoice invoice;
  const MyInvoiceInfo({
    Key? key,
    required this.invno,
    required this.invoice,
  }) : super(key: key);

  @override
  State<MyInvoiceInfo> createState() => _MyInvoiceInfoState();
}

class _MyInvoiceInfoState extends State<MyInvoiceInfo> {
  String? priceText;
  bool isCaptured = false;
  bool isLoading = true;
  bool isConnected = false;
  GlobalKey? key;
  Uint8List? bytes;
  List<ViewInvoiceItem> itemsListForView = [];
  String qrData = '';

  void changeLoadingState(bool state) => setState(() => isLoading = state);

  @override
  void initState() {
    super.initState();
    getTafqeet(widget.invoice.header!.totAfterVat!);
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
        qty: invoiceDetails.qty! + invoiceDetails.freeQty!,
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

  printPDF() async {
    final pw.Document doc = pw.Document();
    final pw.MemoryImage image = pw.MemoryImage(bytes!);
    final Map<String, double> paperDimensions = await getPrintDimensions();

    final String imageFileName =
        'فاتورة ${widget.invoice.header!.custName!}${DateTime.now()}.pdf'
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

  // void getInvoiceData() async {
  //   try {
  //     changeLoadingState(true);
  //     final String url =
  //         "http://5.9.215.57/petrolnaas/public/api/invoice/${widget.invno}";
  //     Response response = await Dio().get(url);
  //     final jsonResponse = response.data;
  //     invoice = Invoice.fromJson(jsonResponse);
  //     getTafqeet(invoice!.header!.totAfterVat!);
  //     prepareItemsListForView();
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

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
      qrData = """اسم المورد : شركة مصنع بترول ناس
الرقم الضريبي : 300468968200003
التاريخ والوقت : ${prepareDateAndTimeToPrintInInvoice()}
الإجمالي شامل الضريبة : ${widget.invoice.header!.totAfterVat!}
قيمة الضريبة : ${widget.invoice.header!.vaTamount!}""";
      changeLoadingState(false);
      Timer(
        const Duration(seconds: 1),
        () async {
          await capture();
        },
      );
    } catch (e) {
      changeLoadingState(false);
      ShowSnackBar(context, "حدث خطأ ما، الرجاء المحاولة مرة أخرى");
    }
  }

  String prepareDateAndTimeToPrintInInvoice() {
    DateTime invoiceDate = DateTime.parse(widget.invoice.header!.invdate!);
    String dateString = DateFormat("dd-MM-yyyy hh:mma").format(invoiceDate);

    return dateString;
  }
  // final String today = DateFormat("dd-MM-yyyy hh:mma").format(widget.invoice.header!.invdate! ?? "" );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      appBar: AppBar(
        title: Text('الفاتورة'),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        shadowColor: Color(0x003d3d3d),
        actions: [
          if (isCaptured)
            IconButton(
              icon: Icon(Icons.print_outlined),
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
                    WidgetToImage(
                      builder: (key) {
                        this.key = key;
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InvoiceScreenHeader(taxNo: '300468968200003'),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    'الرقم : ' + widget.invno,
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: darkColor,
                                    ),
                                  ),
                                  Text(
                                    "التاريخ : " +
                                        prepareDateAndTimeToPrintInInvoice(),
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: darkColor,
                                    ),
                                  ),
                                  Text(
                                    'نوع الدفع : ${widget.invoice.header?.payType ?? ""}',
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: darkColor,
                                    ),
                                  ),
                                  Text(
                                    "العميل : " +
                                        (widget.invoice.header!.custName!),
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: darkColor,
                                    ),
                                  ),
                                  if (widget.invoice.header!.VATnum != null)
                                    Text(
                                      'الرقم الضريبي للعميل : ${widget.invoice.header!.VATnum!}',
                                      style: TextStyle(
                                        fontSize: 19.0,
                                        color: darkColor,
                                      ),
                                    ),
                                  Text(
                                    "المندوب : " +
                                        (widget.invoice.header!
                                            .createdDelegateName!),
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      color: darkColor,
                                    ),
                                  ),
                                  Divider(
                                    height: 20.0,
                                    color: darkColor,
                                    thickness: 2.0,
                                  ),
                                  ItemsInfoTable(items: itemsListForView),
                                  InvoiceDetailsPrices(
                                    price: widget.invoice.header!.total!,
                                    title: 'الاجمالي',
                                  ),
                                  InvoiceDetailsPrices(
                                    price:
                                        widget.invoice.header!.discountTotal!,
                                    title: 'الخصم',
                                  ),
                                  InvoiceDetailsPrices(
                                    price: widget.invoice.header!.netTotal!,
                                    title: 'الصافي',
                                  ),
                                  InvoiceDetailsPrices(
                                    price: widget.invoice.header!.vaTamount!,
                                    title: 'ضريبة القيمة المضافة',
                                  ),
                                  InvoiceDetailsPrices(
                                    price: widget.invoice.header!.totAfterVat!,
                                    title: 'قيمة الفاتورة',
                                  ),
                                  Text(
                                    (priceText ?? "") + " فقط لا غير",
                                    style: TextStyle(
                                      color: darkColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Center(
                                    child: QrImage(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: screenWidth,
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
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}



// class TopTextInvoice extends StatelessWidget {
//   final String defination;
//   final String data;

//   const TopTextInvoice({
//     Key? key,
//     required this.defination,
//     required this.data,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(
//           "$defination :  ",
//           style: TextStyle(
//             fontSize: 19.0,
//             color: darkColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           data,
//           style: TextStyle(
//             fontSize: 19.0,
//             color: darkColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
