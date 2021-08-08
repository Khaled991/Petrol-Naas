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
}
