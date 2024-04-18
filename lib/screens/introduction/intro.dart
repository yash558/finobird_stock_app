import 'package:finobird/screens/introduction/1st.dart';
import 'package:finobird/screens/introduction/2nd.dart';
import 'package:finobird/screens/introduction/3rd.dart';
import 'package:flutter/material.dart';

class IntroPageView extends StatelessWidget {
  const IntroPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: const [
        Intro1(),
        Intro2(),
        Intro3(),
      ],
    );
  }
}
