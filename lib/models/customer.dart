import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
	@JsonKey(name: 'AccNo') 
	String? accNo;
	@JsonKey(name: 'AccName') 
	String? accName;
	@JsonKey(name: 'VATnum') 
	dynamic vaTnum;
	double? remainingBalance;

	Customer({this.accNo, this.accName, this.vaTnum, this.remainingBalance});

	@override
	String toString() {
		return 'Customer(accNo: $accNo, accName: $accName, vaTnum: $vaTnum, remainingBalance: $remainingBalance)';
	}

	factory Customer.fromJson(Map<String, dynamic> json) {
		return _$CustomerFromJson(json);
	}

	Map<String, dynamic> toJson() => _$CustomerToJson(this);

		Customer copyWith({
		String? accNo,
		String? accName,
		dynamic vaTnum,
		double? remainingBalance,
	}) {
		return Customer(
			accNo: accNo ?? this.accNo,
			accName: accName ?? this.accName,
			vaTnum: vaTnum ?? this.vaTnum,
			remainingBalance: remainingBalance ?? this.remainingBalance,
		);
	}
}
