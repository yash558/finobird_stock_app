// ignore_for_file: must_be_immutable

import 'package:finobird/constants/colors.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import '../../repository/authentication.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _email = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/undraw_Authentication_re_svpt (1) 1.png'),
          const SizedBox(height: 50),
          Text(
            'Enter your Email',
            textScaleFactor: 1,
            style: Styles.text.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 30),
          Form(
            key: formkey,
            child: CustomTextField(
              controller: _email,
              text: 'Email Address *',
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
          ),
          const SizedBox(height: 30),
          CustomElevatedButton(
            onPressed: () {
          if (formkey.currentState!.validate()) {
              Authentication().forgotPassword(_email.text.trim());
         }
            },
            color: primaryColor,
            child: Center(
              child: Text(
                'Submit',
                textScaleFactor: 1,
                style: Styles.text.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
