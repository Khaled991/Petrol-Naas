// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptVoucher _$ReceiptVoucherFromJson(Map<String, dynamic> json) {
  return ReceiptVoucher(
    userNo: json['userNo'] as String?,
    cashAccNo: json['cashAccNo'] as String?,
    accNo: json['accNo'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$ReceiptVoucherToJson(ReceiptVoucher instance) =>
    <String, dynamic>{
      'userNo': instance.userNo,
      'cashAccNo': instance.cashAccNo,
      'accNo': instance.accNo,
      'amount': instance.amount,
      'description': instance.description,
    };
