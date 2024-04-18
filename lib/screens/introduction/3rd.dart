// ignore_for_file: file_names
import 'package:finobird/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../custom/custom_intro_card.dart';

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: Get.mediaQuery.padding.top),
          SvgPicture.asset(
            'assets/man with tl.svg',
            height: 350,
          ),
          const Spacer(),
          CustomIntroCard(
            title: 'Our Vision',
            subtitle:
                'To build a community of retail investors who could retire wealthy.',
            progress: 100,
            onTap: () {
              Get.offAll(
                () => const Login(),
              );
            },
          ),
        ],
      ),
    );
  }
}
