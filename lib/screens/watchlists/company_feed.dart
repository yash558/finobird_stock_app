import 'package:finobird/repository/feed_repo.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom/search_card.dart';
import '../../custom/shimmer_skelton.dart';
import '../../models/feed/feed.dart';
import '../../models/feed/vote.dart';
import '../../repository/user_repo.dart';

class CompanyFeeds extends StatefulWidget {
  const CompanyFeeds({super.key, required this.companyName, this.ticker});
  final String companyName;
  final String? ticker;

  @override
  State<CompanyFeeds> createState() => _CompanyFeedsState();
}

class _CompanyFeedsState extends State<CompanyFeeds> {
  FeedRepo companyFeed = Get.put(FeedRepo());
  var user = Get.put(UserRepo());
  RxBool firstFetch = true.obs;
  RxList<Feed> searchFeeds = <Feed>[].obs;

  fetchingFeeds() {
    firstFetch.value = true;

    if (widget.ticker != null) {
      print(widget.ticker);

      companyFeed.feedSearch(
        query: "",
        limit: 30,
        filtersMap: {
          "tickers": [widget.ticker]
        },
      ).then((List<Feed> list) {
        list.forEach((feed) {
          
          feed.unreadCount = calculateUnreadCount(feed);
        });

        searchFeeds.value = list;
        firstFetch.value = false;
      });
    } else {
      companyFeed.feedSearch(
        query: "",
        limit: 30,
        filtersMap: {},
      ).then((List<Feed> list) {
        list.forEach((feed) {
          // Simulate unread count (replace with your actual logic)
          feed.unreadCount = calculateUnreadCount(feed);
        });

        searchFeeds.value = list;
        firstFetch.value = false;
      });
    }
  }

  int calculateUnreadCount(Feed feed) {
    return 0;
  }

  @override
  void initState() {
    print('22222');
    fetchingFeeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4AB5E5),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          '${widget.companyName} Feeds',
          textScaleFactor: 1,
          style: Styles.text.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(
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
                ? const Center(
                    child: Text(
                      "No Feeds",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      fetchingFeeds();
                    },
                    child: Container(
                      child: ListView.builder(
                        itemCount: searchFeeds.length,
                        padding: const EdgeInsets.symmetric(vertical: 20),
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
                                  searchFeeds[index].votes!.removeAt(voteIndex);
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
    );
  }
}
