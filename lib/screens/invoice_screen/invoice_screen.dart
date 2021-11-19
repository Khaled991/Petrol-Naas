import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/invoice_details_prices.dart';
import 'package:petrol_naas/widget/invoice_screen_header.dart';
import 'package:petrol_naas/widget/items_info.dart';
import 'package:petrol_naas/widget/invoice_image/utils.dart';
import 'package:petrol_naas/widget/invoice_image/widget_to_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class InvoiceScreen extends StatefulWidget {
  final Widget? child;
  final double total;
  final double vat;
  final String customerName;
  final String invNo;
  final String payType;
  final String? customerVATnum;

  const InvoiceScreen({
    Key? key,
    this.child,
    required this.total,
    required this.vat,
    required this.customerName,
    required this.invNo,
    required this.payType,
    required this.customerVATnum,
  }) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String priceText = "";
  GlobalKey? key;
  Uint8List? bytes;
  bool isCaptured = false;
  String qrData = '';
  final List<ViewInvoiceItem> items = [];

  @override
  void initState() {
    getTafqeet();
    prepareItemsForView();
    super.initState();
  }

  void prepareItemsForView() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();

    int itemsCount = addedItemsToNewInvoiceStore.items.length;
    for (int i = 0; i < itemsCount; i++) {
      int qty = addedItemsToNewInvoiceStore.quantities[i];
      Item item = addedItemsToNewInvoiceStore.items[i];
      addItemForView(item, qty);
    }
  }

  void addItemForView(Item item, int qty) {
    items.add(
      ViewInvoiceItem(
        qty: qty,
        itemno: item.itemno,
        freeItemsQty: Item.calcFreeQty(
          qty: qty,
          promotionQtyReq: item.promotionQtyReq!,
          promotionQtyFree: item.promotionQtyFree!,
        ),
        itemDesc: item.itemDesc,
        sellPrice: item.sellPrice,
      ),
    );
  }

  Future<void> capture(key) async {
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
    final doc = pw.Document();
    final image = pw.MemoryImage(bytes!);
    final paperDimensions = await getPrintDimensions();

    final String imageFileName =
        'فاتورة ${widget.customerName}${DateTime.now()}.pdf'
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

  void getTafqeet() async {
    try {
      var formData = FormData.fromMap({
        'coinname': 'SAR',
        'number': widget.total + widget.vat,
      });

      Response response = await Dio(dioOptions).post(
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
الإجمالي شامل الضريبة : ${widget.total + widget.vat}
قيمة الضريبة : ${widget.vat}""";
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

  String prepareDateAndTimeToPrintInInvoice() {
    String dateString = DateFormat("dd-MM-yyyy hh:mma").format(DateTime.now());
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.5;
    final userStore = context.watch<UserStore>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الفاتورة',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        shadowColor: Color(0x003d3d3d),
        actions: [
          if (isCaptured)
            IconButton(
              icon: Icon(Icons.print_outlined),
              onPressed: printPDF,
            )
        ],
      ),
      body: SafeArea(
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
                        InvoiceScreenHeader(
                          title: 'فاتورة مبيعات ضريبية',
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'الرقم : ${widget.invNo}',
                          style: TextStyle(
                            fontSize: 19.0,
                            color: darkColor,
                          ),
                        ),
                        Text(
                          'التاريخ : ' + prepareDateAndTimeToPrintInInvoice(),
                          style: TextStyle(
                            fontSize: 19.0,
                            color: darkColor,
                          ),
                        ),
                        Text(
                          'نوع الدفع : ${widget.payType}',
                          style: TextStyle(
                            fontSize: 19.0,
                            color: darkColor,
                          ),
                        ),
                        Text(
                          'العميل : ${widget.customerName}',
                          style: TextStyle(
                            fontSize: 19.0,
                            color: darkColor,
                          ),
                        ),
                        if (widget.customerVATnum != null)
                          Text(
                            'الرقم الضريبي للعميل : ${widget.customerVATnum}',
                            style: TextStyle(
                              fontSize: 19.0,
                              color: darkColor,
                            ),
                          ),
                        Text(
                          'المندوب : ${userStore.user.name}',
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
                        ItemsInfoTable(
                          items: items,
                        ),
                        InvoiceDetailsPrices(
                          description: widget.total.toStringAsFixed(2),
                          title: 'الاجمالي',
                        ),
                        InvoiceDetailsPrices(
                          description: '0.00',
                          title: 'الخصم',
                        ),
                        InvoiceDetailsPrices(
                          description: widget.total.toStringAsFixed(2),
                          title: 'الصافي',
                        ),
                        InvoiceDetailsPrices(
                          description: widget.vat.toStringAsFixed(2),
                          title: 'ضريبة القيمة المضافة',
                        ),
                        InvoiceDetailsPrices(
                          description:
                              (widget.total + widget.vat).toStringAsFixed(2),
                          title: 'قيمة الفاتورة',
                        ),
                        Text(
                          priceText + " فقط لا غير",
                          style: TextStyle(color: darkColor, fontSize: 17),
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
            }),
          ],
        ),
      ),
    );
  }
}
