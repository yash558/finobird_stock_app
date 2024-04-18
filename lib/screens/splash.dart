import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/profile.dart';
import '../repository/authentication.dart';
import '../repository/user_repo.dart';
import 'authentication/login.dart';
import 'dashboard/navigation.dart';
import 'lets_start.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final auth = Get.put(Authentication());
  final usRepo = Get.put(UserRepo());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      loginUser();

    });
    super.initState();
  }


  loginUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("accessToken") != null &&
        preferences.getString("refreshToken") != null) {
      accessToken.value = preferences.getString("accessToken") ?? "";
      UserProfile? usPro = await usRepo.getUserProfile();
      if (usPro != null) {
        Get.offAll(
          () =>  Navigation(),
          transition: Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
      } else {
        auth.refreshToken(preferences.getString("refreshToken") ?? "", true);
      }
    } else {
      log("credentials not available");
      if (preferences.getBool("intoCompleted") ?? false) {
        Get.offAll(
          () => const Login(),
          transition: Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
      } else {
        Get.offAll(
          () => const LetsStart(),
          transition: Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset('assets/Fino Bird2.png'),
            ),
          ),
        ],
      ),
    );
  }
}
