import 'package:finobird/constants/colors.dart';
import 'package:flutter/material.dart';

import '../constants/styles.dart';

class CustomIntroCard extends StatelessWidget {
  const CustomIntroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final double progress;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: Styles.semiBold.copyWith(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  subtitle,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: Styles.subtitleSmall,
                ),
              ),
              progress == 100
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: onTap,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: progress != 100
                                ? const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  )
                                : Text(
                                    'Ready',
                                    textScaleFactor: 1,
                                    style: Styles.subtitleSmall
                                        .copyWith(color: Colors.black),
                                  ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 50,
                      width: 50,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
