// ignore_for_file: unnecessary_final

import 'package:finobird/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../models/chat/communities.dart';
import '../repository/chat_repo.dart';
import '../screens/chat/chat_screen.dart';
import '../constants/styles.dart';

class TrendingCommunityOld extends StatelessWidget {
  const TrendingCommunityOld({
    super.key,
    required this.community,
  });

  final Communities community;

  @override
  Widget build(BuildContext context) {
    final ChatRepo chats = Get.put(ChatRepo());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          Get.to(
            () => ChatScreen(
              members: "",
              title: community.name!,
              isJoined: chats.chats.value.communities!.chats!
                  .any((element) => element.id == community.id),
              chatId: community.chatId!,
              communityId: community.id!,
            ),
          );
        },
        child: SizedBox(
          width: 180,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor,width: 2),
              color: const Color(0xFF4AB5E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Container(
                    width: Get.size.width * 0.15,
                    height: Get.size.width * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xFF4AB5E5), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: community.avatarUrl != null
                          ? Image.network(
                              community.avatarUrl!,
                              height: 80,
                              width: 80,
                              fit: BoxFit.contain,
                            )
                          : SvgPicture.asset(
                              'assets/amico.svg',
                              height: 80,
                              width: 80,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Text(
                    community.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Styles.semiBold.copyWith(fontSize: 14),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'View',
                        textScaleFactor: 1,
                        style: Styles.text.copyWith(
                          fontSize: 10,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
