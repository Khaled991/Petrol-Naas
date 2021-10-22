class InvoiceItem {
  String? itemno;
  int? qty;
  int? freeQty;

  InvoiceItem({this.itemno, this.qty, this.freeQty});

  @override
  String toString() => 'Items(itemno: $itemno, qty: $qty,freeQty: $freeQty)';

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        itemno: json['itemno'] as String?,
        qty: json['qty'] as int?,
        freeQty: json['freeQty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'itemno': itemno,
        'qty': qty,
        'freeQty': freeQty,
      };

  InvoiceItem copyWith({
    String? itemno,
    int? qty,
    int? freeQty,
  }) {
    return InvoiceItem(
      itemno: itemno ?? this.itemno,
      qty: qty ?? this.qty,
      freeQty: freeQty ?? this.freeQty,
    );
  }
}
