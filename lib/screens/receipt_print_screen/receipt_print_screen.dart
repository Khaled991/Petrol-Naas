import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:petrol_naas/components/with_loading.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:petrol_naas/models/receipt.dart';
import 'package:petrol_naas/screens/my_invoice_screen/my_invoice_info.dart';
import 'package:printing/printing.dart';

class ReceiptPrintScreen extends StatefulWidget {
  final Map<String, String> headerData;

  const ReceiptPrintScreen({Key? key, required this.headerData})
      : super(key: key);

  @override
  _ReceiptPrintScreenState createState() => _ReceiptPrintScreenState();
}

class _ReceiptPrintScreenState extends State<ReceiptPrintScreen> {
  bool isLoading = true;
  bool isCaptured = false;
  Uint8List? bytes;
  String docFileName = "";

  @override
  void initState() {
    super.initState();
    docFileName = 'سند قبض ${DateTime.now()}.pdf'.replaceAll("/", "-");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: PrintPaperHeader(
          data: widget.headerData,
        ),
      ),
    );
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
    await Printing.sharePdf(bytes: await doc.save(), filename: docFileName);
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
}
