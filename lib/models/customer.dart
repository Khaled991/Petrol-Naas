class Customer {
  String? accNo;
  String? accName;
  String? VATnum;

  Customer({this.accNo, this.accName, this.VATnum});

  @override
  String toString() =>
      'Customer(accNo: $accNo, accName: $accName, VATnum: $VATnum)';

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        accNo: json['AccNo'] as String?,
        accName: json['AccName'] as String?,
        VATnum: json['VATnum'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'AccNo': accNo,
        'AccName': accName,
        'VATnum': VATnum,
      };

  Customer copyWith({
    String? accNo,
    String? accName,
    String? VATnum,
  }) {
    return Customer(
      accNo: accNo ?? this.accNo,
      accName: accName ?? this.accName,
      VATnum: VATnum ?? this.VATnum,
    );
  }
}
