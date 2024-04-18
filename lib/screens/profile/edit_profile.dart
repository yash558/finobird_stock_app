// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, unnecessary_final

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/models/user/profile.dart';
import 'package:finobird/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../repository/authentication.dart';
import '../../constants/styles.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var userProfile = Get.put(UserRepo());
  TextEditingController fname = TextEditingController(),
      lname = TextEditingController(),
      phone = TextEditingController();
  @override
  void dispose() {
    userProfile.getUserProfile();
    fname.dispose();
    lname.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Authentication authController = Get.put(Authentication());

    RxString path = "".obs;
    RxString avatarUrl = "".obs;

    Future.delayed(const Duration(seconds: 0), () async {
      fname.text = userProfile.profile.value.firstName ?? "";
      lname.text = userProfile.profile.value.lastName ?? "";
      phone.text = userProfile.profile.value.phoneNumber ?? "";
      avatarUrl.value = userProfile.profile.value.avatarUrl ?? "";
    });
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4AB5E5),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Form(
            key: formkey,
            autovalidateMode: authController.logAutovalidate.value,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      await uploadImage(path, avatarUrl, context);
                    },
                    child: Obx(
                      () => avatarUrl.value == ""
                          ? const CircleAvatar(
                              radius: 62,
                              backgroundColor: Color(0xFF4AB5E5),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Color(0xFF4AB5E5),
                                  ),
                                ),
                              ),
                            )
                          : avatarUrl.value == ""
                              ? SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      File(path.value),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      avatarUrl.value,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
                Text(
                  'Upload your Profile Pic',
                  textScaleFactor: 1,
                  style: Styles.text.copyWith(
                    color: const Color(0xFF4AB5E5),
                    fontSize: 15,
                  ),
                ),
                CustomTextField(
                  controller: fname,
                  text: 'First Name',
                  type: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter First Name.";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: lname,
                  text: 'Last Name',
                  type: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Last Name.";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: phone,
                  text: 'Phone Number',
                  type: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    } else if (value.length < 10) {
                      return "Please Enter atleast 10 digit.";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomElevatedButton(
        onPressed: () {
          if (formkey.currentState!.validate()) {
            UserProfile profile = UserProfile(
              id: userProfile.profile.value.id,
              firstName: fname.text,
              lastName: lname.text,
              phoneNumber: phone.text,
              avatarUrl: avatarUrl.value,
              email: userProfile.profile.value.email,
              role: userProfile.profile.value.role,
              username: userProfile.profile.value.username,
            );
            AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              animType: AnimType.rightSlide,
              title: 'Update Profile',
              desc: 'Are you sure you want to update your profile?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                await UserRepo().updateUserProfile(profile);
                await userProfile.getUserProfile();
              },
              btnOkColor: const Color(0xFF4AB5E5),
              titleTextStyle: Styles.semiBold,
              descTextStyle: Styles.text,
              buttonsTextStyle: Styles.text,
            ).show();

            authController.logAutovalidate.value = AutovalidateMode.disabled;
          } else {
            authController.logAutovalidate.value =
                AutovalidateMode.onUserInteraction;
          }
        },
        child: Center(
          child: Text(
            'Update Profile',
            textScaleFactor: 1,
            style: Styles.text.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future uploadImage(RxString path, RxString avatarUrl, BuildContext context) {
    return Get.bottomSheet(
      Container(
        height: 120,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () async {
                await ImagePicker.platform
                    .getImageFromSource(
                  source: ImageSource.gallery,
                )
                    .then((value) {
                  Get.back();
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    animType: AnimType.rightSlide,
                    title: 'Update Image',
                    desc:
                        'Are you sure you want to update your image. Because image is getting updated directly',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      var profile = Get.put(UserRepo());
                      path.value = value!.path;
                      profile.uploadAvatar(path.value).then((value) {
                        avatarUrl.value = value["avatarUrl"];
                      });
                    },
                    btnOkColor: const Color(0xFF4AB5E5),
                    titleTextStyle: Styles.semiBold,
                    descTextStyle: Styles.text,
                    buttonsTextStyle: Styles.text,
                  ).show();
                });
              },
              leading: const Icon(
                Icons.photo_album_rounded,
                color: Colors.black,
              ),
              title: Text(
                "Upload from gallery",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () async {
                await ImagePicker.platform
                    .getImageFromSource(
                  source: ImageSource.camera,
                )
                    .then((value) {
                  path.value = value!.path;
                });
                Get.back();
              },
              leading: const Icon(
                Icons.camera,
                color: Colors.black,
              ),
              title: Text(
                "Upload from camera",
                style: Styles.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
