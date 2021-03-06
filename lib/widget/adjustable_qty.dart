import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petrol_naas/models/item.dart';

import '../constants.dart';

class AdjustableQuantity extends StatefulWidget {
  final void Function(int) setQty;
  final int qty;
  final TextEditingController? qtyTextFieldController;
  final Item item;
  final bool isInline;

  AdjustableQuantity({
    Key? key,
    required this.setQty,
    required this.qty,
    required this.item,
    this.isInline = false,
  })  : qtyTextFieldController = TextEditingController(text: qty.toString()),
        super(key: key);

  @override
  _AdjustableQuantityState createState() => _AdjustableQuantityState();
}

class _AdjustableQuantityState extends State<AdjustableQuantity> {
  late FocusNode qtyFocusNode;

  @override
  void initState() {
    super.initState();
    qtyFocusNode = FocusNode();
  }

  @override
  void dispose() {
    qtyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isInline
        ? renderInlineAdjustableQty()
        : Column(
            children: [
              Text("الكمية"),
              renderAdjustableQty(),
            ],
          );
  }

  Widget renderInlineAdjustableQty() {
    return Row(
      children: [
        Text("الكمية : "),
        renderAdjustableQty(),
      ],
    );
  }

  Widget renderAdjustableQty() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: primaryColor),
              ),
            ),
            child: IconButton(
              constraints: BoxConstraints(),
              iconSize: 18.0,
              onPressed: handleClickAddQty,
              icon: Icon(
                Icons.add,
              ),
            ),
          ),
          SizedBox(
            width: 50.0,
            // height: 30.0,
            child: TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              enabled: false, //TODO: enable textfield and fix its bugs
              focusNode: qtyFocusNode,
              controller: widget.qtyTextFieldController,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (String newQty) {
                changeInputQtyAndFocusAgain(int.parse(newQty));
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.all(0.0),
              ),
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: primaryColor),
              ),
            ),
            child: IconButton(
              constraints: BoxConstraints(),
              iconSize: 18.0,
              onPressed: handleClickSubtraceQty,
              icon: Icon(
                Icons.remove,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleClickAddQty() => handleChangeQty(widget.qty + 1);

  void handleClickSubtraceQty() => handleChangeQty(widget.qty - 1);

  void handleChangeQty(int newQty) {
    final int freeQty = Item.calcFreeQty(
        qty: newQty,
        promotionQtyReq: widget.item.promotionQtyReq!,
        promotionQtyFree: widget.item.promotionQtyFree!);
    final int newQtyWithFreeQty = newQty + freeQty;

    if (newQtyWithFreeQty > widget.item.availableQty!) {
      int maxAvailableQtyToBuy = widget.item.availableQty! - freeQty;
      changeInputQtyAndFocusAgain(maxAvailableQtyToBuy);
      return showSnackBar("لا يمكنك تحديد كمية اكثر من المتوفرة");
    } else if (newQty < 1) {
      changeInputQtyAndFocusAgain(1);

      showSnackBar("لا يمكنك تحديد كمية أقل من 1");
      // FocusScope.of(context).requestFocus(qtyFocusNode);

      return;
    }
    changeInputQtyAndFocusAgain(newQty);
  }

  void changeInputQtyAndFocusAgain(int newQty) {
    final String newQtyAsString = newQty.toString();

    widget.setQty(newQty);
    // FocusScope.of(context).requestFocus(qtyFocusNode);
    widget.qtyTextFieldController!.value = TextEditingValue(
      text: newQtyAsString,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newQtyAsString.length),
      ),
    );
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 1),
    ));
  }
}
