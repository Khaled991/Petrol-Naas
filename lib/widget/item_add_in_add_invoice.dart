import 'package:flutter/material.dart';
import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import 'adjustable_qty.dart';

class ItemAddedInAddInvoice extends StatefulWidget {
  final Item item;
  final int qty;
  final int index;

  const ItemAddedInAddInvoice({
    Key? key,
    required this.item,
    this.qty = 0,
    required this.index,
  }) : super(key: key);

  @override
  _ItemAddedInAddInvoiceState createState() => _ItemAddedInAddInvoiceState();
}

class _ItemAddedInAddInvoiceState extends State<ItemAddedInAddInvoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(right: 15.0, top: 5.0, bottom: 5.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.itemDesc!,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPressRemoveItem,
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Text("رقم الصنف : ${widget.item.itemno!}"),
              Text("الكمية المتاحة : ${widget.item.availableQty!}"),
              Text("${widget.item.sellPrice!} : السعر"),
              Text(
                  "${calculateTotalPrice(widget.item.sellPrice!, widget.qty)} : الاجمالي"),
              if (widget.item.promotionQtyFree != 0 &&
                  widget.item.promotionQtyReq != 0)
                Text(
                  "الكمية المجانية : ${Item.calcFreeQty(
                    qty: widget.qty,
                    promotionQtyFree: widget.item.promotionQtyFree!,
                    promotionQtyReq: widget.item.promotionQtyReq!,
                  )}",
                ),
            ],
          ),
          Positioned(
            bottom: 5.0,
            left: 15.0,
            child: AdjustableQuantity(
              setQty: setQty,
              qty: widget.qty,
              maxQty: widget.item.availableQty!,
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalPrice(double price, int qty) => price * qty;

  void setQty(int newQty) {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.editQuantityByIndex(newQty, widget.index);

    setState(() {
      final addedItemsToNewInvoiceStore =
          context.read<AddedItemsToNewInvoiceStore>();
      addedItemsToNewInvoiceStore.editQuantityByIndex(newQty, widget.index);
    });
  }

  void onPressRemoveItem() {
    final addedItemsToNewInvoiceStore =
        context.read<AddedItemsToNewInvoiceStore>();
    addedItemsToNewInvoiceStore.removeItemByIndex(widget.index);
  }
}
