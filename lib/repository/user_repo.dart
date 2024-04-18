import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/user/profile.dart';
import 'authentication.dart';
import 'constants.dart';

class UserRepo extends GetxController {
  var baseUrl = "${Constants.baseUrl}/api/v1/user/profile";
  var baseAddDeviceUrl = "${Constants.baseUrl}/api/v1/notification/add-device";
  Rx<UserProfile> profile = UserProfile().obs;

  Future<UserProfile?> getUserProfile() async {
    var request = http.Request('GET', Uri.parse(baseUrl));
    request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // // log(data);
      profile.value = UserProfile.fromJson(
        jsonDecode(data),
      );
      update();
      notifyChildrens();
      return profile.value;
    } else {
      log(response.reasonPhrase.toString());
      return null;
    }
    // return null;
  }

  updateUserProfile(UserProfile profile) async {
    var request = http.Request('POST', Uri.parse("$baseUrl/update"));
    request.body = jsonEncode(profile.toJson());
    request.headers.addAll({
      'Authorization': 'Bearer ${accessToken.value}',
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();
    log(profile.toJson().toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      log("success");
      log(await response.stream.bytesToString());
      Get.back();
      Fluttertoast.showToast(msg: "Profile Updated Successfully");
    } else {
      log(await response.stream.bytesToString());
      Fluttertoast.showToast(msg: "Profile Update Failed");
    }
  }

  uploadAvatar(String filePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/update/avatar'),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar',
        filePath,
      ),
    );

    request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      return jsonDecode(data);
    } else {
      log(response.reasonPhrase.toString());
    }
  }


  addUserDeviceToken(String token) async {
    print('D-token --> $token');
    var request = http.Request('POST', Uri.parse(baseAddDeviceUrl));
    request.body = jsonEncode({'deviceId':token});
    request.headers.addAll({
      'Authorization': 'Bearer ${accessToken.value}',
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      log("success");
      print(await response.stream.bytesToString());
     // Get.back();
    //  Fluttertoast.showToast(msg: "Profile Updated Successfully");
    } else {
      log(await response.stream.bytesToString());
  //    Fluttertoast.showToast(msg: "Profile Update Failed");
    }
  }

}
