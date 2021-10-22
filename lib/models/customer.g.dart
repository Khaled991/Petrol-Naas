// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    accNo: json['AccNo'] as String?,
    accName: json['AccName'] as String?,
    vaTnum: json['VATnum'],
    remainingBalance: (json['remainingBalance'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'AccNo': instance.accNo,
      'AccName': instance.accName,
      'VATnum': instance.vaTnum,
      'remainingBalance': instance.remainingBalance,
    };
