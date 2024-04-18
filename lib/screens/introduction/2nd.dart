// ignore_for_file: file_names
import 'package:finobird/screens/introduction/3rd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../custom/custom_intro_card.dart';
import '../../constants/styles.dart';
import '../authentication/login.dart';

class Intro2 extends StatelessWidget {
  const Intro2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: Get.mediaQuery.padding.top),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Padding(
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
                    color: const Color(0xFF4AB5E5).withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/pana.svg',
            height: 280,
          ),
          const Spacer(),
          CustomIntroCard(
            title: 'Our Mission',
            subtitle:
                'To help 1 million retail investors track their investments with ease by unifying the information available all over.',
            progress: 66.66,
            onTap: () {
              Get.to(
                () => const Intro3(),
              );
            },
          ),
        ],
      ),
    );
  }
}
