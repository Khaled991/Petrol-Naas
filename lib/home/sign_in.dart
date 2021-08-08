import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/custom_input.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/user.dart';
import 'package:petrol_naas/models/user_sign_in.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';
import 'navigations_screen.dart';

class SignIn extends StatefulWidget {
  final Widget? child;
  SignIn({Key? key, this.child}) : super(key: key);

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
    signInData = signInData.copyWith(
      userNo: userNoController.text,
      userPwd: passwordController.text,
    );
    bool isValid = await fetchSignIn();
    if (isValid) navigateToUserScreens();
  }

  Future<bool> fetchSignIn() async {
    try {
      Response response = await Dio().post(
        'http://192.168.1.2/petrolnaas/public/api/login',
        data: signInData.toJson(),
      );
      var jsonRespone = response.data;
      final store = context.read<UserStore>();
      store.setUser(User.fromJson(jsonRespone, signInData.userNo));
      print(store.user);
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: size.height,
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
                  child: Container(
                    color: primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                )
                // Stack(
                //   children: [
                //     Image.asset(
                //       'assets/images/signInFormContainer.png',
                //       width: size.width,
                //     ),
                //     Positioned(
                //       top: 52,
                //       bottom: 0,
                //       right: 0,
                //       left: 0,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           Text(
                //             'تسجيل الدخول',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 24.0,
                //             ),
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               SizedBox(
                //                 width: 50,
                //                 height: 1.75,
                //               ),
                //               Container(
                //                 color: Colors.white,
                //                 width: 100,
                //                 height: 1.75,
                //               ),
                //             ],
                //           ),
                //           SizedBox(height: 4),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 color: Colors.white,
                //                 width: 100,
                //                 height: 1.75,
                //               ),
                //               SizedBox(
                //                 width: 50,
                //                 height: 1.75,
                //               ),
                //             ],
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.only(top: 20.0),
                //             child: CustomInput(
                //               hintText: 'رقم المندوب',
                //               type: 'white',
                //               controller: userNoController,
                //             ),
                //           ),
                //           CustomInput(
                //             controller: passwordController,
                //             hintText: 'كلمة المرور',
                //             type: 'password',
                //           ),
                //           CustomButton(
                //             buttonColors: Colors.white,
                //             onPressed: () => onPressSignIn(context, ref),
                //             text: 'تسجيل الدخول',
                //             textColors: primaryColor,
                //           ),
                //         ],
                //       ),

                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class BackgroundClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var roundnessFactor = 50.0;
//     var path = Path();

//     path.moveTo(0, size.height * 0.33);
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, roundnessFactor * 2);
//     path.quadraticBezierTo(
//       size.width,
//       0,
//       size.width - roundnessFactor * 3,
//       roundnessFactor * 2,
//     );
//     path.lineTo(roundnessFactor, size.height * 0.33 + 10);
//     path.quadraticBezierTo(
//       0,
//       size.height * 0.33 + roundnessFactor,
//       0,
//       size.height * 0.33 + roundnessFactor * 2,
//     );
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     throw UnimplementedError();
//   }
// }
