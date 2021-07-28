// class Invoice {
//   final String name;
//   final int payType;
//   final String custName;
//   final String custno;
//   final List<InvoiceProduct> products;
//   final String note;
//   final DateTime year = DateTime.now();
//   final String freeQty;

//   Invoice({
//     required this.name,
//     required this.payType,
//     required this.custName,
//     required this.custno,
//     required this.products,
//     required this.note,
//     required this.freeQty,
//   });
// }

// class InvoiceProduct {
//   late Product product;
//   late int qty;
// }

class Product {
  final int itemno;
  final String itemDesc;
  final double unitPrice;
  final double sellPrice1;
  final int promotionQtyReq;
  final int promotionQtyFree;

  Product({
    required this.itemno,
    required this.itemDesc,
    required this.unitPrice,
    required this.sellPrice1,
    required this.promotionQtyReq,
    required this.promotionQtyFree,
  });
}

class CreateInvoiceModel {
  String userno;
  String salesman;
  String custno;
  String whno;
  String payType;
  String accno;
  String notes;
  List<Item> items = <Item>[];

  CreateInvoiceModel({
    this.userno = "",
    this.salesman = "",
    this.custno = "",
    this.whno = "",
    this.payType = "",
    this.accno = "",
    this.notes = "",
  });
}

class Item {
  String itemno;
  String qty;

  Item({
    this.itemno = "",
    this.qty = "",
  });
}
