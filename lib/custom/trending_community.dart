import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../models/chat/communities.dart';
import '../repository/chat_repo.dart';
import '../screens/chat/chat_screen.dart';
import '../constants/styles.dart';

class TrendingCommunity extends StatelessWidget {
  final Communities community;
  final bool rightPadding;

  TrendingCommunity({
    Key? key,
    required this.community,
    required this.rightPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatRepo chats = Get.put(ChatRepo());

    double? stockPrice = community.regularmarketchangepercent != null
        ? community.regularmarketchangepercent! * 100
        : null;

    return Padding(
      padding: EdgeInsets.only(left: 15, right: rightPadding ? 15 : 0),
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
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: 110,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF4AB5E5).withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: community.avatarUrl != null
                      ? Image.network(
                          community.avatarUrl!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        )
                      : SvgPicture.asset(
                          'assets/amico.svg',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                community.name ?? "",
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Styles.semiBold.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (stockPrice != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          stockPrice > 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: stockPrice > 0 ? Colors.green : Colors.red,
                          size: 12,
                        ),
                        Text(
                          stockPrice.toStringAsFixed(2),
                          style: Styles.semiBold.copyWith(
                            fontSize: 12,
                            color: stockPrice >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'View',
                      style: Styles.text.copyWith(
                        fontSize: 10,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
