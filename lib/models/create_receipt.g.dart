// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReceipt _$ReceiptVoucherFromJson(Map<String, dynamic> json) {
  return CreateReceipt(
    userNo: json['userNo'] as String?,
    cashAccNo: json['cashAccNo'] as String?,
    accNo: json['accNo'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$ReceiptVoucherToJson(CreateReceipt instance) =>
    <String, dynamic>{
      'userNo': instance.userNo,
      'cashAccNo': instance.cashAccNo,
      'accNo': instance.accNo,
      'amount': instance.amount,
      'description': instance.description,
    };
