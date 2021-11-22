import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrol_naas/components/custom_button.dart';
import 'package:petrol_naas/components/custom_text_field.dart';
import 'package:petrol_naas/screens/my_invoice_screen/my_invoices_screen.dart';
import 'package:petrol_naas/screens/my_receipts/my_receipts.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:petrol_naas/mobx/user/user.dart';
import 'package:petrol_naas/models/user.dart';
import 'package:petrol_naas/models/user_sign_in.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import '../../constants.dart';

class SignIn extends StatefulWidget {
  final Widget? child;
  const SignIn({Key? key, this.child}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController userNoController =
      // TextEditingController(text: "");
      // TextEditingController(text: "29");
      TextEditingController(text: "23");

  final TextEditingController passwordController =
      // TextEditingController(text: "");
      // TextEditingController(text: "147258369");
      TextEditingController(text: "963852741");

  UserSignIn signInData = UserSignIn();

  void onPressSignIn() async {
    signInData.userNo = userNoController.text;
    signInData.userPwd = passwordController.text;

    if (signInData.userNo == '') {
      showSnackBar(context, 'الرجاء ادخال رقم المندوب');
      return;
    } else if (signInData.userPwd == '') {
      showSnackBar(context, 'الرجاء ادخال كلمة المرور');
      return;
    }

    try {
      await fetchSignIn();

      navigateToUserScreens();
    } catch (e) {
      showSnackBar(context, 'حدث خطأ ما الرجاء التواصل مع الادارة');
    }
  }

  void navigateToUserScreens() {
    //TODO: delete next line
    // navigatePushReplace(context, MyReceiptsScreen());
    navigatePushReplace(context, MyInvoicesScreen());
  }

  Future<void> fetchSignIn() async {
    try {
      Response response = await Dio(dioOptions).post(
        '/login',
        data: signInData.toJson(),
      );
      var jsonRespone = response.data;
      print(jsonRespone);

      final userStore = context.read<UserStore>();
      userStore.setUser(User.fromJson(jsonRespone, signInData.userNo));
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 400) {
        throw 'البيانات غير صحيحة';
      } else {
        throw 'حدث خطأ ما الرجاء التواصل مع الادارة';
      }
    } catch (e) {
      throw 'حدث خطأ ما الرجاء التواصل مع الادارة';
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
                              child: CustomTextField(
                                hintText: 'رقم المندوب',
                                type: CustomTextFieldTypes.white,
                                controller: userNoController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            CustomTextField(
                              controller: passwordController,
                              hintText: 'كلمة المرور',
                              type: CustomTextFieldTypes.password,
                            ),
                            CustomButton(
                              buttonColors: Colors.white,
                              onPressed: () => onPressSignIn(),
                              label: 'تسجيل الدخول',
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
