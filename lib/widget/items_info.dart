import 'package:flutter/material.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';

class ItemsInfoTable extends StatefulWidget {
  final List<ViewInvoiceItem> items;

  const ItemsInfoTable({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<ItemsInfoTable> createState() => _ItemsInfoTableState();
}

class _ItemsInfoTableState extends State<ItemsInfoTable> {
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
                DataCell(Text((item.sellPrice! * item.qty!).toString())),
                DataCell(Text(item.sellPrice.toString())),
                DataCell(Text((item.qty! + item.freeItemsQty!).toString())),
                DataCell(Text(item.itemDesc!)),
              ],
            ),
          )
          .toList(),
    );
  }
}
