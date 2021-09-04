import 'package:flutter/material.dart';
import 'package:petrol_naas/models/view_invoice_item.dart';

import '../constants.dart';

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
    return Column(
      children: widget.items
          .map((ViewInvoiceItem item) => Column(
                children: [
                  Table(
                    contentText: item.itemno!,
                    title: 'رقم الصنف',
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 28),
                    child: Table(
                      contentText: item.itemDesc!,
                      title: 'اسم الصنف',
                    ),
                  ),
                  Table(
                    contentText: item.sellPrice.toString(),
                    title: 'سعر',
                  ),
                  Table(
                    contentText: (item.qty! + item.freeItemsQty!).toString(),
                    title: 'الكمية',
                  ),
                  Table(
                    contentText: (item.freeItemsQty!).toString(),
                    title: 'القطع المجانية',
                  ),
                  Table(
                    contentText: (item.sellPrice! * item.qty!).toString(),
                    title: 'الاجمالي',
                  ),
                  Divider(
                    height: 20.0,
                    color: darkColor,
                    thickness: 2.0,
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class Table extends StatelessWidget {
  final String title;
  final String contentText;
  const Table({
    Key? key,
    required this.title,
    required this.contentText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Expanded(
          child: Text(contentText, textAlign: TextAlign.left),
        ),
      ],
    );
  }
}
