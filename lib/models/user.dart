class User {
  String? name;
  String? whno;
  String? cashAccno;
  String? salesman;
  String? userNo;
  String? delegateNo;
  String? sellPriceNo;

  User({
    this.delegateNo,
    this.name,
    this.whno,
    this.cashAccno,
    this.salesman,
    this.userNo,
    this.sellPriceNo,
  });

  @override
  String toString() {
    return 'User(name: $name, whno: $whno, cashAccno: $cashAccno, salesman: $salesman, userNo: $userNo, delegateNo: $delegateNo), sellPriceNo: $sellPriceNo)';
  }

  factory User.fromJson(Map<String, dynamic> json, String? userNo) => User(
        delegateNo: json['delegateNo'] as String?,
        sellPriceNo: json['sellPriceNo'] as String?,
        name: json['name'] as String?,
        whno: json['Whno'] as String?,
        cashAccno: json['CashAccno'] as String?,
        salesman: json['Salesman'] as String?,
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
      };

  User copyWith({
    String? delegateNo,
    String? name,
    String? whno,
    String? cashAccno,
    String? salesman,
    String? userNo,
    String? sellPriceNo,
  }) {
    return User(
      delegateNo: delegateNo ?? this.delegateNo,
      name: name ?? this.name,
      whno: whno ?? this.whno,
      cashAccno: cashAccno ?? this.cashAccno,
      salesman: salesman ?? this.salesman,
      userNo: userNo ?? this.userNo,
      sellPriceNo: sellPriceNo ?? this.sellPriceNo,
    );
  }
}
