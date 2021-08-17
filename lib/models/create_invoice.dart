import 'invoice_item.dart';

class CreateInvoice {
  String? userno;
  String? salesman;
  String? custno;
  String? whno;
  String? payType;
  String? accno;
  String? notes;
  List<InvoiceItem>? items;

  CreateInvoice({
    this.userno,
    this.salesman,
    this.custno,
    this.whno,
    this.payType,
    this.accno,
    this.notes,
    this.items,
  });

  @override
  String toString() {
    return 'CreateInvoice(userno: $userno, salesman: $salesman, custno: $custno, whno: $whno, payType: $payType, accno: $accno, notes: $notes, items: $items)';
  }

  factory CreateInvoice.fromJson(Map<String, dynamic> json) => CreateInvoice(
        userno: json['userno'] as String?,
        salesman: json['Salesman'] as String?,
        custno: json['Custno'] as String?,
        whno: json['whno'] as String?,
        payType: json['PayType'] as String?,
        accno: json['Accno'] as String?,
        notes: json['notes'] as String?,
        items: (json['Items'] as List<dynamic>?)
            ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'userno': userno,
        'Salesman': salesman,
        'Custno': custno,
        'whno': whno,
        'PayType': payType,
        'Accno': accno,
        'notes': notes,
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
      items: items ?? this.items,
    );
  }
}
