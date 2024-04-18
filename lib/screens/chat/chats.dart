import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../custom/custom_chat_tile.dart';
import '../../repository/chat_repo.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ChatRepo chats = Get.put(ChatRepo());
  RxBool fetchingContent = false.obs;
  @override
  void initState() {
    if (chats.chats.value.communities == null ||
        chats.chats.value.communities!.chats == null) {
      fetchingContent.value = true;
    }
    chats.getChats().then((value) {
      fetchingContent.value = false;
      debugPrint("object chats ${chats.chats}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "===>>> ${chats.chats.value.communities == null && fetchingContent.value}");
    debugPrint("object hellow");

    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.mediaQuery.padding.top),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Messages',
                    textScaleFactor: 1,
                    style: Styles.semiBold.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  // chats.chats.value.communities == null && fetchingContent.value
                  //     ? ListView.builder(
                  //         itemBuilder: (context, index) {
                  //           return const AnnouncementCardSkelton();
                  //         },
                  //       )
                  //     :
                  fetchingContent.value
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return const AnnouncementCardSkelton();
                          },
                        )
                      : chats.chats.value.communities != null &&
                              chats.chats.value.communities!.chats != null &&
                              chats.chats.value.communities!.chats!.isNotEmpty
                          ? ListView.separated(
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CustomChatTile(
                                  timeAgo: '10 mins ago',
                                  notifications: 209,
                                  chat: chats
                                      .chats.value.communities!.chats![index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: chats
                                      .chats.value.communities!.chats?.length ??
                                  0,
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/no chats.svg",
                                    height: Get.size.width * 0.45,
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    "No Communities",
                                    style: Styles.subtitleSmall.copyWith(
                                        color: Colors.black,
                                        fontSize: Get.size.width * 0.045),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Use the plus button to join the communities",
                                    style: Styles.subtitleSmall.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
