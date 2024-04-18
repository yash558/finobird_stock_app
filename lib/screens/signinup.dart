import 'package:finobird/screens/authentication/signup.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../custom/custom_elevated_button.dart';

class SignInUp extends StatelessWidget {
  const SignInUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Fino Bird2.png'),
            const SizedBox(height: 100),
            CustomElevatedButton(
              onPressed: () {
                Get.to(() => const SignUp());
              },
              child: Center(
                child: Text(
                  'Let\'s Start',
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
