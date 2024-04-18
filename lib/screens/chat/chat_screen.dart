import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finobird/custom/custom_elevated_button.dart';
import 'package:finobird/custom/textfield.dart';
import 'package:finobird/screens/chat/attachment_review_screen.dart';
import 'package:finobird/screens/chat/membersScreen.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';

import '../../custom/Reply_Chat_card.dart';
import '../../custom/User_chat_card.dart';
import '../../custom/custom_watchlist_card.dart';
import '../../models/chat/get_chat_list.dart';
import '../../models/chat/get_community_messages.dart';
import '../../repository/chat_repo.dart';
import '../../repository/community_repo.dart';
import '../../repository/user_repo.dart';
import '../feeds/company.dart';
import 'chat_mixin.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {super.key,
      required this.title,
      required this.members,
      // required this.community,
      required this.isJoined,
      this.chat,
      required this.chatId,
      required this.communityId,
      this.notificationCommunityId});

  String title;
  final String members;
  String chatId;
  final int communityId;

  // final Community community;
  final bool isJoined;
  Chats? chat;
  String? notificationCommunityId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with ChatMixin {
  final ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  FocusNode focusNodeImage = FocusNode();
  FocusNode focusNodeReplay = FocusNode();
  bool fetchingMore = false;

  final TextEditingController replayText = TextEditingController();
  final TextEditingController imageText = TextEditingController();

  setNotificationOnTap() async {
    if (widget.notificationCommunityId != null) {
      await repo
          .getCommunityDetailsStringId(widget.notificationCommunityId!)
          .then((value) {
        setState(() {
          widget.title = repo.communityProfile.value.company!.name.toString();
          widget.chatId = repo.communityProfile.value.chatId.toString();
          widget.chat = Chats(
              avatarUrl: repo.communityProfile.value.avatarUrl.toString(),
              chatId: repo.communityProfile.value.chatId.toString(),
              companyId: repo.communityProfile.value.company!.id,
              name: repo.communityProfile.value.company!.name.toString(),
              id: repo.communityProfile.value.id,
              description: repo.communityProfile.value.description.toString());
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isFetching.value = true;
    setNotificationOnTap();
    user.getUserProfile();
    repo.getCommunityDetails(widget.communityId);

    Future.delayed(const Duration(seconds: 0), () async {
      if (!widget.isJoined) {
        await getBottomSheet(
          widget.communityId,
          widget.title,
          widget.members,
          widget.chat?.description ?? "",
        );
      }

      await chats.fetchMessages(widget.chatId, "community");

      if (scrollController.keepScrollOffset &&
          chats.messages.value.messages != null) {
        debugPrint("object guys lol");
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => scrollController.animateTo(
              scrollController.position.maxScrollExtent * 2,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 1000)),
        );
      }
      isFetching.value = false;
      await connectServer(widget.chatId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // socket!.close();
    imageText.dispose();
    replayText.dispose();
    focusNode.dispose();
    focusNodeImage.dispose();
    focusNodeReplay.dispose();
    chats.getChats().then((value) {
      debugPrint("object chats ${chats.chats}");
    });
    chats.count = 100;

    scrollController.dispose();
  }

  Future<void> _handleRefresh() async {
    debugPrint(
        "chats.messages.value.messages ${chats.messages.value.messages!.length}");
    debugPrint("chats.count ${chats.count}");
    if (chats.messages.value.messages!.length >= chats.count - 100 &&
        chats.messages.value.messages != null) {
      await Future.delayed(const Duration(seconds: 1), () async {
        await chats.fetchMessages(widget.chatId, "community");
      });
    } else {
      Fluttertoast.showToast(msg: "No More Data");
    }
  }

  List<InkWell> emojiIcon(BuildContext context, int messageId, int chatIndex) {
    List<String>? emoji = [
      "\u{1F642}",
      "\u{1F60B}",
      "\u{1F604}",
      "\u{1F607}",
      "\u{1F60D}",
    ];
    return List.generate(
      emoji.length,
      (index) => InkWell(
        onTap: () async {
          // print('messageId ---> $messageId emoji  ${emoji[index].trim().toString()}');

          setState(() {
            chats.messages.value.messages![chatIndex].isReaction = false;
          });
          sendReactionsMessage(messageId, emoji[index].trim().toString());
          await chats.fetchMessages(widget.chatId, "community");
        },
        child: Text(
          emoji[index],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("object hellow ${widget.chat!.avatarUrl!}");
    return GestureDetector(
      onTap: () {
        if (chats.messages.value.messages!.isNotEmpty) {
          for (int i = 0; i <= chats.messages.value.messages!.length; i++) {
            if (chats.messages.value.messages![i].isReaction == true) {
              setState(() {
                chats.messages.value.messages![i].isReaction = false;
              });
            }
          }
        }

        focusNode.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            backgroundColor: const Color.fromARGB(255, 4, 77, 69),
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back,
                      size: 24, color: Colors.white),
                ),
              ],
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: const Color(0xFF4AB5E5),
                      child: (widget.chat != null &&
                              widget.chat!.avatarUrl != null)
                          ? Image.network(
                              widget.chat!.avatarUrl!,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              CupertinoIcons.person_3_fill,
                              size: 25,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      focusNode.unfocus();
                      CommunitiesRepo repo = Get.put(CommunitiesRepo());
                      await repo.getCommunityDetails(
                        widget.communityId,
                      );
                      (repo.communityProfile.value.company != null)
                          ? Get.to(
                              () => CompanyDetails(
                                // community: widget.community,
                                ticker: repo
                                    .communityProfile.value.company!.ticker!,
                                companyDetails:
                                    repo.communityProfile.value.company!,
                              ),
                            )
                          : null;
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.semiBold.copyWith(
                              color: Colors.white,
                              fontSize: Get.size.width * 0.034,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  focusNode.unfocus();
                  Get.to(
                    () => MembersScreen(
                      id: widget.communityId,
                    ),
                  );
                },
                icon: const Icon(LineIcons.alternateUser, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  focusNode.unfocus();
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    animType: AnimType.bottomSlide,
                    title: 'Leave Community',
                    desc: 'Are you sure you want to leave this community?',
                    btnCancelOnPress: () {
                      Get.back();
                    },
                    btnOkOnPress: () async {
                      if (widget.chat != null) {
                        await repo.leaveCommunity(widget.chat!.id!);
                      }

                      Get.back();
                    },
                    width: 400,
                    titleTextStyle: Styles.semiBold,
                    descTextStyle: Styles.text,
                    buttonsTextStyle: Styles.text,
                  ).show();
                },
                icon: const Icon(Icons.exit_to_app_sharp, color: Colors.white),
              ),
            ],
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Image.asset(
                    "assets/chat_background.png",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Obx(
                    () => isFetching.value
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.transparent,
                          ))
                        : chats.messages.value.messages != null
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: RefreshIndicator(
                                  onRefresh: _handleRefresh,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    itemCount:
                                        chats.messages.value.messages!.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          QuestionWidget(
                                            reaction: chats
                                                    .messages
                                                    .value
                                                    .messages![index]
                                                    .reactions ??
                                                [],
                                            onLongPress: () {
                                              if (chats.messages.value.messages!
                                                  .isNotEmpty) {
                                                for (int i = 0;
                                                    i <=
                                                        chats.messages.value
                                                            .messages!.length;
                                                    i++) {
                                                  if (chats.messages.value
                                                          .messages![i].id ==
                                                      chats
                                                          .messages
                                                          .value
                                                          .messages![index]
                                                          .id) {
                                                    setState(() {
                                                      chats
                                                          .messages
                                                          .value
                                                          .messages![i]
                                                          .isReaction = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      chats
                                                          .messages
                                                          .value
                                                          .messages![i]
                                                          .isReaction = false;
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                            messageId: chats.messages.value
                                                .messages![index].id,
                                            onTap: (bool value) {
                                              if (value) {
                                                focusNode.unfocus();
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return showReplayBottomSheet(
                                                        chats
                                                                    .messages
                                                                    .value
                                                                    .messages![
                                                                        index]
                                                                    .content!
                                                                    .length ==
                                                                1
                                                            ? (chats
                                                                    .messages
                                                                    .value
                                                                    .messages![
                                                                        index]
                                                                    .content![0]
                                                                    .text ??
                                                                "")
                                                            : (chats
                                                                    .messages
                                                                    .value
                                                                    .messages![
                                                                        index]
                                                                    .content![1]
                                                                    .text ??
                                                                ""),
                                                        chats
                                                            .messages
                                                            .value
                                                            .messages![index]
                                                            .id!,
                                                        chats
                                                                .messages
                                                                .value
                                                                .messages![
                                                                    index]
                                                                .senderId ==
                                                            user.profile.value
                                                                .id,
                                                        chats
                                                            .messages
                                                            .value
                                                            .messages![index]
                                                            .sender!
                                                            .firstName);
                                                  },
                                                ).then((value) =>
                                                    replayText.clear());
                                              }
                                            },
                                            userImage: chats
                                                .messages
                                                .value
                                                .messages![index]
                                                .sender
                                                ?.avatarUrl,
                                         

                                            chatDescription: chats.messages
                                                .value.messages![index].content,
                                            time: (chats.messages.value
                                                            .messages !=
                                                        null &&
                                                    chats
                                                            .messages
                                                            .value
                                                            .messages![index]
                                                            .date !=
                                                        null)
                                                ? "${chats.messages.value.messages![index].date!.split("T")[1].split(".")[0].split(":")[0]}:${chats.messages.value.messages![index].date!.split("T")[1].split(".")[0].split(":")[1]}"
                                                : "",
                                            index: index,
                                            isSender:
                                                chats.messages.value.messages !=
                                                        null
                                                    ? chats
                                                            .messages
                                                            .value
                                                            .messages![index]
                                                            .senderId ==
                                                        user.profile.value.id
                                                    : false,
                                            questionId: (chats.messages.value
                                                            .messages !=
                                                        null &&
                                                    chats
                                                            .messages
                                                            .value
                                                            .messages![index]
                                                            .id !=
                                                        null)
                                                ? chats.messages.value
                                                    .messages![index].id!
                                                : 0,
                                            username: (chats.messages.value
                                                            .messages !=
                                                        null &&
                                                    chats
                                                            .messages
                                                            .value
                                                            .messages![index]
                                                            .sender !=
                                                        null)
                                                ? chats
                                                    .messages
                                                    .value
                                                    .messages![index]
                                                    .sender!
                                                    .firstName
                                                : "",
                                            chatId: widget.chatId,
                                            isReplayId:
                                                chats.messages.value.messages !=
                                                        null
                                                    ? chats
                                                        .messages
                                                        .value
                                                        .messages![index]
                                                        .inReplyToId
                                                    : null,
                                          ),
                                          chats.messages.value.messages![index]
                                                      .isReaction ==
                                                  true
                                              ? Positioned(
                                                  top: 0,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      // color: Colors.redAccent.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1),
                                                      border: Border.all(
                                                        // color: Colors.black,
                                                        color: Colors.white,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              30),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ...emojiIcon(
                                                              context,
                                                              chats
                                                                  .messages
                                                                  .value
                                                                  .messages![
                                                                      index]
                                                                  .id!,
                                                              index),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 14, 109, 101),
                  padding: EdgeInsets.only(
                    left: Get.width * .02,
                    right: Get.width * .04,
                    bottom: Get.height * .01,
                    top: Get.height * .01,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: const Color.fromARGB(
                              255,
                              4,
                              77,
                              69,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      focusNode: focusNode,
                                      // textAlignVertical: TextAlignVertical.center,
                                      textInputAction: TextInputAction.done,
                                      controller: question,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      minLines: 1,
                                      style: Styles.text.copyWith(
                                          color: Colors.white, fontSize: 18),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {}
                                      },
                                      decoration: InputDecoration(
                                        // fillColor: Color(0xFF4AB5E5),
                                        border: InputBorder.none,
                                        hintText: "Type a message...",
                                        hintStyle: Styles.text.copyWith(
                                            color: Colors.white, fontSize: 18),
                                        contentPadding: const EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      focusNode.unfocus();
                                      debugPrint("object");
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) =>
                                            SafeArea(child: bottomSheet()),
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/paper-pin.png",
                                      height: 23,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (question.text.trim().isNotEmpty) {
                              // focusNode.unfocus();
                              debugPrint(
                                  "question.text.isNotEmpty ${question.text}");

                              sendMessage(
                                question.text,
                                widget.chatId,
                                "text",
                                // null sender
                                Sender(
                                  username: user.profile.value.username,
                                  firstName: user.profile.value.firstName,
                                  lastName: user.profile.value.lastName,
                                  avatarUrl: user.profile.value.avatarUrl,
                                ),
                              );
                              if (chats.messages.value.messages == null) {
                                Messages data = Messages(
                                    content: [
                                      Content(
                                        text: question.text.trim(),
                                        type: "text",
                                      )
                                    ],
                                    senderId: user.profile.value.id,
                                    id: 1,
                                    sender: Sender(
                                      username: user.profile.value.username,
                                      firstName: user.profile.value.firstName,
                                      lastName: user.profile.value.lastName,
                                      avatarUrl: user.profile.value.avatarUrl,
                                    ),
                                    date: DateTime.now().toIso8601String());
                                chats.messages.value.messages = [data];
                              } else {
                                Messages data = Messages(
                                    content: [
                                      Content(
                                        text: question.text.trim(),
                                        type: "text",
                                      )
                                    ],
                                    senderId: user.profile.value.id,
                                    id: chats.messages.value.messages!.isEmpty
                                        ? 1
                                        : chats.messages.value.messages!.last
                                                .id! +
                                            1,
                                    sender: Sender(
                                      username: user.profile.value.username,
                                      firstName: user.profile.value.firstName,
                                      lastName: user.profile.value.lastName,
                                      avatarUrl: user.profile.value.avatarUrl,
                                    ),
                                    date: DateTime.now().toIso8601String());
                                chats.messages.value.messages!.add(data);
                              }

                              chats.messages.refresh();
                              question.clear();
                              if (scrollController.keepScrollOffset) {
                                SchedulerBinding.instance.addPostFrameCallback(
                                  (_) => scrollController.jumpTo(
                                      scrollController
                                          .position.maxScrollExtent),
                                );
                              }
                            } else {
                              log("cannot add empty question");
                              question.clear();
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet({bool isreplay = false, int? isreplayMessageId}) {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              iconCreation(Icons.insert_drive_file, Colors.blue, "Document",
                  () async {
                try {
                  await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'pdf',
                      'doc',
                      'docx',
                      'txt'
                    ], // You can specify the type of files to allow the user to pick.
                  ).then((value) {
                    Get.back();
                    if (value != null) {
                      String? filePath = value.files.single.path;
                      if (filePath != null) {
                        // Use the selected file path as needed (e.g., upload to a server, read the file, etc.).
                        debugPrint('Selected file path: $filePath');
                        path.value = filePath;

                        File pickedFile = File(value.files.single.path!);

                        int maxSizeBytes = 5 * 1024 * 1024; // 5MB
                        if (pickedFile.lengthSync() <= maxSizeBytes) {
                          showModalBottomSheet(
                                  backgroundColor: Colors.black,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => SafeArea(
                                      child: imageBottomSheet("doc",
                                          isreplay: isreplay,
                                          replayMessageId: isreplayMessageId)))
                              .then((value) {
                            if (isreplay) {
                              Get.back();
                            }
                          });
                        } else {
                          // Display an error message if the image exceeds the size limit
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Image Size Limit Exceeded'),
                                content: const Text(
                                    'Please select an doc below 5MB in size.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      // User canceled the file picking.
                      Fluttertoast.showToast(msg: "File picking canceled.");
                    }
                  });
                } catch (e) {
                  // Handle any exceptions that might occur during file picking.
                  debugPrint('Error while picking a file: $e');
                }
              }),
              iconCreation(Icons.headphones, Colors.orange, "Audio", () async {
                await FilePicker.platform
                    .pickFiles(
                  type: FileType.audio,
                )
                    .then((value) {
                  Get.back();
                  if (value != null) {
                    String? filePath = value.files.single.path;
                    if (filePath != null) {
                      // Use the selected file path as needed (e.g., upload to a server, read the file, etc.).
                      debugPrint('Selected file path: $filePath');
                      path.value = filePath;

                      File pickedFile = File(value.files.single.path!);

                      int maxSizeBytes = 5 * 1024 * 1024; // 5MB
                      if (pickedFile.lengthSync() <= maxSizeBytes) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 85, 77),
                            title: Text(
                              "send \"${filePath.split("/").last.split(".").first}\" to \"${widget.title}\"?",
                              style: Styles.text.copyWith(
                                  fontSize: Get.size.width * 0.04,
                                  color: Colors.white),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                onPressed: () async {
                                  Get.back();
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
                                  if (isreplay) {
                                    await chats
                                        .uploadChatImage(path.value)
                                        .then((value) {
                                      String imageUrl =
                                          value[0]["url"] as String;
                                      debugPrint("value[url] $imageUrl");
                                      sendReplyMessage(imageUrl, widget.chatId,
                                          isreplayMessageId!,
                                          messageType: "audio");
                                      if (chats.messages.value.messages ==
                                          null) {
                                        Messages data = Messages(
                                            content: [
                                              Content(
                                                  text: imageUrl, type: "audio")
                                            ],
                                            senderId: user.profile.value.id,
                                            id: 1,
                                            sender: Sender(
                                              username:
                                                  user.profile.value.username,
                                              firstName:
                                                  user.profile.value.firstName,
                                              lastName:
                                                  user.profile.value.lastName,
                                              avatarUrl:
                                                  user.profile.value.avatarUrl,
                                            ),
                                            date: DateTime.now()
                                                .toIso8601String(),
                                            inReplyToId: isreplayMessageId);
                                        chats.messages.value.messages = [data];
                                      } else {
                                        Messages data = Messages(
                                            content: [
                                              Content(
                                                  text: imageUrl, type: "audio")
                                            ],
                                            senderId: user.profile.value.id,
                                            id: chats.messages.value.messages!
                                                    .isEmpty
                                                ? 1
                                                : chats.messages.value.messages!
                                                        .last.id! +
                                                    1,
                                            sender: Sender(
                                              username:
                                                  user.profile.value.username,
                                              firstName:
                                                  user.profile.value.firstName,
                                              lastName:
                                                  user.profile.value.lastName,
                                              avatarUrl:
                                                  user.profile.value.avatarUrl,
                                            ),
                                            date: DateTime.now()
                                                .toIso8601String(),
                                            inReplyToId: isreplayMessageId);
                                        chats.messages.value.messages!
                                            .add(data);
                                      }
                                      chats.messages.refresh();
                                      question.clear();
                                      if (scrollController.keepScrollOffset) {
                                        SchedulerBinding.instance
                                            .addPostFrameCallback(
                                          (_) => scrollController.jumpTo(
                                              scrollController
                                                  .position.maxScrollExtent),
                                        );
                                      }
                                    });
                                  } else {
                                    await chats
                                        .uploadChatImage(path.value)
                                        .then((value) {
                                      String imageUrl =
                                          value[0]["url"] as String;
                                      debugPrint("value[url] $imageUrl");
                                      sendMessage(
                                        imageUrl, widget.chatId,
                                        "audio",
                                        // null sender
                                        Sender(
                                          username: user.profile.value.username,
                                          firstName:
                                              user.profile.value.firstName,
                                          lastName: user.profile.value.lastName,
                                          avatarUrl:
                                              user.profile.value.avatarUrl,
                                        ),
                                      );
                                      if (chats.messages.value.messages ==
                                          null) {
                                        Messages data = Messages(
                                            content: [
                                              Content(
                                                  text: imageUrl, type: "audio")
                                            ],
                                            senderId: user.profile.value.id,
                                            id: 1,
                                            sender: Sender(
                                              username:
                                                  user.profile.value.username,
                                              firstName:
                                                  user.profile.value.firstName,
                                              lastName:
                                                  user.profile.value.lastName,
                                              avatarUrl:
                                                  user.profile.value.avatarUrl,
                                            ),
                                            date: DateTime.now()
                                                .toIso8601String());
                                        chats.messages.value.messages = [data];
                                      } else {
                                        Messages data = Messages(
                                            content: [
                                              Content(
                                                  text: imageUrl, type: "audio")
                                            ],
                                            senderId: user.profile.value.id,
                                            id: chats.messages.value.messages!
                                                    .isEmpty
                                                ? 1
                                                : chats.messages.value.messages!
                                                        .last.id! +
                                                    1,
                                            sender: Sender(
                                              username:
                                                  user.profile.value.username,
                                              firstName:
                                                  user.profile.value.firstName,
                                              lastName:
                                                  user.profile.value.lastName,
                                              avatarUrl:
                                                  user.profile.value.avatarUrl,
                                            ),
                                            date: DateTime.now()
                                                .toIso8601String());
                                        chats.messages.value.messages!
                                            .add(data);
                                      }
                                      chats.messages.refresh();
                                      question.clear();
                                      if (scrollController.keepScrollOffset) {
                                        SchedulerBinding.instance
                                            .addPostFrameCallback(
                                          (_) => scrollController.jumpTo(
                                              scrollController
                                                  .position.maxScrollExtent),
                                        );
                                      }
                                    });
                                  }
                                  Get.back();
                                },
                                child: const Text("Send"),
                              )
                            ],
                          ),
                        );
                      } else {
                        // Display an error message if the image exceeds the size limit
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Audio Size Limit Exceeded'),
                              content: const Text(
                                  'Please select an audio below 5MB in size.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  } else {
                    // User canceled the file picking.
                    Fluttertoast.showToast(msg: "File picking canceled.");
                  }
                });
              }),
              iconCreation(Icons.video_camera_back, Colors.purple, "Video",
                  () async {
                Get.back();
                await FilePicker.platform
                    .pickFiles(type: FileType.video)
                    .then((value) {
                  if (value != null) {
                    File pickedFile = File(value.files.single.path!);

                    // Check the image size in bytes
                    int maxSizeBytes = 5 * 1024 * 1024; // 5MB
                    if (pickedFile.lengthSync() <= maxSizeBytes) {
                      debugPrint("object maxSizeBytes 5MB");
                      path.value = value.files.single.path!;
                      showModalBottomSheet(
                              backgroundColor: Colors.black,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => SafeArea(
                                  child: imageBottomSheet("video",
                                      isreplay: isreplay,
                                      replayMessageId: isreplayMessageId)))
                          .then((value) {
                        if (isreplay) {
                          Get.back();
                        }
                      });
                    } else {
                      // Display an error message if the image exceeds the size limit
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Video Size Limit Exceeded'),
                            content: const Text(
                                'Please select an video below 5MB in size.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                });
              }),
              iconCreation(Icons.image, Colors.pink, "Image", () async {
                Get.back();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          iconCreation(
                              Icons.image, Colors.deepPurple, "Gallery",
                              () async {
                            await ImagePicker.platform
                                .getImageFromSource(source: ImageSource.gallery)
                                .then((value) {
                              if (value != null) {
                                File pickedFile = File(value.path);

                                // Check the image size in bytes
                                int maxSizeBytes = 5 * 1024 * 1024; // 5MB
                                if (pickedFile.lengthSync() <= maxSizeBytes) {
                                  debugPrint("object maxSizeBytes 5MB");
                                  path.value = value.path;
                                  Get.back();
                                  showModalBottomSheet(
                                          backgroundColor: Colors.black,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => SafeArea(
                                              child: imageBottomSheet("image",
                                                  isreplay: isreplay,
                                                  replayMessageId:
                                                      isreplayMessageId)))
                                      .then((value) {
                                    if (isreplay) {
                                      Get.back();
                                    }
                                  });
                                } else {
                                  // Display an error message if the image exceeds the size limit
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Image Size Limit Exceeded'),
                                        content: const Text(
                                            'Please select an image below 5MB in size.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            });
                          }),
                          iconCreation(
                              Icons.camera, Colors.deepOrange, "Camera",
                              () async {
                            await ImagePicker.platform
                                .getImageFromSource(
                              source: ImageSource.camera,
                            )
                                .then((value) {
                              if (value != null) {
                                path.value = value.path;
                                Get.back();
                                showModalBottomSheet(
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => SafeArea(
                                            child: imageBottomSheet("image",
                                                isreplay: isreplay,
                                                replayMessageId:
                                                    isreplayMessageId)))
                                    .then((value) {
                                  if (isreplay) {
                                    Get.back();
                                  }
                                });
                              }
                            });
                          }),
                        ]),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget iconCreation(
      IconData icon, Color color, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget imageBottomSheet(String type,
      {required bool isreplay, int? replayMessageId}) {

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top + 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              width: Get.size.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      path.split("/").last,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: Styles.text.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: Get.size.width * 0.07,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (type == "image")
              SizedBox(
                height: Get.size.height * 0.7,
                width: Get.size.width * 0.9,
                child: Image.file(
                  File(path.value),
                  // fit: BoxFit.fill,
                ),
              ),
            if (type == "doc")
              SizedBox(
                height: Get.size.height * 0.7,
                width: Get.size.width * 0.9,
                child: path.split(".").last == "pdf"
                    ? PDFView(
                        filePath: "$path",
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                        onError: (error) {
                          debugPrint(error.toString());
                        },
                        onPageError: (page, error) {
                          debugPrint('$page: ${error.toString()}');
                        },
                      )
                    : Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/document.png",
                              height: 100,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              path.split("/").last,
                              style: Styles.text.copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
              ),
            if (type == "video") AttachmentReviewScreen(path: path.value),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              right: 5,
              left: 5),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  color: const Color.fromARGB(
                    255,
                    4,
                    77,
                    69,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: focusNodeImage,
                            // textAlignVertical: TextAlignVertical.center,
                            controller: imageText,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            maxLines: 5,
                            minLines: 1,
                            style: Styles.text.copyWith(color: Colors.white),
                            onChanged: (value) {
                              if (value.isNotEmpty) {}
                            },
                            decoration: InputDecoration(
                              // fillColor: Color(0xFF4AB5E5),
                              border: InputBorder.none,
                              hintText: "Type a message...",
                              hintStyle: Styles.text
                                  .copyWith(color: Colors.white, fontSize: 16),
                              contentPadding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () async {
                  focusNodeImage.unfocus();
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

                  if (imageText.text.isEmpty) {
                    if (isreplay && replayMessageId != null) {
                      await chats.uploadChatImage(path.value).then((value) {
                        String imageUrl = value[0]["url"] as String;
                        debugPrint("value[url] $imageUrl");
                        sendReplyMessage(
                            imageUrl, widget.chatId, replayMessageId,
                            messageType: type);

                        if (chats.messages.value.messages == null) {
                          Messages data = Messages(
                              content: [Content(text: imageUrl, type: type)],
                              senderId: user.profile.value.id,
                              id: 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String(),
                              inReplyToId: replayMessageId);

                          chats.messages.value.messages = [data];
                        } else {
                          Messages data = Messages(
                              content: [Content(text: imageUrl, type: type)],
                              senderId: user.profile.value.id,
                              id: chats.messages.value.messages!.isEmpty
                                  ? 1
                                  : chats.messages.value.messages!.last.id! + 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String(),
                              inReplyToId: replayMessageId);
                          chats.messages.value.messages!.add(data);
                        }

                        chats.messages.refresh();
                        question.clear();
                      });
                    } else {
                      await chats.uploadChatImage(path.value).then((value) {
                        String imageUrl = value[0]["url"] as String;
                        debugPrint("value[url] $imageUrl");
                        sendMessage(
                            imageUrl,
                            widget.chatId,
                            type,
                            // null sender
                            Sender(
                              username: user.profile.value.username,
                              firstName: user.profile.value.firstName,
                              lastName: user.profile.value.lastName,
                              avatarUrl: user.profile.value.avatarUrl,
                            ));
                        if (chats.messages.value.messages == null) {
                          Messages data = Messages(
                              content: [Content(text: imageUrl, type: type)],
                              senderId: user.profile.value.id,
                              id: 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String());
                          chats.messages.value.messages = [data];
                        } else {
                          Messages data = Messages(
                              content: [Content(text: imageUrl, type: type)],
                              senderId: user.profile.value.id,
                              id: chats.messages.value.messages!.isEmpty
                                  ? 1
                                  : chats.messages.value.messages!.last.id! + 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String());
                          chats.messages.value.messages!.add(data);
                        }

                        chats.messages.refresh();
                        question.clear();
                      });
                    }
                    Get.back();
                  } else {
                    if (isreplay && replayMessageId != null) {
                      await chats.uploadChatImage(path.value).then((value) {
                        String imageUrl = value[0]["url"] as String;
                        // imageUrl = "$imageUrl $path";
                        debugPrint("value[url] $imageUrl");
                        // sendDoubleMessage(imageUrl, imageText.text.trim(),
                        //     widget.chatId, type, "text", Sender());
                        sendReplyDoubleMessage(imageUrl, imageText.text.trim(),
                            widget.chatId, replayMessageId,
                            messageType1: type, messageType2: "text");

                        if (chats.messages.value.messages == null) {
                          Messages data = Messages(
                              content: [
                                Content(
                                  text: imageUrl,
                                  type: type,
                                ),
                                Content(
                                  text: imageText.text,
                                  type: "text",
                                )
                              ],
                              senderId: user.profile.value.id,
                              id: 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String(),
                              inReplyToId: replayMessageId);
                          chats.messages.value.messages = [data];
                        } else {
                          Messages data = Messages(
                              content: [
                                Content(
                                  text: imageUrl,
                                  type: type,
                                ),
                                Content(
                                  text: imageText.text,
                                  type: "text",
                                )
                              ],
                              senderId: user.profile.value.id,
                              id: chats.messages.value.messages!.isEmpty
                                  ? 1
                                  : chats.messages.value.messages!.last.id! + 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String(),
                              inReplyToId: replayMessageId);
                          chats.messages.value.messages!.add(data);
                        }
                        chats.messages.refresh();
                        question.clear();
                      });
                    } else {
                      await chats.uploadChatImage(path.value).then((value) {
                        String imageUrl = value[0]["url"] as String;
                        // imageUrl = "$imageUrl $path";
                        debugPrint("value[url] $imageUrl");
                        sendDoubleMessage(
                            imageUrl,
                            imageText.text,
                            widget.chatId,
                            type,
                            "text",
                            // nul sender
                            Sender(
                              username: user.profile.value.username,
                              firstName: user.profile.value.firstName,
                              lastName: user.profile.value.lastName,
                              avatarUrl: user.profile.value.avatarUrl,
                            ));
                        if (chats.messages.value.messages == null) {
                          Messages data = Messages(
                              content: [
                                Content(
                                  text: imageUrl,
                                  type: type,
                                ),
                                Content(
                                  text: imageText.text,
                                  type: "text",
                                )
                              ],
                              senderId: user.profile.value.id,
                              id: 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String());
                          chats.messages.value.messages = [data];
                        } else {
                          Messages data = Messages(
                              content: [
                                Content(
                                  text: imageUrl,
                                  type: type,
                                ),
                                Content(
                                  text: imageText.text,
                                  type: "text",
                                )
                              ],
                              senderId: user.profile.value.id,
                              id: chats.messages.value.messages!.isEmpty
                                  ? 1
                                  : chats.messages.value.messages!.last.id! + 1,
                              sender: Sender(
                                username: user.profile.value.username,
                                firstName: user.profile.value.firstName,
                                lastName: user.profile.value.lastName,
                                avatarUrl: user.profile.value.avatarUrl,
                              ),
                              date: DateTime.now().toIso8601String());
                          chats.messages.value.messages!.add(data);
                        }
                        chats.messages.refresh();
                        question.clear();
                      });
                    }
                    Get.back();
                  }
                  Get.back();
                  imageText.clear();
                  if (scrollController.keepScrollOffset) {
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) => scrollController
                          .jumpTo(scrollController.position.maxScrollExtent),
                    );
                  }
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget menu(BuildContext context) {
    return PopupMenuButton<String>(
      padding: const EdgeInsets.all(0),
      onSelected: (value) {
        if (kDebugMode) {
          print(value);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text(
              'Members',
              textScaleFactor: 1,
              style: Styles.text,
            ),
            onTap: () {
              Get.back();
              Get.to(
                () => MembersScreen(
                  id: repo.communityProfile.value.id!,
                ),
              );
            },
          ),
          PopupMenuItem(
            child: Text(
              'Leave Group',
              textScaleFactor: 1,
              style: Styles.text,
            ),
            onTap: () {
              repo.leaveCommunity(widget.chat!.id!);
              Get.back();
            },
          )
        ];
      },
    );
  }

  IconButton addToWatchlist() {
    return IconButton(
      onPressed: () {
        bookmarkSheet();
      },
      icon: const Icon(
        Icons.bookmark_border_outlined,
        color: Colors.white,
      ),
    );
  }

  void bookmarkSheet() {
    var controller = TextEditingController();
    Get.bottomSheet(
      Container(
        height: 235,
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add to Watchlist',
                  textScaleFactor: 1,
                  style: Styles.text.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 130,
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    children: [
                      CustomWatchlistCard(
                        title: 'Watchlist 1',
                        onTap: () {
                          Get.back();
                        },
                        center: Image.asset('assets/Fino Bird.png'),
                      ),
                      CustomWatchlistCard(
                        title: 'Create Watchlist',
                        onTap: () {
                          Get.defaultDialog(
                            title: '',
                            content: CustomTextField(
                              controller: controller,
                              text: 'Watchlist Name',
                              type: TextInputType.name,
                            ),
                            confirm: CustomElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Center(
                                child: Text(
                                  'Create',
                                  textScaleFactor: 1,
                                  style: Styles.text.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        center: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showReplayBottomSheet(
      String message, int replayMessageId, bool isyou, String? userName) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 10, 111, 101),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 4, 77, 69),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isyou ? "You" : (userName ?? ""),
                    style: Styles.text.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  if (RegExp(r'\.(mp3)$').hasMatch(message)) ...{
                    Row(
                      children: [
                        // Image.asset("assets/video.png"),
                        Container(
                          padding: EdgeInsets.all(Get.size.width * 0.02),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 253, 129, 91),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.headphones),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            message.split("/").last,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.text.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  } else if (RegExp(r'\.(mp4)$').hasMatch(message)) ...{
                    Row(
                      children: [
                        Image.asset(
                          "assets/video.png",
                          height: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            message.split("/").last,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.text.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  } else if (RegExp(r'\.(pdf|doc|docx|txt)$')
                      .hasMatch(message)) ...{
                    Row(
                      children: [
                        RegExp(r'\.(pdf)$').hasMatch(message)
                            ? Image.asset(
                                "assets/pdf_icon.png",
                                height: 35,
                              )
                            : Image.asset(
                                "assets/document.png",
                                height: 35,
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            message.split("/").last,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.text.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  } else if (RegExp(r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                          caseSensitive: false)
                      .hasMatch(message)) ...{
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: message,
                              placeholder: (context, url) => const SizedBox(
                                height: 100,
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(
                                height: 00,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  } else ...{
                    Row(
                      children: [
                        Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.text
                              .copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: const Color.fromARGB(255, 4, 77, 69),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                focusNode: focusNodeReplay,
                                controller: replayText,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                maxLines: 5,
                                minLines: 1,
                                style:
                                    Styles.text.copyWith(color: Colors.white),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {}
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message...",
                                  hintStyle: Styles.text.copyWith(
                                      color: Colors.white, fontSize: 16),
                                  contentPadding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                focusNode.unfocus();
                                debugPrint("object");
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => SafeArea(
                                      child: bottomSheet(
                                          isreplay: true,
                                          isreplayMessageId: replayMessageId)),
                                );
                              },
                              child: Image.asset(
                                "assets/paper-pin.png",
                                height: 23,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      if (replayText.text.trim().isNotEmpty) {
                        debugPrint(
                            "question.text.isNotEmpty ${replayText.text}");
                        sendReplyMessage(replayText.text.trim(), widget.chatId,
                            replayMessageId,
                            messageType: "text");
                        if (chats.messages.value.messages == null) {
                          Messages data = Messages(
                            content: [
                              Content(
                                  text: replayText.text.trim(), type: "text")
                            ],
                            senderId: user.profile.value.id,
                            id: 1,
                            sender: Sender(
                              username: user.profile.value.username,
                              firstName: user.profile.value.firstName,
                              lastName: user.profile.value.lastName,
                              avatarUrl: user.profile.value.avatarUrl,
                            ),
                            date: DateTime.now().toIso8601String(),
                            inReplyToId: replayMessageId,
                          );
                          chats.messages.value.messages = [data];
                        } else {
                          Messages data = Messages(
                            content: [
                              Content(
                                  text: replayText.text.trim(), type: "text")
                            ],
                            senderId: user.profile.value.id,
                            id: chats.messages.value.messages!.isEmpty
                                ? 1
                                : chats.messages.value.messages!.last.id! + 1,
                            sender: Sender(
                              username: user.profile.value.username,
                              firstName: user.profile.value.firstName,
                              lastName: user.profile.value.lastName,
                              avatarUrl: user.profile.value.avatarUrl,
                            ),
                            date: DateTime.now().toIso8601String(),
                            inReplyToId: replayMessageId,
                          );
                          chats.messages.value.messages!.add(data);
                        }

                        chats.messages.refresh();
                        replayText.clear();
                        if (scrollController.keepScrollOffset) {
                          SchedulerBinding.instance.addPostFrameCallback(
                            (_) => scrollController.jumpTo(
                                scrollController.position.maxScrollExtent),
                          );
                        }
                        Get.back();
                      } else {
                        log("cannot add empty question");
                        replayText.clear();
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.chatDescription,
    required this.index,
    required this.isSender,
    required this.questionId,
    this.username,
    required this.chatId,
    required this.time,
    this.userImage,
    required this.onTap,
    required this.messageId,
    required this.isReplayId,
    required this.onLongPress,
    required this.reaction,
  });

  final List<Content>? chatDescription;
  final int index;
  final int? isReplayId;
  final bool isSender;
  final int questionId;
  final String? username;
  final String chatId;
  final String time;
  final String? userImage;
  final int? messageId;
  final Function(bool) onTap;
  final GestureLongPressCallback? onLongPress;
  final List<ReactionModel>? reaction;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with AutomaticKeepAliveClientMixin {
  final chats = Get.put(ChatRepo());
  final user = Get.put(UserRepo());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool Sender = widget.isSender;
    // return SizedBox();
    if (widget.chatDescription == null ||
        widget.chatDescription![0].text!.isEmpty) {
      return const SizedBox();
    } else {
      return Sender
          ? Dismissible(
              key: Key(widget.index.toString()),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  widget.onTap(true);

                  /// edit item
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  widget.onTap(true);

                  /// delete
                  return false;
                }
              },
              //direction: DismissDirection.startToEnd,
              onDismissed: (val) {
                widget.onTap(true);
              },
              child: GestureDetector(
                onLongPress: widget.onLongPress,
                child: UserChatCard(
                  reaction: widget.reaction,
                  isReplayId: widget.isReplayId != null
                      ? chats.messages.value.messages!
                          .where((element) => element.id == widget.isReplayId)
                          .first
                          .content![0]
                          .text
                      : null,
                  message: widget.chatDescription!,
                  time: widget.time,
                  userName: widget.isReplayId != null
                      ? chats.messages.value.messages!
                          .where((element) => element.id == widget.isReplayId)
                          .first
                          .sender!
                          .firstName
                      : null,
                  isyou: widget.isReplayId != null
                      ? chats.messages.value.messages!
                              .where(
                                  (element) => element.id == widget.isReplayId)
                              .first
                              .senderId ==
                          user.profile.value.id
                      : null,
                ),
              ),
            )
          : Dismissible(
              key: Key(widget.index.toString()),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  widget.onTap(true);

                  /// edit item
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  widget.onTap(true);

                  /// delete
                  return false;
                }
              },
              // direction: DismissDirection.endToStart,
              onDismissed: (val) {
                widget.onTap(true);
              },
              child: GestureDetector(
                onLongPress: widget.onLongPress,
                /*()  {
                  print('rrrrr --> ${widget.messageId}');

                  // if (widget.isReplayId != null) {
                  //   showMessageOptions(
                  //       onTap: () {
                  //         widget.onTap(true);
                  //       },
                  //       messageId: widget.isReplayId.toString());
                  // } else {
                  //   Fluttertoast.showToast(msg: "No User Found");
                  // }
                }*/
                child: ReplyChatCard(
                  reaction: widget.reaction,
                  userName: widget.username,
                  message: widget.chatDescription!,
                  time: widget.time,
                  userImage: widget.userImage,
                  isyou: widget.isReplayId != null
                      ? chats.messages.value.messages!
                              .where(
                                  (element) => element.id == widget.isReplayId)
                              .first
                              .senderId ==
                          user.profile.value.id
                      : null,
                  replayName: widget.isReplayId != null
                      ? chats.messages.value.messages!
                          .where((element) => element.id == widget.isReplayId)
                          .first
                          .sender!
                          .firstName
                      : null,
                  isReplayId: widget.isReplayId != null
                      ? chats.messages.value.messages!
                          .where((element) => element.id == widget.isReplayId)
                          .first
                          .content![0]
                          .text
                      : null,
                ),
              ),
            );
    }
  }

  showMessageOptions1(
      {bool isuser = false,
      required Function() onTap,
      required String messageId}) {
    Get.bottomSheet(
      Container(
        height: isuser ? 1.5 * 60 : 2 * 60,
        decoration: const BoxDecoration(
          color: Color(0xFF4AB5E5),
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
                Get.back();
                onTap();
              },
              leading: const Icon(
                LineIcons.reply,
                color: Colors.white,
              ),
              title: Text(
                "Go to replies",
                style: Styles.text.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            !isuser
                ? ListTile(
                    onTap: () {
                      Get.back();
                      // showReportUserOptions1(messageId);
                      chats.reportUserChat(messageId: messageId);
                    },
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Report User",
                      style: Styles.text.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      elevation: 2,
    );
  }

  void showReportUserOptions1(String messageid) {
    // var controller = TextEditingController();
    Get.bottomSheet(
      Container(
        height: 5 * 50,
        decoration: const BoxDecoration(
          color: Color(0xFF4AB5E5),
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
                Get.back();
                chats.reportUserChat(messageId: messageid);
              },
              title: Text(
                "Report Spam",
                style: Styles.text.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                chats.reportUserChat(messageId: messageid);
              },
              title: Text(
                "Harmful Content",
                style: Styles.text.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                chats.reportUserChat(messageId: messageid);
              },
              title: Text(
                "Other",
                style: Styles.text.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            // CustomTextField(
            //   controller: controller,
            //   text: "Please Specify",
            //   type: TextInputType.text,
            // ),
          ],
        ),
      ),
      elevation: 2,
    );
  }
}
