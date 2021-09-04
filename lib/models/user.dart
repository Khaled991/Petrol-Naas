class User {
  String? name;
  String? whno;
  String? cashAccno;
  String? salesman;
  String? userNo;
  String? sellPriceNo;

  User({
    this.sellPriceNo,
    this.name,
    this.whno,
    this.cashAccno,
    this.salesman,
    this.userNo,
  });

  @override
  String toString() {
    return 'User(name: $name, whno: $whno, cashAccno: $cashAccno, salesman: $salesman, userNo: $userNo, sellPriceNo: $sellPriceNo)';
  }

  factory User.fromJson(Map<String, dynamic> json, String? userNo) => User(
        sellPriceNo: json['sellPriceNo'] as String?,
        name: json['name'] as String?,
        whno: json['Whno'] as String?,
        cashAccno: json['CashAccno'] as String?,
        salesman: json['Salesman'] as String?,
        userNo: userNo,
      );

  Map<String, dynamic> toJson() => {
        'sellPriceNo': sellPriceNo,
        'name': name,
        'Whno': whno,
        'CashAccno': cashAccno,
        'Salesman': salesman,
        'userNo': userNo,
      };

  User copyWith({
    String? sellPriceNo,
    String? name,
    String? whno,
    String? cashAccno,
    String? salesman,
    String? userNo,
  }) {
    return User(
      sellPriceNo: sellPriceNo ?? this.sellPriceNo,
      name: name ?? this.name,
      whno: whno ?? this.whno,
      cashAccno: cashAccno ?? this.cashAccno,
      salesman: salesman ?? this.salesman,
      userNo: userNo ?? this.userNo,
    );
  }
}
