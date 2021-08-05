class UserSignIn {
  String? userNo;
  String? userPwd;

  UserSignIn({this.userNo, this.userPwd});

  @override
  String toString() => 'UserSignIn(userNo: $userNo, userPwd: $userPwd)';

  factory UserSignIn.fromJson(Map<String, dynamic> json) => UserSignIn(
        userNo: json['User_no'] as String?,
        userPwd: json['user_pwd'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'User_no': userNo,
        'user_pwd': userPwd,
      };

  UserSignIn copyWith({
    String? userNo,
    String? userPwd,
  }) {
    return UserSignIn(
      userNo: userNo ?? this.userNo,
      userPwd: userPwd ?? this.userPwd,
    );
  }
}
