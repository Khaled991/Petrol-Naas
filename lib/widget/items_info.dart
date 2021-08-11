import 'package:flutter/material.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';

class ItemsInfo extends StatefulWidget {
  final List<ViewInvoiceItem> items;

  const ItemsInfo({
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
                DataCell(Text((item.sellPrice! * item.qty!).toString())),
                DataCell(Text(item.sellPrice.toString())),
                DataCell(Text(item.qty.toString())),
                DataCell(Text(item.itemDesc!)),
              ],
            ),
          )
          .toList(),
    );
  }
}
