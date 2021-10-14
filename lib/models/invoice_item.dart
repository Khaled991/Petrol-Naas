class InvoiceItem {
  String? itemno;
  int? qty;
  double? price;

  InvoiceItem({this.itemno, this.qty, this.price});

  @override
  String toString() => 'Items(itemno: $itemno, qty: $qty,price: $price)';

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
    double? price,
  }) {
    return InvoiceItem(
      itemno: itemno ?? this.itemno,
      qty: qty ?? this.qty,
      price: price ?? this.price,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvoiceItem &&
        other.itemno == itemno &&
        other.qty == qty &&
        other.price == price;
  }

  @override
  int get hashCode => itemno.hashCode ^ qty.hashCode ^ price.hashCode;
}
