import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/repository/authentication.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../constants/styles.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key, required this.username});
  final String username;

  final TextEditingController _password = TextEditingController();
  final TextEditingController _cpassword = TextEditingController();
  final TextEditingController _oldpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
          CustomTextField(
            controller: _oldpassword,
            text: 'Old Password *',
            type: TextInputType.visiblePassword,
          ),
          CustomTextField(
            controller: _password,
            text: 'Password *',
            type: TextInputType.visiblePassword,
          ),
          CustomTextField(
            controller: _cpassword,
            text: 'Confirm Password *',
            type: TextInputType.visiblePassword,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Note* While entering a new password please make sure you use atleast 1 Uppercase, 1 lowercase, 1 Digit & 1 Symbol.",
              textAlign: TextAlign.center,
              style: Styles.text,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomElevatedButton(
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Update Password',
            desc: 'Are you sure you want to update your password?',
            btnCancelOnPress: () {
              Get.back();
            },
            btnOkOnPress: () {
              changePassword();
            },
            btnOkColor: const Color(0xFF4AB5E5),
            titleTextStyle: Styles.semiBold,
            descTextStyle: Styles.text,
            buttonsTextStyle: Styles.text,
          ).show();
        },
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
        _oldpassword.text.isNotEmpty) {
      if (_password.text == _cpassword.text) {
        Authentication().changePassword(
          _oldpassword.text.trim(),
          _password.text.trim(),
          username.trim(),
        );
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
