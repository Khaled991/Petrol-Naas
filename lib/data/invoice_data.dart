import 'package:petrol_naas/models/invoice.dart';

final List<Product> fakeProducts = List.generate(
  5,
  (int index) => Product(
    itemno: index,
    itemDesc: "itemDesc$index",
    unitPrice: 10 * (index + 10),
    sellPrice1: 100 * (index + 1),
    promotionQtyReq: 10 * (index + 1),
    promotionQtyFree: (index + 1),
  ),
);

// final List<Invoice> fakeInvoices = List.generate(
//   5,
//   (int index) => Invoice(
//     userno: (index).toString(),
//     salesman: (index).toString(),
//     custno: (index + 1).toString(),
//     whno: (index + 2).toString(),
//     payType: (index + 2).toString(),
//     accno: (index + 2).toString(),
//     notes: (index + 2).toString(),
//     items: fakeItems,
//   ),
// );

final List<Item> fakeItems = List.generate(
  5,
  (int index) => Item(itemno: index.toString(), qty: (index * 2).toString()),
);
