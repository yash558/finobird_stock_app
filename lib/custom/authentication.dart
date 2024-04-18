// ignore_for_file: non_constant_identifier_names, unnecessary_final

import 'dart:convert';
import 'dart:developer';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:finobird/repository/user_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/loader.dart';
import '../models/user/profile.dart';
import '../screens/authentication/confirmation_code.dart';
import '../screens/authentication/forget_pass_verification_code.dart';
import '../screens/authentication/login.dart';
import '../screens/dashboard/navigation.dart';
import '../screens/profile/forgot password/password_changed.dart';
import 'constants.dart';
// import 'stored_data.dart';

RxString accessToken = ''.obs;
final userPool = CognitoUserPool(
  Constants.userPoolId,
  Constants.clientId,
  clientSecret: Constants.clientSecret,
);

class Authentication extends GetxController {
  final usRepo = Get.put(UserRepo());

  late Rx<AutovalidateMode> logAutovalidate = AutovalidateMode.disabled.obs;
  signUp(
    String email,
    String password,
    String username,
    String firstName,
    String lastName,
  ) async {
    try {
      showLoader();
      await userPool.signUp(
        username,
        password,
        userAttributes: [
          AttributeArg(name: "email", value: email),
          AttributeArg(name: "given_name", value: firstName),
          AttributeArg(name: "family_name", value: lastName),
        ],
      ).then((value) {
        hideLoader();
        log("user registered successfully");
        Get.to(() => ConfirmationCode(
              username: username,
            ));
        Fluttertoast.showToast(
          msg: 'Registration Successful',
          gravity: ToastGravity.TOP,
        );
      });
    } on CognitoClientException catch (e) {
      hideLoader();
      print(e.toString());
      if (e.code!.toLowerCase().toString() ==
          'UserLambdaValidationException'.toLowerCase()) {
        Fluttertoast.showToast(
          msg: 'Username or Email already exists',
          gravity: ToastGravity.TOP,
        );
      } else {
        hideLoader();
        Fluttertoast.showToast(
          msg: '${e.message}',
          gravity: ToastGravity.TOP,
        );
      }
    } on CognitoUserException catch (e) {
      hideLoader();
      print(e.toString());
      Fluttertoast.showToast(
        msg: '${e.message}',
        gravity: ToastGravity.TOP,
      );
    } on CognitoCredentials catch (e) {
      hideLoader();
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'Registration Failed',
        gravity: ToastGravity.TOP,
      );
    }
  }

  login(String password, String username) async {
    var cognitoUser = CognitoUser(
      username,
      userPool,
      clientSecret: Constants.clientSecret,
    );
    var authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    try {
      showLoader();
      await cognitoUser.authenticateUser(authDetails).then((session) async {
        if (session != null) {
          accessToken.value = session.accessToken.jwtToken!;

          final SharedPreferences preferences =
              await SharedPreferences.getInstance();
          await preferences.setString(
            "refreshToken",
            session.refreshToken?.token ?? "",
          );
          await preferences.setString(
            "accessToken",
            accessToken.value,
          );
          print("this is a access token  " + accessToken.value + "    \n");
          final UserRepo user = Get.put(UserRepo());
          await user.getUserProfile();
          hideLoader();
          if (accessToken.value.isNotEmpty) {
            await FirebaseMessaging.instance.getToken().then((val) {
              if (val != null) {
                //  print('ndignidn $val');
                usRepo.addUserDeviceToken(val);
              }
            });
          }
          Get.offAll(
            () => Navigation(),
            transition: Transition.cupertino,
            duration: const Duration(seconds: 1),
          );
        } else {
          hideLoader();
          Fluttertoast.showToast(
              msg: "Login Failed", gravity: ToastGravity.TOP);
        }
      }).catchError((e) {
        hideLoader();
        log(e.toString());
        CognitoClientException massaged = e;
        Fluttertoast.showToast(
            msg: massaged.message ?? "Login Failed", gravity: ToastGravity.TOP);
      });
      log(accessToken.toString());
      return accessToken;
    } catch (e) {
      hideLoader();
      log(e.toString());
    }
  }

  verifyConfirmationCode(String username, String code) async {
    var cognitoUser = CognitoUser(
      username,
      userPool,
      clientSecret: Constants.clientSecret,
    );
    showLoader();
    bool confirmed = await cognitoUser.confirmRegistration(code);
    log(confirmed.toString());
    if (confirmed) {
      hideLoader();
      Get.offAll(() => const Login());
      Fluttertoast.showToast(msg: 'User Verified', gravity: ToastGravity.TOP);
    } else {
      hideLoader();
      Fluttertoast.showToast(
          msg: 'Enter the valid code to verify your profile',
          gravity: ToastGravity.TOP);
    }
    return confirmed;
  }

  changePassword(
    String oldPassword,
    String newPassword,
    String username,
  ) async {
    var cognitoUser = CognitoUser(
      username,
      userPool,
      clientSecret: Constants.clientSecret,
    );

    bool passwordChanged = false;
    var authDetails = AuthenticationDetails(
      username: username,
      password: oldPassword,
    );
    try {
      showLoader();
      await cognitoUser.authenticateUser(authDetails).then((session) async {
        // log(cognitoUser.getSignInUserSession()!.idToken.jwtToken.toString() +
        //     '     oooooooooooooooo');
        passwordChanged = await cognitoUser.changePassword(
          oldPassword,
          newPassword,
        );
        // log('alf');
        if (passwordChanged) {
          hideLoader();
          Get.offAll(
            () => const PasswordChanged(),
            transition: Transition.size,
            duration: const Duration(seconds: 1),
          );
        }
      });
    } catch (e) {
      hideLoader();
      // log(e.toString() + '                 mmmmm');
    }
    // log(passwordChanged.toString());
  }

  forgotPassword(String email) async {
    var cognitoUser = CognitoUser(
      email,
      userPool,
      clientSecret: Constants.clientSecret,
    );
    try {
      showLoader();
      await cognitoUser.forgotPassword().then((value) {
        log(value.toString());
        hideLoader();
        Get.to(() => ForgotPasswordVerificationScreen(
              username: email,
            ));
      });
    } catch (e) {
      hideLoader();
      log(e.toString());
    }
  }

  verifyForgotPassword(
      String email, String verifyCode, String newPassword) async {
    var cognitoUser = CognitoUser(
      email,
      userPool,
      clientSecret: Constants.clientSecret,
    );
    bool passwordConfirmed = false;
    try {
      showLoader();
      passwordConfirmed = await cognitoUser
          .confirmPassword(verifyCode, newPassword)
          .then((value) {
        hideLoader();
        Get.offAll(() => const Login());
        Fluttertoast.showToast(
            msg: "Password Changed Successfully", gravity: ToastGravity.TOP);
        return true;
      });
    } catch (e) {
      hideLoader();
      log(e.toString());
    }
    log(passwordConfirmed.toString());
  }

  SignOut(username) async {
    var cognitoUser = CognitoUser(username, userPool);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      showLoader();
      await cognitoUser.signOut().then(
        (value) async {
          hideLoader();
          preferences.remove("refreshToken");
          await Get.offAll(() => const Login());
          Fluttertoast.showToast(
              msg: "Logout successful", gravity: ToastGravity.TOP);
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> commonLogin(Map tokenData, bool refresh) async {
    bool fail = false;
    final idToken = CognitoIdToken(tokenData['id_token']);
    final accessToke = CognitoAccessToken(tokenData['access_token']);
    final refreshToken = CognitoRefreshToken(tokenData['refresh_token']);
    final session =
        CognitoUserSession(idToken, accessToke, refreshToken: refreshToken);
    if (session.accessToken.jwtToken != null) {
      accessToken.value = session.accessToken.jwtToken!;
      // final user = CognitoUser(null, userPool, signInUserSession: session);
      // final attributes = await user.getUserAttributes();
      // if (attributes != null) {
      // for (CognitoUserAttribute attribute in attributes) {
      //   if (attribute.getName() == "email") {
      //     user.username = attribute.getValue();
      //     break;
      //   }
      // }
      // login
      final UserRepo userRepo = Get.put(UserRepo());
      UserProfile? us = await userRepo.getUserProfile();
      if (us != null) {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        await preferences.setString(
          "refreshToken",
          session.refreshToken!.token ?? "",
        );
        await preferences.setString(
          "accessToken",
          accessToken.value,
        );
        Get.offAll(
          () => Navigation(),
          transition: Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
      } else {
        log("====>  API FAILD TO LOAD USER DATA");
        if (!refresh) {
          Fluttertoast.showToast(msg: "Login Failed");
        } else {
          fail = true;
        }
      }
    } else {
      log("====>  No Attributes");
      if (!refresh) {
        Fluttertoast.showToast(msg: "Login Failed");
      } else {
        fail = true;
      }
    }
    // } else {
    //   log("====>  No Session");
    //   if (!refresh) {
    //     Fluttertoast.showToast(msg: "Login Failed");
    //   } else {
    //     fail = true;
    //   }
    // }
    if (refresh && fail) {
      Get.offAll(
        () => const Login(),
        transition: Transition.cupertino,
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future signUserInWithAuthCode(String authCode) async {
    String url =
        "${Constants.authUrl}/oauth2/token?grant_type=authorization_code&client_id=${Constants.clientId}&code=$authCode&redirect_uri=myapp://";
    final response = await http.post(
      Uri.parse(url),
      body: {},
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        "Authorization":
            "Basic ${base64.encode(utf8.encode('${Constants.clientId}:${Constants.clientSecret}'))}",
      },
    );
    if (response.statusCode == 200) {
      log("=====> RESPONSE BODY  :::  ${response.body}");
      commonLogin(jsonDecode(response.body), false);
    } else {
      log("========>   Response Status code :::  ${response.statusCode}  ::::  ${response.body}");
      Fluttertoast.showToast(msg: "Login Failed");
    }
  }

  Future<void> refreshToken(String refreshToken, bool refresh) async {
    try {
      String url =
          "${Constants.authUrl}/oauth2/token?grant_type=refresh_token&refresh_token=$refreshToken&redirect_uri=${Constants.authUrl}/auth/callback";
      final response = await http.post(
        Uri.parse(url),
        body: {},
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "Authorization":
              "Basic ${base64.encode(utf8.encode('${Constants.clientId}:${Constants.clientSecret}'))}",
        },
      );
      if (response.statusCode == 200) {
        log("=====> RESPONSE BODY  :::  ${response.body}");
        commonLogin(jsonDecode(response.body), refresh);
      } else {
        Get.offAll(
          () => const Login(),
          transition: Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
        log("========>   Response Status code :::  ${response.statusCode}  ::::  ${response.body}");
      }
    } catch (e) {
      Get.offAll(
        () => const Login(),
        transition: Transition.cupertino,
        duration: const Duration(seconds: 1),
      );
      log("======>  ERROR ::::  $e");
    }
  }
}


  // Future<void> googleSingIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;
  //       log("======>  Google idToken   ::::    ${googleAuth.idToken}");
  //       log("======>  Google accessToken  ::::    ${googleAuth.accessToken}");
  //       CognitoCredentials credential = CognitoCredentials(
  //         Platform.isAndroid ? Constants.androidIPD : Constants.iosIPD,
  //         userPool,
  //       );
  //       await credential.getAwsCredentials(
  //         googleAuth.idToken,
  //         'accounts.google.com',
  //       );
  //       log("======>  accessKeyId   ::::    ${credential.accessKeyId}");
  //       log("======>  expireTime   ::::    ${credential.expireTime}");
  //       log("======>  secretAccessKey   ::::    ${credential.secretAccessKey}");
  //       log("======>  sessionToken   ::::    ${credential.sessionToken}");
  //       log("======>  userIdentityId   ::::    ${credential.userIdentityId}");
  //       signUserInWithAuthCode(credential.userIdentityId!.split(":")[1]);
  //     } else {
  //       Fluttertoast.showToast(msg: "Login Failed");
  //     }
  //   } catch (e) {
  //     log("::::: Login Fail : ${e.toString()}");
  //     Fluttertoast.showToast(msg: "Login Failed");
  //   }
  // }