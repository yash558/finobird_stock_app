import 'package:finobird/repository/feed_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom/search_card.dart';
import '../../custom/shimmer_skelton.dart';
import '../../models/feed/feed.dart';
import '../../models/feed/vote.dart';
import '../../repository/user_repo.dart';
import '../../constants/styles.dart';

class WatchlistFeeds extends StatefulWidget {
  const WatchlistFeeds({
    super.key,
    required this.watchlistName,
    required this.watchlistId,
  });
  final String watchlistName;
  final int watchlistId;

  @override
  State<WatchlistFeeds> createState() => _WatchlistFeedsState();
}

class _WatchlistFeedsState extends State<WatchlistFeeds> {
  var controller = Get.put(FeedRepo());
  var user = Get.put(UserRepo());
  RxBool firstFetch = true.obs;
  RxList<Feed> searchFeeds = <Feed>[].obs;

  getFeed() {
    firstFetch.value = true;
    controller.fetchWatchlistFeed(widget.watchlistId, 50).then((List<Feed> list) {
      searchFeeds.value = list;
      firstFetch.value = false;
    });
  }

  @override
  void initState() {
    getFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4AB5E5).withOpacity(0.5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF4AB5E5).withOpacity(0.5),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          '${widget.watchlistName} Feeds',
          textScaleFactor: 1,
          style: Styles.text.copyWith(
            color: Colors.white,
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
                      getFeed();
                    },
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
                              int voteIndex = searchFeeds[index]
                                  .votes!
                                  .indexWhere(
                                    (element) =>
                                        element.profileId == feedVote.profileId,
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
    );
  }
}
