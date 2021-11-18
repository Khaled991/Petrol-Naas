class User {
  String? name;
  String? whno;
  String? cashAccno;
  String? salesman;
  String? userNo;
  String? delegateNo;
  String? sellPriceNo;
  double? creditLimit;

  User({
    this.delegateNo,
    this.name,
    this.whno,
    this.cashAccno,
    this.salesman,
    this.userNo,
    this.sellPriceNo,
    this.creditLimit,
  });

  @override
  String toString() {
    return 'User(name: $name, whno: $whno, cashAccno: $cashAccno, salesman: $salesman, userNo: $userNo, delegateNo: $delegateNo), sellPriceNo: $sellPriceNo, creditLimit: $creditLimit)';
  }

  factory User.fromJson(Map<String, dynamic> json, String? userNo) => User(
        delegateNo: json['delegateNo'] as String?,
        sellPriceNo: json['sellPriceNo'] as String?,
        name: json['name'] as String?,
        whno: json['Whno'] as String?,
        cashAccno: json['CashAccno'] as String?,
        salesman: json['Salesman'] as String?,
        creditLimit: double.parse(json['creditLimit'].toString()),
        userNo: userNo,
      );

  Map<String, dynamic> toJson() => {
        'delegateNo': delegateNo,
        'name': name,
        'Whno': whno,
        'CashAccno': cashAccno,
        'Salesman': salesman,
        'userNo': userNo,
        'sellPriceNo': sellPriceNo,
        'creditLimit': creditLimit,
      };

  User copyWith({
    String? delegateNo,
    String? name,
    String? whno,
    String? cashAccno,
    String? salesman,
    String? userNo,
    String? sellPriceNo,
    double? creditLimit,
  }) {
    return User(
      delegateNo: delegateNo ?? this.delegateNo,
      name: name ?? this.name,
      whno: whno ?? this.whno,
      cashAccno: cashAccno ?? this.cashAccno,
      salesman: salesman ?? this.salesman,
      userNo: userNo ?? this.userNo,
      sellPriceNo: sellPriceNo ?? this.sellPriceNo,
      creditLimit: creditLimit ?? this.creditLimit,
    );
  }
}
