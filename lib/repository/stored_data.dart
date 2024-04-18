// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StoredData extends GetxController {
//   RxString username = "".obs;
//   RxString password = "".obs;

//   storeUsernamePassword(String username, String password) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     preferences.setString("username", username).then((value) {
//       if (value) {
//         log("username saved");
//       }
//     });
//     preferences.setString("password", password).then((value) {
//       if (value) {
//         log("password saved");
//       }
//     });
//   }

//   getUsernamePassword() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     username.value = preferences.getString("username")!;
//     password.value = preferences.getString("password")!;
//     update();
//     notifyChildrens();
//   }
// }
