class Customer {
  String? accNo;
  String? accName;
  String? vatNum;

  Customer({this.accNo, this.accName, this.vatNum});

  @override
  String toString() =>
      'Customer(accNo: $accNo, accName: $accName, VATnum: $vatNum)';

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        accNo: json['AccNo'] as String?,
        accName: json['AccName'] as String?,
        vatNum: json['VATnum'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'AccNo': accNo,
        'AccName': accName,
        'VATnum': vatNum,
      };

  Customer copyWith({
    String? accNo,
    String? accName,
    String? vatNum,
  }) {
    return Customer(
      accNo: accNo ?? this.accNo,
      accName: accName ?? this.accName,
      vatNum: vatNum ?? this.vatNum,
    );
  }
}
