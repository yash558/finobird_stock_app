// ignore_for_file: must_be_immutable

import 'package:finobird/custom/textfield.dart';
import 'package:finobird/repository/feed_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../custom/search_card.dart';
import '../../custom/shimmer_skelton.dart';
import '../../models/feed/feed.dart';
import '../../models/feed/vote.dart';
import '../../repository/user_repo.dart';

class FeedSearch extends StatefulWidget {
  const FeedSearch({super.key});

  @override
  State<FeedSearch> createState() => _FeedSearchState();
}

class _FeedSearchState extends State<FeedSearch> {
  final FeedRepo feedSearch = Get.put(FeedRepo());
  var user = Get.put(UserRepo());
  RxList<Feed> searchFeeds = <Feed>[].obs;
  RxString submitted = "Search for feeds".obs;
  RxBool firstFetch = false.obs;
  RxBool moreFetch = false.obs;
  int? startPage;

  onSubmit(String search, bool more) {
    if (more && moreFetch.value) {
      return;
    }
    if (more) {
      moreFetch.value = true;
    } else {
      startPage = null;
      firstFetch.value = true;
    }
    feedSearch
        .feedSearch(
      query: search,
      limit: 10,
      filtersMap: !feedSearch.filtered
          ? {}
          : {
              "feedSource": feedSearch.createFeedSource(),
              if (feedSearch.startDate.value != "")
                "minDateTime": feedSearch.startDate.value,
              if (feedSearch.endDate.value != "")
                "maxDateTime": feedSearch.endDate.value,
            },
      startPage: startPage,
      changeStartPage: (int? value) {
        startPage = value;
      },
    )
        .then((List<Feed> value) {
      if (more) {
        searchFeeds.addAll(value);
        searchFeeds.refresh();
      } else {
        searchFeeds.value = value;
      }
      if (searchFeeds.isEmpty) {
        submitted.value = "No results found\nPlease try with a different query";
      }
      if (more) {
        moreFetch.value = false;
      } else {
        firstFetch.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    var scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        onSubmit(controller.text, true);
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            CustomTextField(
              controller: controller,
              text: "Search",
              type: TextInputType.text,
              onSubmit: (String text) {
                onSubmit(text, false);
              },
            ),
            Expanded(
              child: Obx(
                () => firstFetch.value
                    ? ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 10,
                            ),
                            child: Skeleton(
                              borderRadius: 20,
                              height: 270,
                            ),
                          );
                        },
                      )
                    : searchFeeds.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/search_icon.svg",
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    submitted.value,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              onSubmit(controller.text, false);
                            },
                            child: ListView.builder(
                              itemCount: searchFeeds.length,
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                return SearchCard(
                                  feed: searchFeeds[index],
                                  voteUpdate: (
                                    FeedVote feedVote,
                                    bool upVote,
                                    Function refresh,
                                  ) {
                                    if (feedVote.profileId != null) {
                                      int voteIndex =
                                          searchFeeds[index].votes!.indexWhere(
                                                (element) =>
                                                    element.profileId ==
                                                    feedVote.profileId,
                                              );
                                      if (voteIndex != -1) {
                                        searchFeeds[index]
                                            .votes!
                                            .removeAt(voteIndex);
                                        searchFeeds[index].votes!.add(feedVote);
                                      } else {
                                        searchFeeds[index].votes!.add(feedVote);
                                      }
                                    } else {
                                      int anotherIndex =
                                          searchFeeds[index].votes!.indexWhere(
                                                (element) =>
                                                    element.profileId ==
                                                    user.profile.value.id,
                                              );
                                      if (anotherIndex != -1) {
                                        searchFeeds[index]
                                            .votes!
                                            .removeAt(anotherIndex);
                                      }
                                    }
                                    refresh();
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ),
            Obx(
              () => moreFetch.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
