import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserErrorWidget extends StatelessWidget {
  const UserErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      // margin: EdgeInsets.only(
      //   left: Get.width * .015,
      //   top: Get.height * .012,
      // ),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 55, 117, 112), shape: BoxShape.circle),
      child: Center(
        child: Icon(
          Icons.person,
          size: Get.width * 0.035,
          color: Colors.white,
        ),
      ),
    );
  }
}
