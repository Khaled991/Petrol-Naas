class Customer {
  String? accNo;
  String? accName;

  Customer({this.accNo, this.accName});

  @override
  String toString() => 'Customer(accNo: $accNo, accName: $accName)';

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        accNo: json['AccNo'] as String?,
        accName: json['AccName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'AccNo': accNo,
        'AccName': accName,
      };

  Customer copyWith({
    String? accNo,
    String? accName,
  }) {
    return Customer(
      accNo: accNo ?? this.accNo,
      accName: accName ?? this.accName,
    );
  }
}
