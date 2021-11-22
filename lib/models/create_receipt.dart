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
    return 'CreateReceipt(userNo: $userNo, cashAccNo: $cashAccNo, accNo: $accNo, amount: $amount, description: $description)';
  }

  factory CreateReceipt.fromJson(Map<String, dynamic> json) => CreateReceipt(
        userNo: json['userNo'] as String?,
        cashAccNo: json['cashAccNo'] as String?,
        accNo: json['accNo'] as String?,
        amount: (json['amount'] as num?)?.toDouble(),
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userNo': userNo,
        'cashAccNo': cashAccNo,
        'accNo': accNo,
        'amount': amount,
        'description': description,
      };

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
