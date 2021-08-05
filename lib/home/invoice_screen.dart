import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/widget/utils.dart';
import 'package:petrol_naas/widget/widget_to_image.dart';

import '../constants.dart';

class InvoiceScreen extends StatefulWidget {
  final Widget? child;
  final double finalPrice;

  const InvoiceScreen({Key? key, this.child, required this.finalPrice})
      : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String priceText = "";
  GlobalKey? key;
  Uint8List? bytes;
  bool isCaptured = false;

  @override
  void initState() {
    getHttp();
    super.initState();
  }

  Future<void> capture(key) async {
    isCaptured = true;
    final bytes = await Utils.capture(key);
    setState(() {
      this.bytes = bytes;
    });
  }

  void getHttp() async {
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
        () {
          if (isCaptured == false && priceText != '') {
            capture(key);
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getHttp();

    return Scaffold(
      body: WidgetToImage(
        builder: (key) {
          this.key = key;
          return SafeArea(
            child: ListView(
              children: [
                // buildImage(bytes),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          InvoiceScreenHeader(taxNo: '3004687955200002'),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الرقم : 100200',
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: darkColor,
                                ),
                              ),
                              Text(
                                'التاريخ : 2020/09/05',
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: darkColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'العميل : حسني مبارك/محطة الفوزان السويد النخيل',
                            style: TextStyle(
                              fontSize: 19.0,
                              color: darkColor,
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: darkColor,
                          ),
                          ItemInfoTittels(),
                          Divider(
                            height: 2,
                            color: darkColor,
                          ),
                          ItemInfo(
                            itemName: 'MO 20W50 ZER\nزير اويل1لتر بلاستيك',
                            onePrice: '94',
                            piecesNo: '10',
                            total: '940.00',
                          ),
                          Divider(
                            height: 2,
                            color: darkColor,
                          ),
                          BillDtl(
                            price: '1,415.00',
                            tittle: 'الاجمالي',
                          ),
                          BillDtl(
                            price: '0.00',
                            tittle: 'الخصم',
                          ),
                          BillDtl(
                            price: '1,415.00',
                            tittle: 'الصافي',
                          ),
                          BillDtl(
                            price: '212.25',
                            tittle: 'ضريبة القيمة المضافة',
                          ),
                          BillDtl(
                            price: widget.finalPrice.toString(),
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

  Widget buildImage(Uint8List? bytes) =>
      bytes != null ? Image.memory(bytes) : Container();
}

class InvoiceScreenHeader extends StatelessWidget {
  const InvoiceScreenHeader({
    Key? key,
    required this.taxNo,
  }) : super(key: key);
  final String taxNo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: darkColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
              child: Text(
                'Petrol Naas مصنع بترول ناس',
                style: TextStyle(
                  fontSize: 20.0,
                  color: darkColor,
                ),
              ),
            ),
            Text(
              'الرقم الضريبي : $taxNo',
              style: TextStyle(
                fontSize: 16.0,
                color: darkColor,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: darkColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'دخال مبيعات',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: darkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/images/logo.png',
          width: 100,
        ),
      ],
    );
  }
}

class ItemInfoTittels extends StatelessWidget {
  const ItemInfoTittels({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'الاجمالي',
          style: TextStyle(
            fontSize: 19.0,
            color: darkColor,
          ),
        ),
        Text(
          'السعر',
          style: TextStyle(
            fontSize: 19.0,
            color: darkColor,
          ),
        ),
        Text(
          'الكمية',
          style: TextStyle(
            fontSize: 19.0,
            color: darkColor,
          ),
        ),
        Text(
          'الصنف',
          style: TextStyle(
            fontSize: 19.0,
            color: darkColor,
          ),
        ),
      ],
    );
  }
}

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key? key,
    required this.total,
    required this.onePrice,
    required this.piecesNo,
    required this.itemName,
  }) : super(key: key);
  final String total;
  final String onePrice;
  final String piecesNo;
  final String itemName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              total,
              style: TextStyle(
                fontSize: 19.0,
                color: darkColor,
              ),
            ),
            Text(
              onePrice,
              style: TextStyle(
                fontSize: 19.0,
                color: darkColor,
              ),
            ),
            Text(
              piecesNo,
              style: TextStyle(
                fontSize: 19.0,
                color: darkColor,
              ),
            ),
            Text(
              itemName,
              style: TextStyle(
                fontSize: 14.0,
                color: darkColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BillDtl extends StatelessWidget {
  const BillDtl({
    Key? key,
    required this.tittle,
    required this.price,
  }) : super(key: key);
  final String tittle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: darkColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: Text(
                price,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
        Text(
          tittle,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
