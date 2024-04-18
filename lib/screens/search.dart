// ignore_for_file: unnecessary_final

import 'dart:developer';

import 'package:finobird/custom/textfield.dart';
import 'package:finobird/screens/watchlists/company_feed.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:link_preview_generator/link_preview_generator.dart';

import '../custom/shimmer_skelton.dart';
import '../repository/chat_repo.dart';
import '../repository/community_repo.dart';
import '../repository/company_repo.dart';
import 'chat/chat_screen.dart';
import 'feeds/company.dart';

class Search extends StatelessWidget {
  const Search({
    super.key,
    required this.searchText,
  });

  final String searchText;

  @override
  Widget build(BuildContext context) {
    final ChatRepo chats = Get.put(ChatRepo());
    var controller0 = TextEditingController(text: searchText);
    // var controller = Get.put(FeedRepo());
    var companyRepo = Get.put(CompanyRepo());

    submit(String text) {
      // log("searching feeds...");
      // controller.searchFeed(text, 10, {}, null);
      log("searching companies...");
      companyRepo.search(text, 10, null);
    }

    submit(searchText);

    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  controller: controller0,
                  text: 'Search',
                  type: TextInputType.text,
                  onSubmit: submit,
                ),
              ),
              // InkWell(
              //   onTap: () {},
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "Feeds",
              //           style: Styles.semiBold.copyWith(
              //             fontSize: 15,
              //           ),
              //         ),
              //         const Icon(
              //           Icons.arrow_forward_ios,
              //           size: 15,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // ...List.generate(
              //   controller.searchResults.value.feed!.length,
              //   (index) => SearchCard(
              //     feed: controller.searchResults.value.feed![index],
              //   ),
              // ),
              if (companyRepo.tickerSearch.value.result?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Companies",
                        style: Styles.semiBold.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              // ...List.generate(
              //   companyRepo.tickerSearch.value.result?.length ?? 0,
              //   (index) => CompanyTile(
              //     company: companyRepo.tickerSearch.value.result![index],
              //   ),
              // ),
              companyRepo.tickerSearch.value.result != null &&
                      companyRepo.tickerSearch.value.result!.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount:
                            companyRepo.tickerSearch.value.result?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () async {
                              CommunitiesRepo repo = Get.put(CommunitiesRepo());
                              await repo.getCommunityDetails(
                                companyRepo.tickerSearch.value.result![index]
                                    .communityId!,
                              );
                              Get.to(
                                () => CompanyDetails(
                                  // community: widget.community,
                                  ticker: companyRepo.tickerSearch.value
                                      .result![index].ticker!,
                                  companyDetails:
                                      repo.communityProfile.value.company!,
                                ),
                              );
                            },
                            title: Text(
                              companyRepo
                                  .tickerSearch.value.result![index].name!,
                              style: Styles.text,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF4AB5E5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinkPreviewGenerator(
                                  link: companyRepo.tickerSearch.value
                                          .result![index].website ??
                                      "",
                                  linkPreviewStyle: LinkPreviewStyle.large,
                                  removeElevation: true,
                                  showDomain: false,
                                  showBody: false,
                                  showTitle: false,
                                  graphicFit: BoxFit.contain,
                                  onTap: () {},
                                  placeholderWidget: Skeleton(
                                    borderRadius: 12,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    CommunitiesRepo repo =
                                        Get.put(CommunitiesRepo());
                                    await repo.getCommunityDetails(
                                      companyRepo.tickerSearch.value
                                          .result![index].communityId!,
                                    );
                                    Get.to(
                                      () => ChatScreen(
                                        members: "",
                                        title: companyRepo.tickerSearch.value
                                            .result![index].name!,
                                        isJoined: chats
                                            .chats.value.communities!.chats!
                                            .any((element) =>
                                                element.id ==
                                                repo.communityProfile.value.id),
                                        chatId:
                                            repo.communityProfile.value.chatId!,
                                        communityId:
                                            repo.communityProfile.value.id!,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    CupertinoIcons
                                        .bubble_left_bubble_right_fill,
                                    color: Color(0xFF4AB5E5),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.to(
                                      () => CompanyFeeds(
                                        companyName: companyRepo.tickerSearch
                                            .value.result![index].name!,
                                        ticker: companyRepo.tickerSearch.value
                                            .result![index].ticker!,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.collections_solid,
                                    color: Color(0xFF4AB5E5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/search_icon.svg",
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "No Companies Found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
