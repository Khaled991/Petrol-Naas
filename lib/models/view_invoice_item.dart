class ViewInvoiceItem {
  final String itemno;
  final String itemDesc;
  final double sellPrice;
  final int freeItemsQty;
  final int qty;

  ViewInvoiceItem({
    required this.itemno,
    required this.itemDesc,
    required this.sellPrice,
    required this.freeItemsQty,
    required this.qty,
  });

  @override
  String toString() {
    return 'Items(itemno: $itemno, itemDesc: $itemDesc, sellPrice1: $sellPrice, freeItemsQty: $freeItemsQty, qty: $qty)';
  }
}
