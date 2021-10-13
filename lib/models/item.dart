class Item {
  String? itemno;
  String? itemDesc;
  double? sellPrice;
  double? avgCost;
  String? itemProd;
  int? promotionQtyReq;
  int? promotionQtyFree;
  bool? isFree;
  int? availableQty;

  Item({
    this.itemno,
    this.itemDesc,
    this.sellPrice,
    this.avgCost,
    this.itemProd,
    this.promotionQtyReq,
    this.promotionQtyFree,
    this.isFree,
    this.availableQty,
  });

  @override
  String toString() {
    return 'Items(itemno: $itemno, itemDesc: $itemDesc, sellPrice: $sellPrice, avgCost: $avgCost, itemProd: $itemProd, promotionQtyReq: $promotionQtyReq, promotionQtyFree: $promotionQtyFree), isFree: $isFree, availableQty: $availableQty';
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemno: json['itemno'] as String?,
      itemDesc: json['itemDesc'] as String?,
      sellPrice: double.parse(json['sellPrice']),
      avgCost: json['AvgCost']?.toDouble() ?? 0.0,
      itemProd: json['ItemProd'] as String?,
      promotionQtyReq: json['PromotionQtyReq'].toInt(),
      promotionQtyFree: json['PromotionQtyFree'].toInt(),
      isFree: json['isFree'] == '1',
      availableQty:
          fixNegativeQunatities(double.parse(json['availableQty']).toInt()),
    );
  }

  static int fixNegativeQunatities(int qty) => qty < 0 ? 0 : qty;

  Map<String, dynamic> toJson() => {
        'itemno': itemno,
        'itemDesc': itemDesc,
        'SellPrice': sellPrice,
        'AvgCost': avgCost,
        'ItemProd': itemProd,
        'PromotionQtyReq': promotionQtyReq,
        'PromotionQtyFree': promotionQtyFree,
        'isFree': isFree,
        'availableQty': availableQty,
      };

  Item copyWith({
    String? itemno,
    String? itemDesc,
    double? sellPrice,
    double? avgCost,
    String? itemProd,
    int? promotionQtyReq,
    int? promotionQtyFree,
    bool? isFree,
    int? availableQty,
  }) {
    return Item(
      itemno: itemno ?? this.itemno,
      itemDesc: itemDesc ?? this.itemDesc,
      sellPrice: sellPrice ?? this.sellPrice,
      avgCost: avgCost ?? this.avgCost,
      itemProd: itemProd ?? this.itemProd,
      promotionQtyReq: promotionQtyReq ?? this.promotionQtyReq,
      promotionQtyFree: promotionQtyFree ?? this.promotionQtyFree,
      isFree: isFree ?? this.isFree,
      availableQty: availableQty ?? this.availableQty,
    );
  }

  static int calcFreeQty({
    required int qty,
    required int promotionQtyReq,
    required int promotionQtyFree,
  }) {
    int freeQty = 0;
    if (promotionQtyFree != 0) {
      int free = qty ~/ promotionQtyReq;
      freeQty = free * promotionQtyFree;
    }
    return freeQty;
  }
}
