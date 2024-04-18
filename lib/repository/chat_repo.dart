// ignore_for_file: unnecessary_final

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:finobird/repository/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

import '../models/chat/get_chat_list.dart';
import '../models/chat/get_community_messages.dart';
import '../models/chat/get_replies.dart';
import 'authentication.dart';

class ChatRepo extends GetxController {
  static const baseUrl = "${Constants.baseUrl}/api/v1/chat/messages";
  final dio = Dio();
  Rx<GetChatLists> chats = GetChatLists().obs;
  Rx<GetCommunityMessages> messages = GetCommunityMessages().obs;
  Rx<GetReplies> replies = GetReplies().obs;
  // final String folderPath = "/storage/emulated/0/finobird/";
  int count = 100;

  fetchMessages(String chatId, String type) async {
    print('chatId  ${chatId}   type  ${type}');
    print('${accessToken.value}');
    try {
      var request = http.Request('GET', Uri.parse(baseUrl));
      request.body = jsonEncode({
        "chatId": chatId,
        "chatType": type,
        "count": count,
        "reverse": true,
      });

      request.headers.addAll({
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${accessToken.value}",
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String data = await response.stream.bytesToString();
        log(data);
        if (messages.value.messages != null) {
          debugPrint(
              "messages.value.messages.length ${messages.value.messages!.length}");
        }

        messages.value = GetCommunityMessages.fromJson(jsonDecode(data));
        debugPrint(
            "messages.value.messages.length 123 ${messages.value.messages!.length}");
        count += 100;
        update();
        notifyChildrens();
      } else {
        log(response.statusCode.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  reportMessage(String messageId, String reason) async {
    try {
      var request = http.Request(
        'POST',
        Uri.parse(
          '$baseUrl/$messageId/report',
        ),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());
        Fluttertoast.showToast(msg: "Question Reported Successfully");
      } else {
        log(response.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  fetchReplies(int messageId) async {
    var request = http.Request('GET', Uri.parse('$baseUrl/$messageId/replies'));

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      replies.value = GetReplies.fromJson(jsonDecode(data));
      update();
      notifyChildrens();
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  Future<void> getChats() async {
    try {
      var request =
          http.Request('GET', Uri.parse('${Constants.baseUrl}/api/v1/chat'));

      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

      // log("hellow this is data ${accessToken.value}");

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var json = await response.stream.bytesToString();
        log("hellow this is data $json");
        chats.value = GetChatLists.fromJson(jsonDecode(json));
        update();
        notifyChildrens();
      } else {
        log(response.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future uploadChatImage(String filePath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${Constants.baseUrl}/api/v1/chat/media/upload'));

      request.files.add(
        await http.MultipartFile.fromPath(
          'media',
          filePath,
        ),
      );

      request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});

      log("hellow this is data ${accessToken.value}");

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        // // log(data);
        return jsonDecode(data);
      } else {
        log(response.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future reportUserChat({required String messageId}) async {
    var request = http.Request('POST', Uri.parse('$baseUrl/$messageId/report'));
    request.headers.addAll({"Authorization": "Bearer ${accessToken.value}"});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      log(await response.stream.bytesToString());
      log("community joined");
      Fluttertoast.showToast(msg: "REPORTED");
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  Future<String> getAppDocPath() async {
    // if (Platform.isAndroid) {
    //   final appDir = await getExternalStorageDirectory();
    //   return "${appDir!.path}/finobird";
    // } else {
    final appDir = await getApplicationDocumentsDirectory();
    return "${appDir.path}/finobird";
    // }
  }

  Future openTheFiles(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        title: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    final dir = await getAppDocPath();
    if (!await File("$dir/${message.split("/").last}").exists()) {
      debugPrint("object");
      await startDownloading(message);

      log("object hey bro");
      Get.back();
      if (await File("$dir/${message.split("/").last}").exists()) {
        OpenFilex.open("$dir/${message.split("/").last}");
      }
    } else {
      log("object helllow 123");
      log("path $dir/${message.split("/").last}");
      Get.back();
      OpenFilex.open("$dir/${message.split("/").last}");
    }
  }

  /// get download folder
  Future<String> _getFilePath(String filename) async {
    log("==>>> get file path $filename");
    final dir = await getAppDocPath();

    log("==>>> get file path $filename");
    // if (Platform.isAndroid) {
    log("==>>> get file path $filename");
    if (!await Directory("$dir/$filename").exists()) {
      log("==>>> get file path non $filename");
      await Directory(dir).create(recursive: true);
      log("==>>> get file path $filename");
    }
    log("==>>> get file path lol $filename");
    return "$dir/$filename";
    // } else {
    //   return "${dir.path}/$filename";
    // }
  }

  Future startDownloading(String url) async {
    await [
      Permission.storage,
      //add more permission to request here.
    ].request().then((value) async {
      String fileName = url.split('/').last;
      if (value[Permission.storage]!.isGranted) {
        try {
          log("object hellow guys");
          String path = await _getFilePath(fileName);
          // log('++..$path $url');
          log("object hellow guys");
          await dio.download(
            url,
            path,
            onReceiveProgress: (recivedBytes, totalBytes) {
              // setState(() {
              // progress = recivedBytes / totalBytes;
              // });
            },
            deleteOnError: true,
          ).then((_) {
            // Navigator.pop(context);
            // commonToast(context, "$fileName Download Successfully",
            Fluttertoast.showToast(msg: "Download Successfully");
            //     color: secondaryBlue);
          });
        } catch (err) {
          // Navigator.pop(context);

          Fluttertoast.showToast(msg: "Unable to download PDF");
          log("err===>>> $err");
        }
      } else {
        // Navigator.pop(context);
        await Permission.storage.request();
        Fluttertoast.showToast(msg: "No permission to read and write.");
        // log("No permission to read and write.");
      }
    });
  }
}
