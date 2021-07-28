import 'package:flutter/material.dart';
import 'package:petrol_naas/components/custom_input.dart';
import 'package:petrol_naas/models/user.dart';

import '../constants.dart';
import 'navigations_screen.dart';

class SignIn extends StatelessWidget {
  final Widget? child;
  final TextEditingController userNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SignInModel signInData = SignInModel();

  void onPressSignIn() {
    signInData.userNo = userNoController.text;
    signInData.userPwd = passwordController.text;

    // axios.post("http://192.168.1.41:8000/api/login", user.toJson()).then((data){
    //    
    // });
  }

  SignIn({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: size.height,
          width: double.infinity,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                child: Image.asset(
                  'assets/images/signInImage.png',
                ),
              ),
              Stack(
                children: [
                  Image.asset(
                    'assets/images/signInFormContainer.png',
                    width: size.width,
                  ),
                  Positioned(
                    top: 52,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          height: 47.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: primaryColor,
                              textStyle: const TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 1.5,
                                fontFamily: 'Changa',
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const NavigationsScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'تسجيل الدخول',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
