class User {
  String? name;
  String? whno;
  String? cashAccno;
  String? salesman;
  String? userNo;

  User({this.name, this.whno, this.cashAccno, this.salesman, this.userNo});

  @override
  String toString() {
    return 'User(name: $name, whno: $whno, cashAccno: $cashAccno, salesman: $salesman, userNo: $userNo)';
  }

  factory User.fromJson(Map<String, dynamic> json, String? userNo) => User(
        name: json['name'] as String?,
        whno: json['Whno'] as String?,
        cashAccno: json['CashAccno'] as String?,
        salesman: json['Salesman'] as String?,
        userNo: userNo,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'Whno': whno,
        'CashAccno': cashAccno,
        'Salesman': salesman,
        'userNo': userNo,
      };

  User copyWith({
    String? name,
    String? whno,
    String? cashAccno,
    String? salesman,
    String? userNo,
  }) {
    return User(
      name: name ?? this.name,
      whno: whno ?? this.whno,
      cashAccno: cashAccno ?? this.cashAccno,
      salesman: salesman ?? this.salesman,
      userNo: userNo ?? this.userNo,
    );
  }
}
