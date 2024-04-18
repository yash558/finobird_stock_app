import 'dart:developer';

import 'package:finobird/screens/chat/chat_mixin.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../models/chat/get_community_messages.dart';

class RepliesScreen extends StatefulWidget {
  const RepliesScreen({
    super.key,
    required this.question,
    required this.questionId,
    required this.chatId,
  });

  final String question;
  final int questionId;
  final String chatId;

  @override
  State<RepliesScreen> createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> with ChatMixin {
  final msg = TextEditingController();

  @override
  void initState() {
    connectServer(widget.chatId);
    chats.fetchReplies(widget.questionId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          backgroundColor: Colors.teal.shade800,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(13),
              child: Text(
                'Replies',
                style: Styles.text.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // actions: [
          //   menu(context),
          // ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/chat_background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          // Positioned(
          //   top: 0,
          //   child: Container(
          //     width: Get.width,
          //     padding: EdgeInsets.only(
          //         top: Get.height * .005, bottom: Get.height * .003),
          //     color: Colors.teal.shade500,
          //     child: ListTile(
          //       dense: true,
          //       title: Text(
          //         'PINNED MESSAGE',
          //         style: Styles.text.copyWith(
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //             fontSize: 18),
          //       ),
          //       subtitle: Text(
          //         widget.question.toString(),
          //         overflow: TextOverflow.ellipsis,
          //         style: const TextStyle(
          //           fontWeight: FontWeight.w400,
          //           color: Colors.white,
          //           fontSize: 15,
          //         ),
          //         maxLines: 2,
          //       ),
          //       trailing: const Icon(
          //         Icons.push_pin,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chats.replies.value.message?.replies?.length ?? 0,
                  itemBuilder: (context, index) {
                    // List<Content> messages = chats
                    //     .replies.value.message!.replies![index].content!
                    //     .cast<Content>();
                    return Container();
                    // UserChatCard(
                    //   isReplayId: null,
                    //   message: messages,
                    //   time:
                    //       "${chats.replies.value.message!.replies![index].date!.split("T")[1].split(".")[0].split(":")[0]}:${chats.replies.value.message!.replies![index].date!.split("T")[1].split(".")[0].split(":")[1]}",
                    // );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: const Color.fromARGB(255, 14, 109, 101),
                  child: Expanded(
                    child: Card(
                      color: const Color.fromARGB(255, 4, 77, 69),
                      margin: EdgeInsets.only(
                        left: Get.width * .02,
                        right: Get.width * .02,
                        bottom: Get.height * .01,
                        top: Get.height * .01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: msg,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                if (value.isNotEmpty) {}
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message...",
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                contentPadding: EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                              ),
                              onFieldSubmitted: (text) {
                                // sendReplyMessage(
                                //   text,
                                //   widget.chatId,
                                //   widget.questionId,
                                // );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: Get.width * .02),
                            child: InkWell(
                              onTap: () {
                                log(msg.text);
                                log(widget.chatId);
                                log(widget.questionId.toString());
                                // sendReplyMessage(
                                //   msg.text,
                                //   widget.chatId,
                                //   widget.questionId,
                                // );
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
