import 'package:flutter/material.dart';

class CustomAddCardOld extends StatelessWidget {
  const CustomAddCardOld({
    super.key,
    required this.onPress,
  });

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: onPress,
        child: Container(
          height: 120,
          width: 180,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF4AB5E5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_rounded,
                color: Color(0xFF4AB5E5),
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
