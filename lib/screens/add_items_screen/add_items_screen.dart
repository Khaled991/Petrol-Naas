import 'package:flutter/material.dart';

import 'package:petrol_naas/mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'package:petrol_naas/mobx/items/items.dart';
import 'package:petrol_naas/models/item.dart';
import 'package:petrol_naas/models/state_node.dart';
import 'package:petrol_naas/widget/adjustable_qty.dart';
import 'package:petrol_naas/widget/header/custom_header.dart';
import 'package:petrol_naas/widget/screen_layout.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import '../../constants.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late StateNode<bool> isSearchingStateNode;
  late StateNode<String> searchValueStateNode;
  final GlobalKey addItemKey = GlobalKey();

  List<Item> filteredItems = [];

  final TextEditingController _searchTextFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    isSearchingStateNode = StateNode<bool>(false, setState);
    searchValueStateNode = StateNode<String>("", setState);
    _searchTextFieldController.addListener(handleChangeSearchField);
  }

  void initializeItemExpansionPanelsData() {
    final itemsStore = context.read<ItemsStore>();
    final itemsToRemoveStore = context.watch<AddedItemsToNewInvoiceStore>();
    filteredItems = removeAddedItemsFromList(
        [...itemsStore.items], itemsToRemoveStore.items);
  }

  void handleChangeSearchField() {
    searchValueStateNode.setValue(_searchTextFieldController.text);
    setState(() {});
    print(_searchTextFieldController.text);
    // filteredItems = filteredItems
    //     .where((Item item) =>
    //         item.itemDesc.contains(_searchTextFieldController.text))
    //     .toList();
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();
    super.dispose();
  }

  List<Item> getSearchResult() {
    final List<Item> filteredItemsSearchResult = [];

    if (_searchTextFieldController.text == "") return filteredItems;

    for (int i = 0; i < filteredItems.length; i++) {
      Item item = filteredItems[i];
      bool searchValueMatchesItemName = item.itemDesc!
          .toLowerCase()
          .contains(searchValueStateNode.value.toLowerCase());
      bool searchValueMatchesItemNo = item.itemno!
          .toLowerCase()
          .contains(searchValueStateNode.value.toLowerCase());

      print("itemDesc:${item.itemDesc!}");
      print("searchValueMatchesItemName:$searchValueMatchesItemName");
      print("itemno:${item.itemno!}");
      print("searchValueMatchesItemNo:$searchValueMatchesItemNo");

      if (searchValueMatchesItemName || searchValueMatchesItemNo) {
        filteredItemsSearchResult.add(item);
      }
    }

    print("searchValueStateNode.value:${searchValueStateNode.value}");
    return filteredItemsSearchResult;
  }

  @override
  Widget build(BuildContext context) {
    initializeItemExpansionPanelsData();

    return ScreenLayout(
      title: "إضافة صنف",
      showBackButton: true,
      trailing: HeaderTrailingModel(icon: Icons.search, onPressed: () {}),
      isSearchingStateNode: isSearchingStateNode,
      searchTextFieldController: _searchTextFieldController,
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemCount: getSearchResult().length,
        itemBuilder: (BuildContext context, int index) {
          final Item item = getSearchResult()[index];
          return AddItemExpansionPanel(
            item: item,
          );
        },
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

  const AddItemExpansionPanel({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _AddItemExpansionPanelState createState() => _AddItemExpansionPanelState();
}

class _AddItemExpansionPanelState extends State<AddItemExpansionPanel> {
  bool isExpanded = false;

  int qty = 1;
  late bool disabled;
  late bool hasPromotionQtyFree;

  @override
  void initState() {
    super.initState();

    final bool hasNoAvailableQty = widget.item.availableQty! <= 0;
    final bool hasNoSellPrice = widget.item.sellPrice! <= 0;
    disabled = hasNoAvailableQty || hasNoSellPrice;

    hasPromotionQtyFree =
        widget.item.promotionQtyFree! > 0 && widget.item.promotionQtyReq! > 0;
  }

  void toggleExpansionState(int index) {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: const EdgeInsets.all(0.0),
      children: [
        // for (int i = 0; i < widget.itemExpansionPanelData.length; i++)
        _renderAddItemExpansionPanel(),
        // _renderAddItemExpansionPanel(),
      ],
      elevation: 0,
      dividerColor: Colors.grey.shade200,
      animationDuration: Duration(milliseconds: 250),
      expansionCallback: (panelIndex, isExpanded) {
        toggleExpansionState(panelIndex);
      },
    );
  }

  ExpansionPanel _renderAddItemExpansionPanel() {
    // final Item item = widget.itemExpansionPanelData[i].item;
    // final bool isExpanded = widget.itemExpansionPanelData[i].expanded;

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
                item: widget.item,
                isInline: true,
              ),
            Text(
              'الاجمالي : ${(widget.item.sellPrice! * qty).toStringAsFixed(2)}',
            ),
            //TODO:Enable next line
            // if (hasPromotionQtyFree) _renderFreeQtyWidget(),
            _addButton(disabled: disabled),
            // _addButton(disabled: (widget.item.availableQty ?? 0) > 0),
          ],
        ),
      ),
      isExpanded: isExpanded,
      canTapOnHeader: true,
    );
  }

  void setQty(int newQty) {
    setState(() {
      qty = newQty;
    });
  }

  // Widget _renderFreeQtyWidget() {
  //   return Row(
  //     children: [
  //       Text('الكمية المجانية : لكل '),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 6),
  //         decoration: BoxDecoration(
  //           border: Border.all(color: primaryColor),
  //           borderRadius: BorderRadius.all(Radius.circular(7.5)),
  //         ),
  //         child: Text(widget.item.promotionQtyReq!.toString()),
  //       ),
  //       Text(' كمية مجانية '),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 6),
  //         decoration: BoxDecoration(
  //           border: Border.all(color: primaryColor),
  //           borderRadius: BorderRadius.all(Radius.circular(7.5)),
  //         ),
  //         child: Text(widget.item.promotionQtyFree!.toString()),
  //       ),
  //     ],
  //   );
  // }

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
