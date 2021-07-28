class SignInModel {
  String userNo;
  String userPwd;

  SignInModel({
    this.userNo = "",
    this.userPwd = "",
  });

  Map<String, String> toJson() {
    return {
      "User_no": userNo,
      "user_pwd": userPwd,
    };
  }
}

class User {
  final String name;
  final String whno;
  final String cashAccno;
  final String salesman;
  final String userNo;

  User({
    required this.userNo,
    required this.name,
    required this.whno,
    required this.cashAccno,
    required this.salesman,
  });

  User fromJson(jsonData, userNo) {
    return User(
      name: jsonData['name'],
      whno: jsonData['Whno'],
      cashAccno: jsonData['CashAccno'],
      salesman: jsonData['Salesman'],
      userNo: userNo,
    );
  }
}
