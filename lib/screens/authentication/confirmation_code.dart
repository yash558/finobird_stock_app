import 'package:finobird/constants/colors.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/repository/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/styles.dart';

class ConfirmationCode extends StatefulWidget {
  final String username;
  const ConfirmationCode({super.key, required this.username});

  @override
  State<ConfirmationCode> createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  final TextEditingController _code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
              height: MediaQuery.of(context).size.height-200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Enter the verification code sent to your email to verify your account",
                      style: Styles.text,
                    ),
                  ),
                  CustomTextField(
                    controller: _code,
                    text: 'Code',
                    type: TextInputType.number,
                  ),
                  const SizedBox(height: 50),
                  CustomElevatedButton(
                    onPressed: () {
                      Authentication()
                          .verifyConfirmationCode(widget.username.trim(), _code.text.trim());
                    },
                    color: primaryColor,
                    child: Center(
                      child: Text(
                        'VERIFY',
                        textScaleFactor: 1,
                        style: Styles.text.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
