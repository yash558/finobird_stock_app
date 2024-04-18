import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/repository/authentication.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../constants/styles.dart';

class ForgotPasswordVerificationScreen extends StatefulWidget {
  const ForgotPasswordVerificationScreen({super.key, required this.username});
  final String username;

  @override
  State<ForgotPasswordVerificationScreen> createState() =>
      _ForgotPasswordVerificationScreenState();
}

class _ForgotPasswordVerificationScreenState
    extends State<ForgotPasswordVerificationScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();
  final TextEditingController _verificationCode = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            const SizedBox(height: 35),
            Center(
              child: Text(
                'Change password',
                textScaleFactor: 1,
                style: Styles.semiBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please set a new password',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: Styles.text.copyWith(
                  color: Colors.black38,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Note* Please check your email for the verification code",
                style: Styles.text,
              ),
            ),
            CustomTextField(
              controller: _verificationCode,
              text: 'Verification Code *',
              type: TextInputType.visiblePassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please Enter a Verification Code.";
                } else if (value.length < 6) {
                  return "Confirm password does not match.";
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
          ],
        ),
      ),
      bottomNavigationBar: CustomElevatedButton(
        onPressed: () {
    if (formkey.currentState!.validate()) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            animType: AnimType.rightSlide,
            title: 'Update Password',
            desc: 'Are you sure you want to update your password?',
            btnCancelOnPress: () {
              Get.back();
            },
            btnOkOnPress: () {
              changePassword();
            },
            btnOkColor: Colors.teal.shade500,
            titleTextStyle: Styles.semiBold,
            descTextStyle: Styles.text,
            buttonsTextStyle: Styles.text,
          ).show();
    }
        },
        color: Colors.teal.shade500,
        child: Center(
          child: Text(
            'Change Password',
            textScaleFactor: 1,
            style: Styles.text.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  void changePassword() {
    if (_password.text.isNotEmpty &&
        _cpassword.text.isNotEmpty &&
        _verificationCode.text.isNotEmpty) {
      if (_password.text == _cpassword.text) {
        Authentication().verifyForgotPassword(
            widget.username.trim(), _verificationCode.text.trim(), _password.text.trim());
      } else {
        Fluttertoast.showToast(
          msg: "Password and confirm password should be same",
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "All fields are necessary",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
