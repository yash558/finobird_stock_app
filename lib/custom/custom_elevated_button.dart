import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/neopop.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color,
    this.height,
  }) : super(key: key);

  final Function() onPressed;
  final Widget child;
  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: NeoPopButton(
            color: color ?? const Color(0xFF4AB5E5),
            onTapUp: () => HapticFeedback.vibrate(),
            onTapDown: () => HapticFeedback.vibrate(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: height ?? 35,
                child: InkWell(
                  onTap: onPressed,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
