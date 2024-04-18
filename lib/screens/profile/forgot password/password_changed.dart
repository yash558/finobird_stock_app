import 'package:finobird/screens/authentication/login.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants/styles.dart';

class PasswordChanged extends StatelessWidget {
  const PasswordChanged({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            SvgPicture.asset('assets/happy sun.svg'),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Your password has been changed',
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: Styles.text.copyWith(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Container()),
            CustomElevatedButton(
              onPressed: () {
                Get.to(
                  () => const Login(),
                  transition: Transition.zoom,
                  duration: const Duration(seconds: 1),
                );
              },
              child: Center(
                child: Text(
                  'Log In ->',
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
