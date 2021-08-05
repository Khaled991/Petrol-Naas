import 'invoice_details.dart';
import 'invoice_header.dart';

class Invoice {
  InoviceHeader? header;
  List<InvoiceDetails>? details;

  Invoice({this.header, this.details});

  @override
  String toString() => 'Invoice(header: $header, details: $details)';

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        header: json['header'] == null
            ? null
            : InoviceHeader.fromJson(json['header'] as Map<String, dynamic>),
        details: (json['details'] as List<dynamic>?)
            ?.map((e) => InvoiceDetails.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'header': header?.toJson(),
        'details': details?.map((e) => e.toJson()).toList(),
      };

  Invoice copyWith({
    InoviceHeader? header,
    List<InvoiceDetails>? details,
  }) {
    return Invoice(
      header: header ?? this.header,
      details: details ?? this.details,
    );
  }
}
