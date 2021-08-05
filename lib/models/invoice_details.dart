class InvoiceDetails {
  String? invno;
  int? qty;
  String? unitPrice;
  String? itemDesc;
  String? promotionQtyReq;
  String? promotionQtyFree;
  int? totalPrice;
  int? freeQty;

  InvoiceDetails({
    this.invno,
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
    return 'Details(invno: $invno, qty: $qty, unitPrice: $unitPrice, itemDesc: $itemDesc, promotionQtyReq: $promotionQtyReq, promotionQtyFree: $promotionQtyFree, totalPrice: $totalPrice, freeQty: $freeQty)';
  }

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) => InvoiceDetails(
        invno: json['Invno'] as String?,
        qty: json['QTY'] as int?,
        unitPrice: json['unitPrice'] as String?,
        itemDesc: json['itemDesc'] as String?,
        promotionQtyReq: json['PromotionQtyReq'] as String?,
        promotionQtyFree: json['PromotionQtyFree'] as String?,
        totalPrice: json['totalPrice'] as int?,
        freeQty: json['freeQty'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'Invno': invno,
        'QTY': qty,
        'unitPrice': unitPrice,
        'itemDesc': itemDesc,
        'PromotionQtyReq': promotionQtyReq,
        'PromotionQtyFree': promotionQtyFree,
        'totalPrice': totalPrice,
        'freeQty': freeQty,
      };

  InvoiceDetails copyWith({
    String? invno,
    int? qty,
    String? unitPrice,
    String? itemDesc,
    String? promotionQtyReq,
    String? promotionQtyFree,
    int? totalPrice,
    int? freeQty,
  }) {
    return InvoiceDetails(
      invno: invno ?? this.invno,
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
