class InvoiceDetails {
  String? itemno;
  int? qty;
  String? unitPrice;
  String? itemDesc;
  int? promotionQtyReq;
  int? promotionQtyFree;
  double? totalPrice;
  int? freeQty;

  InvoiceDetails({
    this.itemno,
    this.qty,
    this.unitPrice,
    this.itemDesc,
    this.promotionQtyReq,
    this.promotionQtyFree,
    this.totalPrice,
    this.freeQty,
  });

  @override
  String toString() {
    return 'Details(itemno: $itemno, qty: $qty, unitPrice: $unitPrice, itemDesc: $itemDesc, promotionQtyReq: $promotionQtyReq, promotionQtyFree: $promotionQtyFree, totalPrice: $totalPrice, freeQty: $freeQty)';
  }

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) => InvoiceDetails(
        itemno: json['itemno'] as String?,
        qty: json['QTY'] as int?,
        unitPrice: json['unitPrice'] as String?,
        itemDesc: json['itemDesc'] as String?,
        promotionQtyReq: double.parse(json['PromotionQtyReq']).toInt(),
        promotionQtyFree: double.parse(json['PromotionQtyFree']).toInt(),
        totalPrice: json['totalPrice'].toDouble(),
        freeQty: json['freeQty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'itemno': itemno,
        'QTY': qty,
        'unitPrice': unitPrice,
        'itemDesc': itemDesc,
        'PromotionQtyReq': promotionQtyReq,
        'PromotionQtyFree': promotionQtyFree,
        'totalPrice': totalPrice,
        'freeQty': freeQty,
      };

  InvoiceDetails copyWith({
    String? itemno,
    int? qty,
    String? unitPrice,
    String? itemDesc,
    int? promotionQtyReq,
    int? promotionQtyFree,
    double? totalPrice,
    int? freeQty,
  }) {
    return InvoiceDetails(
      itemno: itemno ?? this.itemno,
      qty: qty ?? this.qty,
      unitPrice: unitPrice ?? this.unitPrice,
      itemDesc: itemDesc ?? this.itemDesc,
      promotionQtyReq: promotionQtyReq ?? this.promotionQtyReq,
      promotionQtyFree: promotionQtyFree ?? this.promotionQtyFree,
      totalPrice: totalPrice ?? this.totalPrice,
      freeQty: freeQty ?? this.freeQty,
    );
  }
}
