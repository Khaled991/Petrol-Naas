import 'package:flutter/material.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';

import '../../constants.dart';

class InvoiceItemsTable extends StatelessWidget {
  List<ViewInvoiceItem> items;
  void Function(int) onPressDeleteItemFromInvoice;

  InvoiceItemsTable(
      {Key? key,
      required this.items,
      required this.onPressDeleteItemFromInvoice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: primaryColor, width: 2.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: DataTable(
              columns: [
                DataColumn(label: Text('الرقم')),
                DataColumn(label: Text('اسم الصنف')),
                DataColumn(label: Text('الكمية')),
                DataColumn(label: Text('سعر')),
                DataColumn(label: Text('الاجمالي')),
                DataColumn(label: Text('القطع المجانية')),
                DataColumn(label: Text('')),
              ],
              rows: List.generate(
                items.length,
                (int index) {
                  final ViewInvoiceItem item = items[index];
                  return DataRow(
                    cells: [
                      DataCell(Text(item.itemno!)),
                      DataCell(Text(item.itemDesc!)),
                      DataCell(Text(item.qty.toString())),
                      DataCell(Text(item.sellPrice.toString())),
                      DataCell(Text((item.sellPrice! * item.qty!).toString())),
                      DataCell(Text(item.freeItemsQty.toString())),
                      DataCell(
                        IconButton(
                          onPressed: () => onPressDeleteItemFromInvoice(index),
                          icon: Icon(
                            Icons.clear,
                            size: 25.0,
                            color: redColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
