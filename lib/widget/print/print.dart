import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:petrol_naas/models/view_invoice_item.dart';

class Print {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  printPDF({
    required String invNo,
    required String today,
    required String customerName,
    required String total,
    required String fee,
    required String finalPrice,
    required String priceText,
    required List<ViewInvoiceItem> items,
    required String pathImage,
  }
      // Uint8List bytes,
      ) async {
    print('RRRRRRRRR');
    final doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello World'),
          ); // Center
        })); // Page
    await Printing.sharePdf(
        bytes: await doc.save(), filename: 'my-document.pdf');
  }

  print_old({
    required String invNo,
    required String today,
    required String customerName,
    required String total,
    required String fee,
    required String finalPrice,
    required String priceText,
    required List<ViewInvoiceItem> items,
    required String pathImage,
  }
      // Uint8List bytes,
      ) async {
    bluetooth.isConnected.then((isConnected) {
      //SIZE
      // 0- normal size text
      // 1- only bold text
      // 2- bold with medium text
      // 3- bold with large text
      //ALIGN
      // 0- ESC_ALIGN_LEFT
      // 1- ESC_ALIGN_CENTER
      // 2- ESC_ALIGN_RIGHT
      if (isConnected!) {
        // bluetooth.printImage(pathImage);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "_______________________________________________", 3, 1);
        bluetooth.printCustom("Petrol Naas مصنع بترول ناس", 3, 1,
            charset: "UTF-32");
        bluetooth.printCustom(
            "_______________________________________________", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("الرقم الضريبي : 3004687955200002", 1, 2,
            charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("فاتورة مبيعات", 1, 2, charset: "UTF-32");
        bluetooth.printCustom("___________", 3, 2);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("التاريخ : $today", "الرقم : $invNo", 1,
            charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("العميل : $customerName", 1, 2,
            charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "_______________________________________________", 3, 1);
        bluetooth.printLeftRight(
          "الاجمالي  السعر  الكمية",
          "الصنف",
          2,
          charset: "UTF-32",
        );
        items
            .map(
              (ViewInvoiceItem item) => {
                bluetooth.printCustom(
                    "_______________________________________________", 3, 1),
                bluetooth.printLeftRight(
                    "${item.sellPrice! * item.qty!}  ${item.sellPrice}  ${item.qty! + item.freeItemsQty!}",
                    "${item.itemDesc!}",
                    2,
                    charset: "UTF-32"),
                bluetooth.printCustom(
                    "_______________________________________________", 3, 1),
                bluetooth.printNewLine(),
              },
            )
            .toList();

        bluetooth.printCustom("الاجمالي : $total", 2, 2, charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("الخصم : 0.00", 2, 2, charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("الصافي : $total", 2, 2, charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("ضريبة القيمة المضافة : $fee", 2, 2,
            charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("قيمة الفاتورة : $finalPrice", 2, 2,
            charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom("$priceText فقط لا غير", 1, 2, charset: "UTF-32");
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "الرجاء احضار الفاتورة عند الاسترجاع أو الاستبدال خلال أسبوع", 0, 2,
            charset: "UTF-32");
        // bluetooth.printCustom("____________________________________", 3, 1);
        // bluetooth.printNewLine();
        // bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        // bluetooth.printCustom("Body left", 1, 0);
        // bluetooth.printCustom("Body right", 0, 2);
        // bluetooth.printNewLine();
        // bluetooth.printCustom("Terimakasih", 2, 1);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        // bluetooth.paperCut();

        // bluetooth.printNewLine();
        // bluetooth.printImageBytes(
        //   bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        // );
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        // bluetooth.paperCut();
      }
    });
  }
}
