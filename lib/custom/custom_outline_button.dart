import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.background,
  }) : super(key: key);

  final Function() onPressed;
  final String text;
  final Color? textColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 45,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: background,
          ),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Center(
              child: Text(
                text,
                textScaleFactor: 1,
                style: Styles.text.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
