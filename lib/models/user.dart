class User {
  String? name;
  String? whno;
  String? cashAccno;
  String? salesman;

  User({this.name, this.whno, this.cashAccno, this.salesman});

  @override
  String toString() {
    return 'User(name: $name, whno: $whno, cashAccno: $cashAccno, salesman: $salesman)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String?,
        whno: json['Whno'] as String?,
        cashAccno: json['CashAccno'] as String?,
        salesman: json['Salesman'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'Whno': whno,
        'CashAccno': cashAccno,
        'Salesman': salesman,
      };

  User copyWith({
    String? name,
    String? whno,
    String? cashAccno,
    String? salesman,
  }) {
    return User(
      name: name ?? this.name,
      whno: whno ?? this.whno,
      cashAccno: cashAccno ?? this.cashAccno,
      salesman: salesman ?? this.salesman,
    );
  }
}
