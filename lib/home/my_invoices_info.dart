import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';
import 'package:petrol_naas/widget/widget_to_image.dart';
import '../constants.dart';

class MyInvoicesInfo extends StatefulWidget {
  final Widget? child;
  final double finalPrice = 0.0;
  final String invno;

  const MyInvoicesInfo({
    Key? key,
    this.child,
    this.invno = "108639",
  }) : super(key: key);

  @override
  State<MyInvoicesInfo> createState() => _MyInvoicesInfoState();
}

class _MyInvoicesInfoState extends State<MyInvoicesInfo> {
  String priceText = "";
  bool isCaptured = false;

  @override
  void initState() {
    getInvoiceData();
    // getTafqeet();
    super.initState();
  }

  void getInvoiceData() async {
    try {
      Response response = await Dio().post(
          'http://192.168.1.2/petrolnaas/public/api/invoice/${widget.invno}');
      final jsonResponse = response.data;
      print(jsonResponse);
      // setState(() {
      //   // this.priceText = priceText;
      // });
    } catch (e) {
      print(e);
    }
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    getTafqeet();

    return Scaffold(
      appBar: AppBar(
        title: Text('الفاتورة'),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        shadowColor: Color(0x003d3d3d),
      ),
      body: WidgetToImage(
        builder: (key) {
          return SafeArea(
            child: Container(
              color: Colors.grey[50],
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      height: 2,
                      color: darkColor,
                    ),
                  ),
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
                            ItemsInfo(
                              items: [],
                            ),
                            Divider(
                              height: 2,
                              color: darkColor,
                            ),
                            InvoiceDetailsPrices(
                              price: '0.0',
                              tittle: 'الاجمالي',
                            ),
                            InvoiceDetailsPrices(
                              price: '0.00',
                              tittle: 'الخصم',
                            ),
                            InvoiceDetailsPrices(
                              price: '0.0',
                              tittle: 'الصافي',
                            ),
                            InvoiceDetailsPrices(
                              price: '0.0',
                              tittle: 'ضريبة القيمة المضافة',
                            ),
                            InvoiceDetailsPrices(
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
            ),
          );
        },
      ),
    );
  }
}

//===========================================Items Info===========================================

class ItemsInfo extends StatefulWidget {
  final List<ViewInvoiceItem> items;

  ItemsInfo({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<ItemsInfo> createState() => _ItemsInfoState();
}

class _ItemsInfoState extends State<ItemsInfo> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      horizontalMargin: 10.0,
      columns: [
        DataColumn(label: Text('الاجمالي')),
        DataColumn(label: Text('سعر')),
        DataColumn(label: Text('الكمية')),
        DataColumn(label: Text('اسم الصنف')),
      ],
      rows: widget.items
          .map(
            (ViewInvoiceItem item) => DataRow(
              cells: [
                DataCell(Text((item.sellPrice * item.qty).toString())),
                DataCell(Text(item.sellPrice.toString())),
                DataCell(Text(item.qty.toString())),
                DataCell(Text(item.itemDesc)),
              ],
            ),
          )
          .toList(),
    );
  }
}

//===========================================invoice details prices===========================================

class InvoiceDetailsPrices extends StatelessWidget {
  const InvoiceDetailsPrices({
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

//===========================================header===========================================

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
