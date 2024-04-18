import 'package:finobird/repository/community_repo.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat/get_chat_list.dart';
import '../screens/chat/chat_screen.dart';

class CustomChatTile extends StatelessWidget {
  CustomChatTile({
    Key? key,
    required this.timeAgo,
    required this.notifications,
    required this.chat,
  }) : super(key: key);

  final Chats chat;
  final String timeAgo;
  final int notifications;

  final CommunitiesRepo communitiesRepo = Get.put(CommunitiesRepo());

  @override
  Widget build(BuildContext context) {
    communitiesRepo.getCommunityDetails(chat.id!);

    return InkWell(
      onTap: () {
        Get.to(
          () => ChatScreen(
            title: chat.name!,
            members: '44.7k',
            // community: communitiesRepo.communities.value.communities!.first,
            chat: chat, chatId: chat.chatId!, communityId: chat.id!,
            isJoined: true,
          ),
          transition: Transition.upToDown,
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 55,
              width: 55,
              color: const Color(0xFF4AB5E5),
              child: chat.avatarUrl == null
                  ? const Icon(
                      CupertinoIcons.person_3_fill,
                      size: 25,
                      color: Colors.white,
                    )
                  : Image.network(
                      chat.avatarUrl!,
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name!.length > 35
                        ? "${chat.name!.substring(0, 35)}..."
                        : chat.name!,
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.semiBold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat.description!.length > 45
                        ? "${chat.description!.substring(0, 45)}..."
                        : chat.description!,
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.small.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          // Expanded(child: Container()),
          // const Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     // Padding(
          //     //   padding: const EdgeInsets.all(3.0),
          //     //   child: Text(
          //     //     timeAgo,
          //     //     textScaleFactor: 1,
          //     //     style: Styles.small.copyWith(fontSize: 10),
          //     //   ),
          //     // ),
          //     // Padding(
          //     //   padding: const EdgeInsets.all(3.0),
          //     //   child: Container(
          //     //     decoration: BoxDecoration(
          //     //       color: Colors.green,
          //     //       borderRadius: BorderRadius.circular(5),
          //     //     ),
          //     //     child: Padding(
          //     //       padding: const EdgeInsets.all(5.0),
          //     //       child: Text(
          //     //         notifications.toString(),
          //     //         textScaleFactor: 1,
          //     //         style: Styles.small.copyWith(
          //     //           fontSize: 10,
          //     //           color: Colors.white,
          //     //         ),
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
