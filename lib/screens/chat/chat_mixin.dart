import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../custom/custom_elevated_button.dart';
import '../../custom/textfield.dart';
import '../../models/chat/get_community_messages.dart';
import '../../repository/authentication.dart';
import '../../repository/chat_repo.dart';
import '../../repository/community_repo.dart';
import '../../repository/constants.dart';
import '../../repository/user_repo.dart';
import '../../constants/styles.dart';

mixin ChatMixin {
  final CommunitiesRepo repo = Get.put(CommunitiesRepo());
  final chats = Get.put(ChatRepo());
  final question = TextEditingController();
  final RxString path = "".obs;
  Socket? socket;
  RxBool isFetching = false.obs;
  var user = Get.put(UserRepo());

  Future<void> connectServer(String chatId) async {
    try {
      socket = io(
        Constants.baseUrl,
        OptionBuilder().setTransports(['websocket']).setExtraHeaders({
          'authorization': "Bearer ${accessToken.value}",
        }).build(),
      );
      bool connected = socket!.connect().connected;
      log("connected: $connected");

      socket!.onConnect((_) {
        log("Connected to the socket");
      });

      Future.delayed(const Duration(seconds: 2), () {
        log("sending join community request to socket");
        socket!.emitWithAck(
          'joinCommunityChat',
          {
            "chatId": chatId,
            "chatType": "community",
          },
          ack: (data) {
            log(data.toString());
          },
        );
      });

      socket!.on("incomingMessage", (data) {
        log("message came");
        // log(data.toString());
        log("====>> socket data $data");
        // Messages messages = Messages(
        //     senderId: user.profile.value.id,
        //     id: chats.messages.value.messages!.last.id! + 1,
        //     sender: Sender(
        //         id: user.profile.value.id,
        //         username: user.profile.value.username),
        //     date: DateTime.now().toIso8601String());

        log("====>> socket length  ");
        chats.messages.value.messages!.add(Messages.fromJson(data['data']));
        chats.messages.refresh();
        log("====>> socket length ++++ ${chats.messages.value.messages!.length}");
      });

      // socket!.onAny((event, data) {
      //   log("Event : $event");
      //   log(data.toString());
      // });
    } catch (e) {
      log(e.toString());
    }
  }

  void sendDoubleMessage(String msg1, String msg2, String chatId,
      String messageType1, String messageType2, Sender senderData) {
    Map datas = {
      "content": [
        {
          "type": messageType1,
          "text": msg1,
        },
        {
          "type": messageType2,
          "text": msg2,
        }
      ],
      "chatId": chatId,
      "chatType": "community",
      "senderId": user.profile.value.id,
      "timeStamp": DateTime.now().toIso8601String(),
      "likes": 0,
      "reactions": [],
      "sender": senderData.toJson(),
    };

    socket!.emitWithAck(
      'message',
      datas,
      ack: (data) {
        log(" ===== >>> ${datas.toString()}");
      },
    );
  }

  void sendMessage(
      String msg, String chatId, String messageType, Sender senderData) {

    Map datas = {
      "content": [
        {
          "type": messageType,
          "text": msg,
        }
      ],
      "chatId": chatId,
      "chatType": "community",
      "senderId": user.profile.value.id,
      "timeStamp": DateTime.now().toIso8601String(),
      "likes": 0,
      "reactions": [],
      "sender": senderData.toJson(),
    };
     print('datas --> ${datas.toString()}');
    socket!.emitWithAck(
      'message',
      datas,
      ack: (data) {
        log(" ===== >>> ${datas.toString()}");
      },
    );
  }


  void sendReactionsMessage(int messageId,String reaction) {
    log((socket == null).toString());
    socket!.emitWithAck(
      'addReaction',
      {
          "messageId": messageId,
          "reaction": reaction
      },
      ack: (data) {
        print('data  --> ${data.toString()}');
        log(data.toString());
      },
    );
  }

  void sendReplyMessage(String msg, String chatId, int messageId,
      {required String messageType}) {
    log((socket == null).toString());
    socket!.emitWithAck(
      'message',
      {
        "content": [
          {
            "type": messageType,
            "text": msg,
          }
        ],
        "chatId": chatId,
        "chatType": "community",
        "senderId": user.profile.value.id,
        "timeStamp": DateTime.now().toIso8601String(),
        "likes": 0,
        "inReplyToId": messageId,
        "reactions": [],
      },
      ack: (data) {
        log(data.toString());
      },
    );
  }

  void sendReplyDoubleMessage(
      String msg1, String msg2, String chatId, int messageId,
      {required String messageType1, required String messageType2}) {
    log((socket == null).toString());
    socket!.emitWithAck(
      'message',
      {
        "content": [
          {
            "type": messageType1,
            "text": msg1,
          },
          {
            "type": messageType2,
            "text": msg2,
          }
        ],
        "chatId": chatId,
        "chatType": "community",
        "senderId": user.profile.value.id,
        "timeStamp": DateTime.now().toIso8601String(),
        "likes": 0,
        "inReplyToId": messageId,
        "reactions": [],
      },
      ack: (data) {
        log(data.toString());
      },
    );
  }

  Future getBottomSheet(
    int communityId,
    String title,
    String numbers,
    String description,
  ) {
    return Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          Get.back();
          Get.back();
          return false;
        },
        child: Container(
          height: 270,
          decoration: BoxDecoration(
            color: Colors.teal.shade500,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/Fino Bird.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  title: Text(
                    title,
                    textScaleFactor: 1,
                    style: Styles.text.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  // subtitle: Text(
                  //   "$numbers members",
                  //   textScaleFactor: 1,
                  //   style: Styles.subtitleSmall,
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: Styles.subtitleSmall,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () async {
                    await CommunitiesRepo().joinCommunity(communityId);
                    Get.back();
                  },
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Join Community',
                      textScaleFactor: 1,
                      style: Styles.text.copyWith(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  void showMessageOptions(String messageId) {
    Get.bottomSheet(
      Container(
        height: 3 * 60,
        decoration: const BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                // Get.to(
                //   () => Replies(
                //     question: questions.value[index],
                //     questionId: questionId,
                //   ),
                // );
              },
              leading: const Icon(LineIcons.reply),
              title: Text(
                "Go to replies",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                showReportQuestionOptions(messageId);
              },
              leading: const Icon(Icons.report),
              title: Text(
                "Report Question",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                showReportUserOptions();
              },
              leading: const Icon(Icons.person),
              title: Text(
                "Report User",
                style: Styles.text,
              ),
            ),
          ],
        ),
      ),
      elevation: 2,
    );
  }

  void showReportQuestionOptions(String messageId) {
    var controller = TextEditingController();
    Get.bottomSheet(
      Container(
        height: 6 * 53,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                log("tapped");
                chats.reportMessage(
                  messageId,
                  "Report question as inappropriate",
                );
                Get.back();
                Get.back();
              },
              title: Text(
                "Report question as inappropriate",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {
                chats.reportMessage(
                  messageId,
                  "Report question as inappropriate",
                );
                Get.back();
                Get.back();
              },
              title: Text(
                "Report harmful content",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {
                chats.reportMessage(
                  messageId,
                  "Report question as inappropriate",
                );
                Get.back();
                Get.back();
              },
              title: Text(
                "Report abuse",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {
                chats.reportMessage(
                  messageId,
                  "Report question as inappropriate",
                );
                Get.back();
                Get.back();
              },
              title: Text(
                "Other",
                style: Styles.text,
              ),
            ),
            CustomTextField(
              controller: controller,
              text: "Please Specify",
              type: TextInputType.text,
            ),
          ],
        ),
      ),
      elevation: 2,
    );
  }

  void showReportUserOptions() {
    var controller = TextEditingController();
    Get.bottomSheet(
      Container(
        height: 5 * 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {},
              title: Text(
                "Report Spam",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Harmful Content",
                style: Styles.text,
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text(
                "Other",
                style: Styles.text,
              ),
            ),
            CustomTextField(
              controller: controller,
              text: "Please Specify",
              type: TextInputType.text,
            ),
          ],
        ),
      ),
      elevation: 2,
    );
  }
}
