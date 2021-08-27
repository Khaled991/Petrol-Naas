import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/widget/custom_button.dart';
import 'package:petrol_naas/widget/custom_input.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/user.dart';
import 'package:petrol_naas/models/user_sign_in.dart';
import 'package:provider/src/provider.dart';
import '../../constants.dart';
import '../home/navigations_screen.dart';

class SignIn extends StatefulWidget {
  final Widget? child;
  const SignIn({Key? key, this.child}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController userNoController =
      TextEditingController(text: "29");

  final TextEditingController passwordController =
      TextEditingController(text: "2640");

  UserSignIn signInData = UserSignIn();

  void navigateToUserScreens() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NavigationsScreen(),
      ),
    );
  }

  void onPressSignIn() async {
    signInData.userNo = userNoController.text;
    signInData.userPwd = passwordController.text;

    bool isValid = await fetchSignIn();
    if (isValid) navigateToUserScreens();
  }

  Future<bool> fetchSignIn() async {
    try {
      Response response = await Dio().post(
        'http://5.9.215.57/petrolnaas/public/api/login',
        data: signInData.toJson(),
      );
      var jsonRespone = response.data;
      final store = context.read<UserStore>();
      store.setUser(User.fromJson(jsonRespone, signInData.userNo));
      return true;
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.response!.data['message']),
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: screenSize.height,
          width: double.infinity,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                  child: Image.asset(
                    'assets/images/signInImage.png',
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Transform(
                        transform: Matrix4.skew(-0.05, -0.22),
                        origin: Offset(screenSize.width, screenSize.height),
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.33),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 25,
                        child: Transform(
                          transform: Matrix4.skew(-0.025, -0.22),
                          origin: Offset(screenSize.width, screenSize.height),
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.66),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 50,
                        child: Transform(
                          transform: Matrix4.skewY(-0.22),
                          origin: Offset(screenSize.width, screenSize.height),
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 75.0),
                            Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 1.75,
                                ),
                                Container(
                                  color: Colors.white,
                                  width: 100,
                                  height: 1.75,
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  width: 100,
                                  height: 1.75,
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 1.75,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: CustomInput(
                                hintText: 'رقم المندوب',
                                type: 'white',
                                controller: userNoController,
                              ),
                            ),
                            CustomInput(
                              controller: passwordController,
                              hintText: 'كلمة المرور',
                              type: 'password',
                            ),
                            CustomButton(
                              buttonColors: Colors.white,
                              onPressed: () => onPressSignIn(),
                              text: 'تسجيل الدخول',
                              textColors: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
