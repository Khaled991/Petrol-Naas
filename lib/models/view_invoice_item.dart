class ViewInvoiceItem {
  String? itemno;
  String? itemDesc;
  double? sellPrice;
  int? freeItemsQty;
  int? qty;

  ViewInvoiceItem({
    this.itemno,
    this.itemDesc,
    this.sellPrice,
    this.freeItemsQty,
    this.qty,
  });

  @override
  String toString() {
    return 'ViewInvoiceItem(itemno: $itemno, itemDesc: $itemDesc, sellPrice: $sellPrice, freeItemsQty: $freeItemsQty, qty: $qty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViewInvoiceItem &&
        other.itemno == itemno &&
        other.itemDesc == itemDesc &&
        other.sellPrice == sellPrice &&
        other.freeItemsQty == freeItemsQty &&
        other.qty == qty;
  }

  @override
  int get hashCode {
    return itemno.hashCode ^
        itemDesc.hashCode ^
        sellPrice.hashCode ^
        freeItemsQty.hashCode ^
        qty.hashCode;
  }
}
