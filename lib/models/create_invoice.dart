import 'invoice_item.dart';

class CreateInvoice {
  String? userno;
  String? salesman;
  String? custno;
  String? whno;
  String? payType;
  String? accno;
  String? notes;
  String? sellPriceNo;
  List<InvoiceItem>? items;

  CreateInvoice({
    this.userno,
    this.salesman,
    this.custno,
    this.whno,
    this.payType,
    this.accno,
    this.notes,
    this.sellPriceNo,
    this.items,
  });

  @override
  String toString() {
    return 'CreateInvoice(userno: $userno, salesman: $salesman, custno: $custno, whno: $whno, payType: $payType, accno: $accno, notes: $notes, sellPriceNo: $sellPriceNo, items: $items)';
  }

  factory CreateInvoice.fromJson(Map<String, dynamic> json) => CreateInvoice(
        userno: json['userno'] as String?,
        salesman: json['Salesman'] as String?,
        custno: json['Custno'] as String?,
        whno: json['whno'] as String?,
        payType: json['PayType'] as String?,
        accno: json['Accno'] as String?,
        notes: json['notes'] as String?,
        sellPriceNo: json['sellPriceNo'] as String?,
        items: (json['Items'] as List<dynamic>?)
            ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'userno': double.parse(userno!),
        'Salesman': double.parse(salesman!),
        'Custno': double.parse(custno!),
        'whno': double.parse(whno!),
        'PayType': double.parse(payType!),
        'Accno': double.parse(accno!),
        'notes': notes,
        'sellPriceNo': sellPriceNo,
        'Items': items?.map((e) => e.toJson()).toList(),
      };

  CreateInvoice copyWith({
    String? userno,
    String? salesman,
    String? custno,
    String? whno,
    String? payType,
    String? accno,
    String? notes,
    String? sellPriceNo,
    List<InvoiceItem>? items,
  }) {
    return CreateInvoice(
      userno: userno ?? this.userno,
      salesman: salesman ?? this.salesman,
      custno: custno ?? this.custno,
      whno: whno ?? this.whno,
      payType: payType ?? this.payType,
      accno: accno ?? this.accno,
      notes: notes ?? this.notes,
      sellPriceNo: sellPriceNo ?? this.sellPriceNo,
      items: items ?? this.items,
    );
  }
}
