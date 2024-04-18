import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomWatchlistCard extends StatelessWidget {
  const CustomWatchlistCard({
    Key? key,
    required this.title,
    required this.onTap,
    required this.center,
  }) : super(key: key);

  final String title;
  final Function() onTap;
  final Widget center;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: center,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textScaleFactor: 1,
            style: Styles.semiBold.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
