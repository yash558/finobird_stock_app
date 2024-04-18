// ignore_for_file: file_names, unnecessary_final

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:finobird/custom/user_image_error_widget.dart';
import 'package:finobird/repository/chat_repo.dart';
import 'package:finobird/screens/chat/chat_image_perview.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/chat/get_community_messages.dart';

class ReplyChatCard extends StatelessWidget {
  const ReplyChatCard({
    Key? key,
    required this.message,
    required this.userName,
    required this.time,
    required this.userImage,
    required this.isReplayId,
    required this.isyou,
    required this.replayName,
    required this.reaction,
  }) : super(key: key);
  final List<Content> message;
  final String? userName;
  final String? replayName;
  final String time;
  final String? userImage;
  final String? isReplayId;
  final bool? isyou;
  final List<ReactionModel>? reaction;
  // final String time;

  @override
  Widget build(BuildContext context) {
    ChatRepo chatRepo = ChatRepo();

    if (isReplayId != null && isyou != null) {
      if (message.length != 1) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * .015,
                top: Get.height * .012,
              ),
              child: userImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: userImage ?? "",
                          placeholder: (context, url) =>
                              const UserErrorWidget(),
                          errorWidget: (context, url, error) =>
                              const UserErrorWidget(),
                        ),
                      ),
                    )
                  : const UserErrorWidget(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  elevation: 1,
                  color: const Color.fromARGB(255, 55, 117, 112),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  // color: Color(0xffdcf8c6),
                  margin: EdgeInsets.only(
                      left: Get.width * .015,
                      top: Get.height * .012,
                      right: Get.width * .22),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: Get.width * .017,
                          right: Get.width * .017,
                          top: Get.height * .005,
                          bottom: Get.height * .005,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName != null && userName!.isNotEmpty
                                ? Text(
                                    userName!,
                                    style: Styles.text.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsets.all(Get.size.width * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromARGB(255, 4, 96, 87),
                              ),
                              constraints: BoxConstraints(
                                  minWidth: Get.size.width * 0.4),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isyou! ? "You" : (replayName ?? ""),
                                        style: Styles.text.copyWith(
                                          color: const Color.fromARGB(
                                              255, 11, 167, 151),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      if (RegExp(r'\.(mp3)$')
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.headphones,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Audio",
                                              style: Styles.text.copyWith(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      } else if (RegExp(r'\.(mp4)$')
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/video.png",
                                              height: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Video",
                                              style: Styles.text.copyWith(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      } else if (RegExp(
                                              r'\.(pdf|doc|docx|txt)$')
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RegExp(r'\.(pdf)$')
                                                    .hasMatch(isReplayId!)
                                                ? Image.asset(
                                                    "assets/pdf_icon.png",
                                                    height: 15,
                                                  )
                                                : Image.asset(
                                                    "assets/document.png",
                                                    height: 18,
                                                  ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                isReplayId!.split("/").last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.text.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      } else if (RegExp(
                                              r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                                              caseSensitive: false)
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                isReplayId!.split("/").last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.text.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      } else ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                isReplayId!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.text.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      }
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (RegExp(r'\.(pdf|doc|docx|txt|mp4)$')
                                .hasMatch(message[0].text!)) ...{
                              Container(
                                padding: EdgeInsets.all(Get.size.width * 0.015),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromARGB(255, 5, 97, 88),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (RegExp(r'\.(mp4)$')
                                          .hasMatch(message[0].text!)) ...{
                                        GestureDetector(
                                          onTap: () async {
                                            chatRepo.openTheFiles(
                                                context, message[0].text!);
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset("assets/video.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    message[0]
                                                        .text!
                                                        .split("/")
                                                        .last,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Styles.text.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      } else if (RegExp(
                                              r'\.(pdf|doc|docx|txt)$')
                                          .hasMatch(message[0].text!)) ...{
                                        GestureDetector(
                                          onTap: () async {
                                            chatRepo.openTheFiles(
                                                context, message[0].text!);
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                RegExp(r'\.(pdf)$').hasMatch(
                                                        message[0].text!)
                                                    ? Image.asset(
                                                        "assets/pdf_icon.png",
                                                      )
                                                    : Image.asset(
                                                        "assets/document.png",
                                                      ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    message[0]
                                                        .text!
                                                        .split("/")
                                                        .last,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Styles.text.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      }
                                    ]),
                              ),
                            } else if (RegExp(
                                    r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                                    caseSensitive: false)
                                .hasMatch(message[0].text!)) ...{
                              Container(
                                width: Get.size.width * 0.4,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 55, 117, 112),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => ChatImagePreview(
                                        image: message[0].text!));
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: message[0].text!,
                                        placeholder: (context, url) => Skeleton(
                                          borderRadius: 8,
                                          height: 100,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const SizedBox(
                                          height: 00,
                                        ),
                                      )
                                      //     Image.network(
                                      //   message,
                                      // ),
                                      ),
                                ),
                              )
                            } else if (RegExp(r"\b(?:https?://)\S+\b")
                                .hasMatch(message[0].text!)) ...{
                              Align(
                                alignment: Alignment.centerRight,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color:
                                      const Color.fromARGB(255, 55, 117, 112),
                                  child: Linkify(
                                    onOpen: (link) async {
                                      if (!await launchUrl(
                                          Uri.parse(link.url))) {
                                        throw Exception(
                                            'Could not launch ${link.url}');
                                      }
                                    },
                                    text: message[0].text!,
                                    options:
                                        const LinkifyOptions(humanize: false),
                                    linkStyle: Styles.text.copyWith(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                                    style: Styles.text.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                                  ),
                                ),
                              )
                            },
                            const SizedBox(
                              height: 10,
                            ),
                            Linkify(
                              onOpen: (link) async {
                                if (!await launchUrl(Uri.parse(link.url))) {
                                  throw Exception(
                                      'Could not launch ${link.url}');
                                }
                              },
                              text: message[1].text!,
                              linkStyle: Styles.text.copyWith(
                                color: Colors.lightBlueAccent,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            // Text(
                            //   message,
                            //   style: Styles.text.copyWith(
                            //       color: Colors.white,
                            //       fontSize: 16,
                            //       letterSpacing: 1,
                            //       wordSpacing: 1),
                            // ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "",
                              textAlign: TextAlign.end,
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            if (userName != null && message.isEmpty)
                              const SizedBox(width: 40),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                reaction!.isNotEmpty
                                    ? Row(
                                        children: reaction!
                                            .map((e) =>
                                                emoji(e.emoji.toString()))
                                            .toList(),
                                      )
                                    : const SizedBox(),
                                Text(
                                  time,
                                  textAlign: TextAlign.end,
                                  style: Styles.text.copyWith(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   bottom: 4,
                      //   right: 4,
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       reaction!.isNotEmpty?  Row(
                      //         children: reaction!.map((e) =>  emoji(e.emoji.toString())).toList(),
                      //       ):const SizedBox(),
                      //       Text(
                      //         time,
                      //         textAlign: TextAlign.end,
                      //         style: Styles.text.copyWith(
                      //           color: Colors.white.withOpacity(0.5),
                      //           fontSize: 8,
                      //           letterSpacing: 1,
                      //           wordSpacing: 1,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * .015,
                top: Get.height * .012,
              ),
              child: userImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: userImage ?? "",
                          placeholder: (context, url) =>
                              const UserErrorWidget(),
                          errorWidget: (context, url, error) =>
                              const UserErrorWidget(),
                        ),
                      ),
                    )
                  : const UserErrorWidget(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  elevation: 1,
                  color: const Color.fromARGB(255, 55, 117, 112),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  // color: Color(0xffdcf8c6),
                  margin: EdgeInsets.only(
                      left: Get.width * .015,
                      top: Get.height * .012,
                      right: Get.width * .22),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: Get.width * .017,
                          right: Get.width * .017,
                          top: Get.height * .005,
                          bottom: Get.height * .010,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName != null && userName!.isNotEmpty
                                ? Text(
                                    userName!,
                                    style: Styles.text.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsets.all(Get.size.width * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromARGB(255, 4, 96, 87),
                              ),
                              constraints: BoxConstraints(
                                  minWidth: Get.size.width * 0.4),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isyou! ? "You" : (replayName ?? ""),
                                        style: Styles.text.copyWith(
                                          color: const Color.fromARGB(
                                              255, 11, 167, 151),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      if (RegExp(r'\.(mp3)$')
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.headphones,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Audio",
                                              style: Styles.text.copyWith(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      } else if (RegExp(r'\.(mp4)$')
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/video.png",
                                              height: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Video",
                                              style: Styles.text.copyWith(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      } else if (RegExp(
                                              r'\.(pdf|doc|docx|txt)$')
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RegExp(r'\.(pdf)$')
                                                    .hasMatch(isReplayId!)
                                                ? Image.asset(
                                                    "assets/pdf_icon.png",
                                                    height: 15,
                                                  )
                                                : Image.asset(
                                                    "assets/document.png",
                                                    height: 15,
                                                  ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                isReplayId!.split("/").last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.text.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      } else if (RegExp(
                                              r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                                              caseSensitive: false)
                                          .hasMatch(isReplayId!)) ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                isReplayId!.split("/").last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.text.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      } else ...{
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                isReplayId!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.text.copyWith(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      }
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (RegExp(r'\.(mp3)$')
                                .hasMatch(message[0].text!)) ...{
                              GestureDetector(
                                onTap: () async {
                                  chatRepo.openTheFiles(
                                      context, message[0].text!);
                                },
                                child: Container(
                                  // height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 55, 117, 112),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      // Image.asset("assets/video.png", height: 45),
                                      Container(
                                        padding: EdgeInsets.all(
                                            Get.size.width * 0.02),
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 253, 129, 91),
                                            shape: BoxShape.circle),
                                        child: const Icon(Icons.headphones),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          message[0].text!.split("/").last,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.text.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            } else if (RegExp(r'\.(mp4)$')
                                .hasMatch(message[0].text!)) ...{
                              GestureDetector(
                                onTap: () async {
                                  chatRepo.openTheFiles(
                                      context, message[0].text!);
                                },
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/video.png",
                                          height: 35),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          message[0].text!.split("/").last,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.text.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            } else if (RegExp(r'\.(pdf|doc|docx|txt)$')
                                .hasMatch(message[0].text!)) ...{
                              GestureDetector(
                                onTap: () async {
                                  chatRepo.openTheFiles(
                                      context, message[0].text!);
                                },
                                child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      RegExp(r'\.(pdf)$')
                                              .hasMatch(message[0].text!)
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
                                          message[0].text!.split("/").last,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.text.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            } else if (RegExp(
                                    r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                                    caseSensitive: false)
                                .hasMatch(message[0].text!)) ...{
                              Container(
                                width: Get.size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => ChatImagePreview(
                                        image: message[0].text!));
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: message[0].text!,
                                        placeholder: (context, url) => Skeleton(
                                          borderRadius: 8,
                                          height: 100,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const SizedBox(
                                          height: 00,
                                        ),
                                      )
                                      //     Image.network(
                                      //   message,
                                      // ),
                                      ),
                                ),
                              )
                            } else if (RegExp(r"\b(?:https?://)\S+\b")
                                .hasMatch(message[0].text!)) ...{
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRect(
                                    child: LinkPreviewGenerator(
                                      link: message[0].text!.split(" ")[0],
                                      linkPreviewStyle: LinkPreviewStyle.small,
                                      removeElevation: true,
                                      placeholderWidget: Skeleton(
                                        borderRadius: 12,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width: double.infinity,
                                      ),
                                      errorWidget: const SizedBox(height: 00),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Linkify(
                                    onOpen: (link) async {
                                      if (!await launchUrl(
                                          Uri.parse(link.url))) {
                                        throw Exception(
                                            'Could not launch ${link.url}');
                                      }
                                    },
                                    text: message[0].text!,
                                    options:
                                        const LinkifyOptions(humanize: false),
                                    linkStyle: Styles.text.copyWith(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                                    style: Styles.text.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            } else ...{
                              Linkify(
                                onOpen: (link) async {
                                  if (!await launchUrl(Uri.parse(link.url))) {
                                    throw Exception(
                                        'Could not launch ${link.url}');
                                  }
                                },
                                text: message[0].text!,
                                linkStyle: Styles.text.copyWith(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  wordSpacing: 1,
                                ),
                                style: Styles.text.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  wordSpacing: 1,
                                ),
                              ),
                            },
                            Text(
                              "",
                              textAlign: TextAlign.end,
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            if (userName != null && message.isEmpty)
                              const SizedBox(width: 40),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                reaction!.isNotEmpty
                                    ? Row(
                                        children: reaction!
                                            .map((e) =>
                                                emoji(e.emoji.toString()))
                                            .toList(),
                                      )
                                    : const SizedBox(),
                                const SizedBox(width: 08),
                                Text(
                                  time,
                                  textAlign: TextAlign.end,
                                  style: Styles.text.copyWith(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 8,
                                    letterSpacing: 1,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Positioned(
                      //   bottom: 4,
                      //   right: 4,
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       reaction!.isNotEmpty?  Row(
                      //         children: reaction!.map((e) =>  emoji(e.emoji.toString())).toList(),
                      //       ):const SizedBox(),
                      //       const SizedBox(width: 08),
                      //       Text(
                      //        time,
                      //         textAlign: TextAlign.end,
                      //         style: Styles.text.copyWith(
                      //           color: Colors.white.withOpacity(0.5),
                      //           fontSize: 8,
                      //           letterSpacing: 1,
                      //           wordSpacing: 1,
                      //         ),
                      //       ),
                      //
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        );
      }
    }

    if (message.length != 1) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * .015,
                top: Get.height * .012,
              ),
              child: userImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: userImage ?? "",
                          placeholder: (context, url) =>
                              const UserErrorWidget(),
                          errorWidget: (context, url, error) =>
                              const UserErrorWidget(),
                        ),
                      ),
                    )
                  : const UserErrorWidget(),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  elevation: 1,
                  color: const Color.fromARGB(255, 55, 117, 112),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  // color: Color(0xffdcf8c6),
                  margin: EdgeInsets.only(
                    left: Get.width * .025,
                    top: Get.height * .012,
                    right: Get.width * .3,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: Get.width * .017,
                          right: Get.width * .017,
                          top: Get.height * .005,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName != null && userName!.isNotEmpty
                                ? Text(
                                    userName!,
                                    style: Styles.text.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 4,
                            ),
                            if (RegExp(r'\.(pdf|doc|docx|txt|mp4)$')
                                .hasMatch(message[0].text!)) ...{
                              Container(
                                padding: EdgeInsets.all(Get.size.width * 0.015),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromARGB(255, 5, 97, 88),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (RegExp(r'\.(mp4)$')
                                          .hasMatch(message[0].text!)) ...{
                                        GestureDetector(
                                          onTap: () async {
                                            chatRepo.openTheFiles(
                                                context, message[0].text!);
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Image.asset("assets/video.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    message[0]
                                                        .text!
                                                        .split("/")
                                                        .last,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Styles.text.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      } else if (RegExp(
                                              r'\.(pdf|doc|docx|txt)$')
                                          .hasMatch(message[0].text!)) ...{
                                        GestureDetector(
                                          onTap: () async {
                                            chatRepo.openTheFiles(
                                                context, message[0].text!);
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                RegExp(r'\.(pdf)$').hasMatch(
                                                        message[0].text!)
                                                    ? Image.asset(
                                                        "assets/pdf_icon.png",
                                                      )
                                                    : Image.asset(
                                                        "assets/document.png",
                                                      ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    message[0]
                                                        .text!
                                                        .split("/")
                                                        .last,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Styles.text.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      }
                                    ]),
                              ),
                            } else if (RegExp(
                                    r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                                    caseSensitive: false)
                                .hasMatch(message[0].text!)) ...{
                              Container(
                                width: Get.size.width * 0.4,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 55, 117, 112),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => ChatImagePreview(
                                        image: message[0].text!));
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: message[0].text!,
                                        placeholder: (context, url) => Skeleton(
                                          borderRadius: 8,
                                          height: 100,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const SizedBox(
                                          height: 00,
                                        ),
                                      )
                                      //     Image.network(
                                      //   message,
                                      // ),
                                      ),
                                ),
                              )
                            } else if (RegExp(r"\b(?:https?://)\S+\b")
                                .hasMatch(message[0].text!)) ...{
                              Align(
                                alignment: Alignment.centerRight,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color:
                                      const Color.fromARGB(255, 55, 117, 112),
                                  child: Linkify(
                                    onOpen: (link) async {
                                      if (!await launchUrl(
                                          Uri.parse(link.url))) {
                                        throw Exception(
                                            'Could not launch ${link.url}');
                                      }
                                    },
                                    text: message[0].text!,
                                    options:
                                        const LinkifyOptions(humanize: false),
                                    linkStyle: Styles.text.copyWith(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                                    style: Styles.text.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 1,
                                      wordSpacing: 1,
                                    ),
                                  ),
                                ),
                              )
                            },
                            const SizedBox(
                              height: 10,
                            ),
                            Linkify(
                              onOpen: (link) async {
                                if (!await launchUrl(Uri.parse(link.url))) {
                                  throw Exception(
                                      'Could not launch ${link.url}');
                                }
                              },
                              text: message[1].text!,
                              linkStyle: Styles.text.copyWith(
                                color: Colors.lightBlueAccent,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            // Text(
                            //   message,
                            //   style: Styles.text.copyWith(
                            //       color: Colors.white,
                            //       fontSize: 16,
                            //       letterSpacing: 1,
                            //       wordSpacing: 1),
                            // ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "",
                              textAlign: TextAlign.end,
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            if (userName != null && message.isEmpty)
                              const SizedBox(width: 40),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                reaction!.isNotEmpty
                                    ? Row(
                                        children: reaction!
                                            .map((e) =>
                                                emoji(e.emoji.toString()))
                                            .toList(),
                                      )
                                    : const SizedBox(),
                                Text(
                                  time,
                                  textAlign: TextAlign.end,
                                  style: Styles.text.copyWith(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 8,
                                    letterSpacing: 1,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   bottom: Get.size.width * 0.01,
                      //   right: Get.size.width * 0.017,
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       reaction!.isNotEmpty?  Row(
                      //         children: reaction!.map((e) =>  emoji(e.emoji.toString())).toList(),
                      //       ):const SizedBox(),
                      //       Text(
                      //         time,
                      //         textAlign: TextAlign.end,
                      //         style: Styles.text.copyWith(
                      //           color: Colors.white.withOpacity(0.5),
                      //           fontSize: 8,
                      //           letterSpacing: 1,
                      //           wordSpacing: 1,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Get.width * .015,
              top: Get.height * .012,
            ),
            child: userImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: userImage ?? "",
                        placeholder: (context, url) => const UserErrorWidget(),
                        errorWidget: (context, url, error) =>
                            const UserErrorWidget(),
                      ),
                    ),
                  )
                : const UserErrorWidget(),
          ),
          if (RegExp(r'\.(mp3)$').hasMatch(message[0].text!)) ...{
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  chatRepo.openTheFiles(context, message[0].text!);
                },
                child: Container(
                  // height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 55, 117, 112),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    left: Get.width * .025,
                    top: Get.height * .012,
                    right: Get.width * .3,
                  ),
                  padding: EdgeInsets.only(
                      left: Get.size.width * 0.017,
                      right: Get.size.width * 0.017,
                      top: Get.size.width * 0.017),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userName != null && userName!.isNotEmpty
                          ? Text(
                              userName!,
                              style: Styles.text.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          // Image.asset("assets/video.png", height: 45),
                          Container(
                            padding: EdgeInsets.all(Get.size.width * 0.02),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 253, 129, 91),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.headphones),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              message[0].text!.split("/").last,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.text.copyWith(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          reaction!.isNotEmpty
                              ? Row(
                                  children: reaction!
                                      .map((e) => emoji(e.emoji.toString()))
                                      .toList(),
                                )
                              : const SizedBox(),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: Get.size.width * 0.01),
                            child: Text(
                              time,
                              style: Styles.text.copyWith(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 8,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          } else if (RegExp(r'\.(mp4)$').hasMatch(message[0].text!)) ...{
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  chatRepo.openTheFiles(context, message[0].text!);
                },
                child: Container(
                  // height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 55, 117, 112),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    left: Get.width * .025,
                    top: Get.height * .012,
                    right: Get.width * .3,
                  ),
                  padding: EdgeInsets.only(
                      left: Get.size.width * 0.017,
                      right: Get.size.width * 0.017,
                      top: Get.size.width * 0.017),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userName != null && userName!.isNotEmpty
                          ? Text(
                              userName!,
                              style: Styles.text.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Image.asset("assets/video.png", height: 35),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              message[0].text!.split("/").last,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.text.copyWith(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          reaction!.isNotEmpty
                              ? Row(
                                  children: reaction!
                                      .map((e) => emoji(e.emoji.toString()))
                                      .toList(),
                                )
                              : const SizedBox(),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: Get.size.width * 0.01),
                            child: Text(
                              time,
                              style: Styles.text.copyWith(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 8,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          } else if (RegExp(r'\.(pdf|doc|docx|txt)$')
              .hasMatch(message[0].text!)) ...{
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  chatRepo.openTheFiles(context, message[0].text!);
                },
                child: Container(
                  // height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 55, 117, 112),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                    left: Get.width * .025,
                    top: Get.height * .012,
                    right: Get.width * .3,
                  ),
                  padding: EdgeInsets.only(
                      left: Get.size.width * 0.017,
                      right: Get.size.width * 0.017,
                      top: Get.size.width * 0.017),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userName != null && userName!.isNotEmpty
                          ? Text(
                              userName!,
                              style: Styles.text.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          RegExp(r'\.(pdf)$').hasMatch(message[0].text!)
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
                              message[0].text!.split("/").last,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.text.copyWith(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          reaction!.isNotEmpty
                              ? Row(
                                  children: reaction!
                                      .map((e) => emoji(e.emoji.toString()))
                                      .toList(),
                                )
                              : const SizedBox(),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: Get.size.width * 0.01),
                            child: Text(
                              time,
                              style: Styles.text.copyWith(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 8,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          } else if (RegExp(r'\.(jpeg|jpg|gif|png|bmp|webp|avif)$',
                  caseSensitive: false)
              .hasMatch(message[0].text!)) ...{
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 55, 117, 112),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(
                  left: Get.width * .025,
                  top: Get.height * .012,
                  right: Get.width * .47,
                ),
                padding: EdgeInsets.all(Get.width * .006),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * .017),
                      child: userName != null && userName!.isNotEmpty
                          ? Text(
                              userName!,
                              style: Styles.text.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => ChatImagePreview(image: message[0].text!));
                      },
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: message[0].text!,
                              placeholder: (context, url) => Skeleton(
                                borderRadius: 8,
                                height: 100,
                              ),
                              errorWidget: (context, url, error) =>
                                  const SizedBox(
                                height: 00,
                              ),
                            )
                            //     Image.network(
                            //   message,
                            // ),
                            ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            reaction!.isNotEmpty
                                ? Row(
                                    children: reaction!
                                        .map((e) => emoji(e.emoji.toString()))
                                        .toList(),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: EdgeInsets.all(Get.size.width * 0.01),
                              child: Text(
                                time,
                                style: Styles.text.copyWith(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 8,
                                  letterSpacing: 1,
                                  wordSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          } else if (RegExp(r"\b(?:https?://)\S+\b")
              .hasMatch(message[0].text!)) ...{
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: const Color.fromARGB(255, 55, 117, 112),
                  margin: EdgeInsets.only(
                      left: Get.width * .015,
                      top: Get.height * .012,
                      right: Get.width * .22),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: Get.width * .017,
                          right: Get.width * .017,
                          top: Get.height * .01,
                          bottom: Get.height * .01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName != null && userName!.isNotEmpty
                                ? Text(
                                    userName!,
                                    style: Styles.text.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 4,
                            ),
                            ClipRect(
                              child: LinkPreviewGenerator(
                                link: message[0].text!.split(" ")[0],
                                linkPreviewStyle: LinkPreviewStyle.small,
                                removeElevation: true,
                                placeholderWidget: Skeleton(
                                  borderRadius: 12,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: double.infinity,
                                ),
                                errorWidget: const SizedBox(height: 00),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Linkify(
                              onOpen: (link) async {
                                if (!await launchUrl(Uri.parse(link.url))) {
                                  throw Exception(
                                      'Could not launch ${link.url}');
                                }
                              },
                              text: message[0].text!,
                              options: const LinkifyOptions(humanize: false),
                              linkStyle: Styles.text.copyWith(
                                color: Colors.lightBlueAccent,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                reaction!.isNotEmpty
                                    ? Row(
                                        children: reaction!
                                            .map((e) =>
                                                emoji(e.emoji.toString()))
                                            .toList(),
                                      )
                                    : const SizedBox(),
                                Text(
                                  time,
                                  style: Styles.text.copyWith(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 8,
                                    letterSpacing: 1,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          } else ...{
            ///Lift chat
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  elevation: 1,
                  color: const Color.fromARGB(255, 55, 117, 112),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  // color: Color(0xffdcf8c6),
                  margin: EdgeInsets.only(
                      left: Get.width * .015,
                      top: Get.height * .012,
                      right: Get.width * .22),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: Get.width * .017,
                          right: Get.width * .017,
                          top: Get.height * .005,
                          bottom: Get.height * .005,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userName != null && userName!.isNotEmpty
                                ? Text(
                                    userName!,
                                    style: Styles.text.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 4,
                            ),
                            Linkify(
                              onOpen: (link) async {
                                if (!await launchUrl(Uri.parse(link.url))) {
                                  throw Exception(
                                      'Could not launch ${link.url}');
                                }
                              },
                              text: message[0].text!,
                              linkStyle: Styles.text.copyWith(
                                color: Colors.lightBlueAccent,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            // Text(
                            //   message,
                            //   style: Styles.text.copyWith(
                            //       color: Colors.white,
                            //       fontSize: 16,
                            //       letterSpacing: 1,
                            //       wordSpacing: 1),
                            // ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "",
                              textAlign: TextAlign.end,
                              style: Styles.text.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                letterSpacing: 1,
                                wordSpacing: 1,
                              ),
                            ),
                            // SizedBox(height: 10),
                            if (message.length < 3) const SizedBox(width: 30),
                            if (userName != null && message.isEmpty)
                              const SizedBox(width: 40),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                reaction!.isNotEmpty
                                    ? Row(
                                        children: reaction!
                                            .map((e) =>
                                                emoji(e.emoji.toString()))
                                            .toList(),
                                      )
                                    : const SizedBox(),
                                Text(
                                  time,
                                  textAlign: TextAlign.end,
                                  style: Styles.text.copyWith(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 8,
                                    letterSpacing: 1,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   bottom: 4,
                      //   right: 4,
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       reaction!.isNotEmpty?  Row(
                      //         children: reaction!.map((e) =>  emoji(e.emoji.toString())).toList(),
                      //       ):const SizedBox(),
                      //       Text(
                      //         time,
                      //         textAlign: TextAlign.end,
                      //         style: Styles.text.copyWith(
                      //           color: Colors.white.withOpacity(0.5),
                      //           fontSize: 8,
                      //           letterSpacing: 1,
                      //           wordSpacing: 1,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          }
        ],
      ),
    );
  }
}

Widget emoji(emoji) {
  return Text(emoji.toString(), style: const TextStyle(fontSize: 20));
}
