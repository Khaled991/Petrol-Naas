import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/widget/adjustable_qty.dart';
import 'package:petrol_naas/widget/header/custom_header.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import '../../constants.dart';

class AddItemScreen extends StatelessWidget {
  AddItemScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(
            scaffoldKey: _scaffoldKey,
            title: "إضافة صنف",
            showBackButton: true,
          ),
          Observer(builder: (_) {
            final itemsStore = context.watch<ItemsStore>();
            final itemsToRemoveStore =
                context.watch<AddedItemsToNewInvoiceStore>();
            final items = removeAddedItemsFromList(
                [...itemsStore.items], itemsToRemoveStore.items);

            return Expanded(
                child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final Item item = items[index];

                return AddItemExpansionPanel(
                  item: item,
                  idx: index,
                );
              },
            ));
          }),
        ],
      ),
    );
  }

  List<Item> removeAddedItemsFromList(
      List<Item> items, List<Item> itemsToRemove) {
    for (int i = 0; i < itemsToRemove.length; i++) {
      Item itemToRemove = itemsToRemove[i];
      items.remove(itemToRemove);
    }

    return items;
  }
}

class AddItemExpansionPanel extends StatefulWidget {
  final Item item;
  final int idx;

  const AddItemExpansionPanel({Key? key, required this.item, required this.idx})
      : super(key: key);

  @override
  _AddItemExpansionPanelState createState() => _AddItemExpansionPanelState();
}

class _AddItemExpansionPanelState extends State<AddItemExpansionPanel> {
  int qty = 1;
  bool _expanded = false;
  late bool disabled;
  late bool hasPromotionQtyFree;

  @override
  void initState() {
    super.initState();
    disabled = widget.item.availableQty! <= 0;
    hasPromotionQtyFree =
        widget.item.promotionQtyFree! > 0 && widget.item.promotionQtyReq! > 0;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: const EdgeInsets.all(0.0),
      children: [
        _renderAddItemExpansionPanel(),
      ],
      elevation: 0,
      dividerColor: Colors.grey,
      animationDuration: Duration(milliseconds: 250),
      expansionCallback: (panelIndex, isExpanded) {
        _expanded = !_expanded;
        setState(() {});
      },
    );
  }

  ExpansionPanel _renderAddItemExpansionPanel() {
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) {
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.item.itemDesc!,
                style: TextStyle(
                  color: disabled ? Colors.red.shade200 : primaryColor,
                  fontSize: 18.0,
                ),
              ),
              Text('رقم الصنف : ${widget.item.itemno}'),
            ],
          ),
        );
      },
      body: Container(
        padding: const EdgeInsets.only(right: 10.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الكمية المتاحة : ${widget.item.availableQty}'),
            Text('السعر : ${widget.item.sellPrice!.toStringAsFixed(2)}'),
            if (!disabled)
              AdjustableQuantity(
                key: Key(widget.item.itemno!),
                setQty: setQty,
                qty: qty,
                maxQty: widget.item.availableQty!,
                isInline: true,
              ),
            Text(
              'الاجمالي : ${(widget.item.sellPrice! * qty).toStringAsFixed(2)}',
            ),
            if (hasPromotionQtyFree) _renderFreeQtyWidget(),
            _addButton(disabled: disabled),
            // _addButton(disabled: (widget.item.availableQty ?? 0) > 0),
          ],
        ),
      ),
      isExpanded: _expanded,
      canTapOnHeader: true,
    );
  }

  void setQty(int newQty) {
    setState(() {
      qty = newQty;
    });
  }

  Widget _renderFreeQtyWidget() {
    return Row(
      children: [
        Text('الكمية المجانية : لكل '),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
          ),
          child: Text(widget.item.promotionQtyReq!.toString()),
        ),
        Text(' كمية مجانية '),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
          ),
          child: Text(widget.item.promotionQtyFree!.toString()),
        ),
      ],
    );
  }

  Widget _addButton({bool disabled = false}) {
    return OutlinedButton.icon(
      onPressed: disabled ? null : onPressAddItem,
      icon: Icon(
        Icons.add,
        size: 20,
      ),
      label: Text(
        "إضافة",
        style: TextStyle(height: 1.2, fontSize: 13.0),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        primary: Colors.greenAccent[400],
        onSurface: Colors.grey,
        side: BorderSide(
          color: disabled ? Colors.grey.shade300 : Colors.greenAccent.shade400,
          width: 0.75,
        ),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  void onPressAddItem() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.addItem(widget.item, qty);

    Navigator.of(context).pop();
  }
}
