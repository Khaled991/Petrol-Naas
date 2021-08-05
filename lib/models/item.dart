class Item {
  String? itemno;
  String? itemDesc;
  double? sellPrice1;
  double? avgCost;
  String? itemProd;
  int? promotionQtyReq;
  int? promotionQtyFree;

  Item({
    this.itemno,
    this.itemDesc,
    this.sellPrice1,
    this.avgCost,
    this.itemProd,
    this.promotionQtyReq,
    this.promotionQtyFree,
  });

  @override
  String toString() {
    return 'Items(itemno: $itemno, itemDesc: $itemDesc, sellPrice1: $sellPrice1, avgCost: $avgCost, itemProd: $itemProd, promotionQtyReq: $promotionQtyReq, promotionQtyFree: $promotionQtyFree)';
  }

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemno: json['itemno'] as String?,
        itemDesc: json['itemDesc'] as String?,
        sellPrice1: json['SellPrice1']?.toDouble() ?? 0.0,
        avgCost: json['AvgCost']?.toDouble() ?? 0.0,
        itemProd: json['ItemProd'] as String?,
        promotionQtyReq: json['PromotionQtyReq'] as int?,
        promotionQtyFree: json['PromotionQtyFree'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'itemno': itemno,
        'itemDesc': itemDesc,
        'SellPrice1': sellPrice1,
        'AvgCost': avgCost,
        'ItemProd': itemProd,
        'PromotionQtyReq': promotionQtyReq,
        'PromotionQtyFree': promotionQtyFree,
      };

  Item copyWith({
    String? itemno,
    String? itemDesc,
    double? sellPrice1,
    double? avgCost,
    String? itemProd,
    int? promotionQtyReq,
    int? promotionQtyFree,
  }) {
    return Item(
      itemno: itemno ?? this.itemno,
      itemDesc: itemDesc ?? this.itemDesc,
      sellPrice1: sellPrice1 ?? this.sellPrice1,
      avgCost: avgCost ?? this.avgCost,
      itemProd: itemProd ?? this.itemProd,
      promotionQtyReq: promotionQtyReq ?? this.promotionQtyReq,
      promotionQtyFree: promotionQtyFree ?? this.promotionQtyFree,
    );
  }
}
