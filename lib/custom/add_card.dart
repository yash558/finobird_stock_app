import 'package:finobird/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAddCard extends StatelessWidget {
  const CustomAddCard({
    super.key,
    required this.onPress,
  });

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onPress,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_rounded,
                color: primaryColor,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
