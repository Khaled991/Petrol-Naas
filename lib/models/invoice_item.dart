class InvoiceItem {
  String? itemno;
  int? qty;

  InvoiceItem({this.itemno, this.qty});

  @override
  String toString() => 'Items(itemno: $itemno, qty: $qty)';

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        itemno: json['itemno'] as String?,
        qty: json['qty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'itemno': itemno,
        'qty': qty,
      };

  InvoiceItem copyWith({
    String? itemno,
    int? qty,
  }) {
    return InvoiceItem(
      itemno: itemno ?? this.itemno,
      qty: qty ?? this.qty,
    );
  }
}
