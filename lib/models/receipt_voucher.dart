import 'package:json_annotation/json_annotation.dart';

part 'receipt_voucher.g.dart';

@JsonSerializable()
class ReceiptVoucher {
	String? userNo;
	String? cashAccNo;
	String? accNo;
	double? amount;
	String? description;

	ReceiptVoucher({
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

	factory ReceiptVoucher.fromJson(Map<String, dynamic> json) {
		return _$ReceiptVoucherFromJson(json);
	}

	Map<String, dynamic> toJson() => _$ReceiptVoucherToJson(this);

		ReceiptVoucher copyWith({
		String? userNo,
		String? cashAccNo,
		String? accNo,
		double? amount,
		String? description,
	}) {
		return ReceiptVoucher(
			userNo: userNo ?? this.userNo,
			cashAccNo: cashAccNo ?? this.cashAccNo,
			accNo: accNo ?? this.accNo,
			amount: amount ?? this.amount,
			description: description ?? this.description,
		);
	}
}
