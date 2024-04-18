// ignore_for_file: file_names
import 'package:finobird/constants/colors.dart';
import 'package:finobird/screens/authentication/login.dart';
import 'package:finobird/screens/introduction/2nd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../custom/custom_intro_card.dart';
import '../../constants/styles.dart';

class Intro1 extends StatelessWidget {
  const Intro1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Get.mediaQuery.padding.top),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    Get.offAll(() => const Login());
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    )),
                  ),
                  child: Text(
                    'Skip Intro',
                    textScaleFactor: 1,
                    style: Styles.text.copyWith(
                      color: primaryColor
                    ),
                  ),
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            'assets/amico.svg',
            height: 280,
          ),
          const Spacer(),
          CustomIntroCard(
            title: 'Track your stocks insights anytime',
            subtitle:
                'Get an overview of how the market and stocks are performing',
            progress: 33.33,
            onTap: () {
              Get.to(
                () => const Intro2(),
              );
            },
          ),
        ],
      ),
    );
  }
}
