import 'package:finobird/repository/company_repo.dart';
import 'package:finobird/screens/feeds/company.dart';
import 'package:finobird/screens/watchlists/company_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../models/company/company_model.dart';
import '../models/company/search_company.dart';
import '../repository/community_repo.dart';
import '../constants/styles.dart';

class CompanyTile extends StatelessWidget {
  CompanyTile({
    super.key,
    required this.company,
  });

  final Result company;
  final CompanyRepo companyRepo = Get.put(CompanyRepo());
  final CommunitiesRepo communitiesRepo = Get.put(CommunitiesRepo());

  @override
  Widget build(BuildContext context) {
    communitiesRepo.getCommunityDetails(company.id!);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Get.to(() => CompanyDetails(
                // community: communitiesRepo.communities.value.communities!.first,
                ticker: '',
                companyDetails: Company(),
              ));
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFF4AB5E5).withOpacity(0.5),
            ),
            const SizedBox(width: 10),
            Text(
              company.name!,
              textScaleFactor: 1,
              style: Styles.text.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(child: Container()),
            IconButton(
              onPressed: () {
                // Get.to(
                //   () => ChatScreen(
                //     title: company.name!,
                //     members: '100k',
                //     community:
                //         communitiesRepo.communities.value.communities!.first,
                //     isJoined: false,
                //     chat: Chats(),
                //   ),
                // );
              },
              icon: Icon(
                CupertinoIcons.bubble_left_bubble_right_fill,
                color: const Color(0xFF4AB5E5).withOpacity(0.5),
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => CompanyFeeds(companyName: company.name!));
              },
              icon: Icon(
                LineIcons.bloggerB,
                color: const Color(0xFF4AB5E5).withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
