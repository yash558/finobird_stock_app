import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/screens/profile/forgot%20password/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants/styles.dart';

class EmailForgotPassword extends StatelessWidget {
  EmailForgotPassword({super.key});

  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            SvgPicture.asset('assets/bro.svg'),
            const SizedBox(height: 10),
            Text(
              'Enter your Email',
              textScaleFactor: 1,
              style: Styles.text.copyWith(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'You will receive an otp to confirm your account please enter the otp to change your password',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: Styles.text.copyWith(
                  color: Colors.black38,
                  fontSize: 10,
                ),
              ),
            ),
            CustomTextField(
              controller: _email,
              text: 'Email Address',
              type: TextInputType.emailAddress,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            CustomElevatedButton(
              onPressed: () {
                Get.to(
                  () => ChangePassword(
                    username: '',
                  ),
                  transition: Transition.size,
                  duration: const Duration(seconds: 1),
                );
              },
              child: Center(
                child: Text(
                  'PROCEED',
                  textScaleFactor: 1,
                  style: Styles.text.copyWith(
                    color: Colors.white,
                    fontSize: 20,
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
