import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class Print {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  print(Uint8List bytes) async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printNewLine();
        bluetooth.printImageBytes(bytes);
        bluetooth.printNewLine();

        bluetooth.paperCut();
      }
    });
  }
}
