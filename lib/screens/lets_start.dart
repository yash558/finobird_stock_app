import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../custom/custom_elevated_button.dart';
import '../constants/styles.dart';
import 'introduction/intro.dart';

class LetsStart extends StatelessWidget {
  const LetsStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Get.mediaQuery.padding.top),
          Expanded(
            child: Center(
              child: Image.asset('assets/Fino Bird2.png'),
            ),
          ),
          CustomElevatedButton(
            color: primaryColor,
            onPressed: () {
              Get.to(
                () => const IntroPageView(),
                transition: Transition.fade,
                duration: const Duration(milliseconds: 500),
              );
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
          SizedBox(height: Get.mediaQuery.padding.bottom),
        ],
      ),
    );
  }
}
