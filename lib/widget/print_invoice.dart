import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/show_snack_bar.dart';

import '../constants.dart';

class PrintInvoice extends StatefulWidget {
  final bool connected;
  const PrintInvoice(this.connected);
  @override
  _PrintInvoiceState createState() => _PrintInvoiceState();
}

class _PrintInvoiceState extends State<PrintInvoice> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  late bool _connected;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _connected = widget.connected;
    // initSavetoPath();
  }

  // initSavetoPath() async {
  //   //read and write
  //   //image max 300px X 300px
  //   final filename = 'yourlogo.png';
  //   var bytes = await rootBundle.load("assets/images/yourlogo.png");
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   writeToFile(bytes, '$dir/$filename');
  //   setState(() {
  //     pathImage = '$dir/$filename';
  //   });
  // }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected!) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'اختر الطابعة',
                style: TextStyle(
                  fontSize: 18.0,
                  color: darkColor,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: primaryColor,
                    style: BorderStyle.solid,
                    width: 1.2,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                    child: DropdownButtonFormField<BluetoothDevice>(
                      value: _device,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text(
                        'تحديد الطابعة',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      icon: const Icon(
                        Icons.expand_more,
                        color: primaryColor,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      isExpanded: true,
                      isDense: true,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Changa',
                        color: Color(0x993d3d3d),
                      ),
                      onChanged: (BluetoothDevice? value) {
                        setState(() => _device = value);
                      },
                      items: _getDeviceItems(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: CustomButton(
                buttonColors: _connected ? redColor : greenColor,
                textColors: Colors.white,
                text: _connected ? 'قطع الاتصال بالطابعة' : 'اتصال بالطابعة',
                onPressed: _connected ? _disconnect : _connect,
              ),
            ),
            Expanded(
              child: CustomButton(
                buttonColors: primaryColor,
                textColors: Colors.white,
                text: 'تحديث',
                onPressed: () {
                  initPlatformState();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('اختر طابعة'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      ShowSnackBar(context, 'لم يتم اختيار طابعة.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  //write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
