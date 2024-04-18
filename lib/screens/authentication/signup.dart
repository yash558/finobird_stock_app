// ignore_for_file: must_be_immutable, unnecessary_final

import 'dart:developer';

import 'package:finobird/constants/colors.dart';
import 'package:finobird/screens/authentication/login.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repository/authentication.dart';
import '../../repository/google_sign_in_webview.dart';
import '../../constants/styles.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formkey = GlobalKey<FormState>();
  final Authentication authController = Get.put(Authentication());
  final TextEditingController _email = TextEditingController(),
      _password = TextEditingController(),
      _cpassword = TextEditingController(),
      _fname = TextEditingController(),
      _lname = TextEditingController(),
      _username = TextEditingController();

  RxBool value = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/Achievement _Monochromatic 1.svg',
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 20,
                    top: 30,
                    child: SvgPicture.asset(
                      'assets/Group 12.svg',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height + 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(08),
                  child: Obx(
                    () => Form(
                      key: formkey,
                      autovalidateMode: authController.logAutovalidate.value,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _fname,
                            text: 'First Name *',
                            type: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter First Name.";
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _lname,
                            text: 'Last Name *',
                            type: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Last Name.";
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _username,
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
                            controller: _email,
                            text: 'Email *',
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Email.";
                              } else if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return "Enter valid Email.";
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _password,
                            text: 'Password *',
                            type: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Password.";
                              } else if (value.length < 8) {
                                return "Enter at least 8 characters.";
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                  .hasMatch(value)) {
                                return "A mix of uppercase and lowercase letters and special characters";
                              } else if (value.length > 15) {
                                return "Enter max 15 characters.";
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: _cpassword,
                            text: 'Confirm Password *',
                            type: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter a Password.";
                              } else if (value != _password.text) {
                                return "Confirm password does not match.";
                              }
                              return null;
                            },
                          ),
                          Obx(
                            () => CheckboxListTile(
                              value: value.value,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (val) {
                                value.value = val!;
                              },
                              // checkColor: const Color(0xFF4AB5E5).withOpacity(0.5),
                              activeColor:
                                  const Color(0xFF4AB5E5).withOpacity(0.5),
                              title:
                              RichText(
                                textScaleFactor: 1,
                                text: TextSpan(
                                  style: Styles.text.copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                  children:  <TextSpan>[
                                    const TextSpan(text: 'I have read and I agree with the '),
                                    TextSpan(text: 'Terms & Conditions',style: const TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
                                      recognizer:  TapGestureRecognizer()
                                        ..onTap = () { launch('https://www.finobird.in/terms-and-conditions');
                                        },),
                                    const TextSpan(text: ' of the company')
                                  ],
                                ),
                              )/*Text(
                                'I have read and I agree with the Terms & Conditions of the company',
                                textScaleFactor: 1,
                                style: Styles.text.copyWith(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),*/
                            ),
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                signUp();
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
                                style:
                                    Styles.text.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account ?',
                                textScaleFactor: 1,
                                style: Styles.text,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(
                                    () => const Login(),
                                    transition: Transition.size,
                                    duration: const Duration(seconds: 1),
                                  );
                                  authController.logAutovalidate.value =
                                      AutovalidateMode.disabled;
                                },
                                child: Text(
                                  'Login',
                                  textScaleFactor: 1,
                                  style:
                                      Styles.text.copyWith(color: Colors.black),
                                ),
                              ),
                            ],
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
                                  'OR',
                                  textScaleFactor: 1,
                                  style: Styles.text,
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
                            padding: const EdgeInsets.only(bottom: 10,left: 08,top: 08,right: 08),
                            child: SocialLoginButton(
                              buttonType: SocialLoginButtonType.google,
                              borderRadius: 100,
                              onPressed: () {
                                Get.to(
                                  () => const GoogleSignInWebView(),
                                  transition: Transition.cupertino,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() {
    if (value.value) {
      log(_email.text);
      log(_password.text);
      log(_username.text);
      if (_lname.text.isNotEmpty &&
          _fname.text.isNotEmpty &&
          _email.text.isNotEmpty &&
          _password.text.isNotEmpty &&
          _cpassword.text.isNotEmpty &&
          _username.text.isNotEmpty) {
        if (_email.text.isEmail) {
          if (_password.text == _cpassword.text) {
            Authentication().signUp(
              _email.text.trim(),
              _password.text.trim(),
              _username.text.trim(),
              _fname.text.trim(),
              _lname.text.trim(),
            );
          } else {
            Fluttertoast.showToast(
              msg:
                  'Password should be same in both password and confirm password',
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Enter a valid email',
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Please fill all the fields above.',
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Please accept the terms and conditions before signing up.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
