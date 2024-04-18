// ignore_for_file: unnecessary_final

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finobird/custom/custom_outline_button.dart';
import 'package:finobird/repository/authentication.dart';
import 'package:finobird/screens/authentication/login.dart';
import 'package:finobird/screens/profile/faq/faq_screen.dart';
import 'package:finobird/screens/profile/forgot%20password/change_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom/custom_elevated_button.dart';
import '../../repository/user_repo.dart';
import '../../constants/styles.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepo user = Get.put(UserRepo());
    debugPrint("object _user ${user.profile.value.username}");

    user.getUserProfile();
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.mediaQuery.padding.top + 20),
            user.profile.value.avatarUrl == null
                ? CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0xFF4AB5E5).withOpacity(0.5),
                  )
                : SizedBox(
                    height: 70,
                    width: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user.profile.value.avatarUrl!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
            const SizedBox(height: 15),
            Text(
              "${user.profile.value.firstName}",
              textScaleFactor: 1,
              style: Styles.text.copyWith(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Account Settings',
                    style: Styles.text.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4AB5E5).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DefaultTextStyle(
                  style: Styles.text.copyWith(
                    fontSize: 15,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(LineIcons.edit),
                        onTap: () {
                          Get.to(() => const EditProfile());
                        },
                        title: Text(
                          'Edit Profile',
                          style: Styles.text,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => ChangePassword(
                                username: user.profile.value.username!,
                              ));
                        },
                        leading: const Icon(Icons.password_rounded),
                        title: Text(
                          'Change Password',
                          style: Styles.text,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Text(
                    'Information',
                    style: Styles.text.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4AB5E5).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DefaultTextStyle(
                  style: Styles.text.copyWith(
                    fontSize: 15,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                              "https://www.finobird.in/terms-of-services",
                            ),
                          );
                        },
                        leading: const Icon(LineIcons.connectDevelop),
                        title: Text(
                          'Terms and Conditions',
                          style: Styles.text,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                              "https://www.finobird.in/privacy-policy",
                            ),
                          );
                        },
                        leading: const Icon(LineIcons.bacon),
                        title: Text(
                          'Privacy Policy',
                          style: Styles.text,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => const FaqScreen());
                        },
                        leading: const Icon(LineIcons.questionCircle),
                        title: Text(
                          'FAQ\'s',
                          style: Styles.text,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4AB5E5).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DefaultTextStyle(
                  style: Styles.text.copyWith(
                    fontSize: 15,
                  ),
                  child: ListTile(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.bottomSlide,
                        title: 'Logout',
                        desc: 'Are you sure you want to logout from Finobird?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          await Authentication()
                              .SignOut(user.profile.value.email!.trim());
                        },
                        width: 400,
                        btnOkColor: const Color(0xFF4AB5E5),
                        titleTextStyle: Styles.semiBold,
                        descTextStyle: Styles.text,
                        buttonsTextStyle: Styles.text,
                      ).show();
                    },
                    leading: const Icon(Icons.exit_to_app_rounded),
                    title: Text(
                      'Logout',
                      style: Styles.text,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            followUs(),
          ],
        ),
      ),
    );
  }

  Padding followUs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://www.instagram.com/finobird2023/",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(
                  LineIcons.instagram,
                  color: Colors.pink,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://twitter.com/finobird2023",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(
                  LineIcons.twitter,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://www.linkedin.com/company/finobird",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(
                  LineIcons.linkedin,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://www.facebook.com/people/FinoBird/100090255406221/",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: Icon(
                  LineIcons.facebook,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          Text(
            "Follow Us",
            style: Styles.text,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Version 1.0.0",
              style: Styles.text.copyWith(
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    Get.defaultDialog(
      title: "Alert",
      titleStyle: Styles.semiBold,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Do you want to logout from the application?",
          textAlign: TextAlign.center,
          style: Styles.text,
        ),
      ),
      confirm: CustomElevatedButton(
        onPressed: () {
          Get.offAll(() => const Login());
          Fluttertoast.showToast(
            msg: "Logout successful",
            gravity: ToastGravity.BOTTOM,
          );
        },
        height: 45,
        color: Colors.red.shade500,
        child: Center(
          child: Text(
            'Logout',
            style: Styles.text.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CustomOutlineButton(
          onPressed: () {
            Get.back();
          },
          text: 'Cancel',
        ),
      ),
    );
  }
}
