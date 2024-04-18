// ignore_for_file: must_be_immutable

import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/screens/profile/edit_profile.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController? _phone, _pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/undraw_Security_on_re_e491 1.png'),
              const SizedBox(height: 50),
              Text(
                'Verify your Phone',
                textScaleFactor: 1,
                style: Styles.text.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: _phone,
                text: 'Phone Number',
                type: TextInputType.number,
              ),
              CustomElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Submit',
                  textScaleFactor: 1,
                ),
              ),
              CustomTextField(
                controller: _pin,
                text: 'OTP',
                type: TextInputType.number,
              ),
              CustomElevatedButton(
                onPressed: () {
                  Get.to(() => const EditProfile());
                },
                color: Colors.teal.shade500,
                child: const Text(
                  'Submit',
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
