import 'package:json_annotation/json_annotation.dart';

part 'create_receipt.g.dart';

@JsonSerializable()
class CreateReceipt {
  String? userNo;
  String? cashAccNo;
  String? accNo;
  double? amount;
  String? description;

  CreateReceipt({
    this.userNo,
    this.cashAccNo,
    this.accNo,
    this.amount,
    this.description,
  });

  @override
  String toString() {
    return 'ReceiptVoucher(userNo: $userNo, cashAccNo: $cashAccNo, accNo: $accNo, amount: $amount, description: $description)';
  }

  factory CreateReceipt.fromJson(Map<String, dynamic> json) {
    return _$ReceiptVoucherFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReceiptVoucherToJson(this);

  CreateReceipt copyWith({
    String? userNo,
    String? cashAccNo,
    String? accNo,
    double? amount,
    String? description,
  }) {
    return CreateReceipt(
      userNo: userNo ?? this.userNo,
      cashAccNo: cashAccNo ?? this.cashAccNo,
      accNo: accNo ?? this.accNo,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }
}
