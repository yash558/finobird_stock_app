// ignore_for_file: must_be_immutable, unnecessary_final

import 'package:finobird/constants/colors.dart';
import 'package:finobird/repository/authentication.dart';
import 'package:finobird/screens/authentication/forgot_password.dart';
import 'package:finobird/screens/authentication/signup.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import '../../custom/textfield.dart';
import '../../repository/google_sign_in_webview.dart';
import '../../constants/styles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController(),
      _password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final Authentication authController = Get.put(Authentication());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool("intoCompleted", true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/hi.svg'),
                ),
                SvgPicture.asset(
                  'assets/World wide web_Monochromatic 1.svg',
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Obx(
                () => Form(
                  autovalidateMode: authController.logAutovalidate.value,
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Welcome Back!',
                        textScaleFactor: 1,
                        style: Styles.text.copyWith(fontSize: 30),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Login into FinoBird to continue',
                          textScaleFactor: 1,
                          style: Styles.text.copyWith(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _email,
                        text: 'Username *',
                        type: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Username.";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: _password,
                        text: 'Password *',
                        type: TextInputType.visiblePassword,
                        maxLength: 15,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter a Password.";
                          } else if (value.length < 8) {
                            return "Enter at least 8 characters.";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  () => const ForgotPassword(),
                                  transition: Transition.size,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                textScaleFactor: 1,
                                style: Styles.text.copyWith(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            Authentication().login(_password.text.trim(), _email.text.trim());
                            authController.logAutovalidate.value =
                                AutovalidateMode.disabled;
                          } else {
                            authController.logAutovalidate.value =
                                AutovalidateMode.onUserInteraction;
                          }
                        },
                        color: primaryColor,
                        child: Center(
                          child: Text(
                            'PROCEED',
                            textScaleFactor: 1,
                            style: Styles.text.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Or Log In with',
                              textScaleFactor: 1,
                              style: Styles.text.copyWith(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 100,
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SocialLoginButton(
                          buttonType: SocialLoginButtonType.google,
                          borderRadius: 100,
                          onPressed: () {
                            // authController.googleSingIn();
                            Get.to(
                              () => const GoogleSignInWebView(),
                              transition: Transition.cupertino,
                              duration: const Duration(seconds: 1),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                              () => const SignUp(),
                              transition: Transition.size,
                              duration: const Duration(seconds: 1),
                            );
                            authController.logAutovalidate.value =
                                AutovalidateMode.disabled;
                          },
                          child: Text(
                            'Newbie? Create Account',
                            textScaleFactor: 1,
                            style: Styles.text.copyWith(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
