import 'package:flutter/material.dart';

import '../constants/styles.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });
  final String title;
  final bool value;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: const Color(0xFF4AB5E5),
            onChanged: (val) {
              onTap();
            },
          ),
          Text(
            title,
            style: Styles.text,
          ),
        ],
      ),
    );
  }
}
