// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:finobird/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../custom/add_card_old.dart';
import '../../custom/announcement_card.dart';
import '../../custom/browse_card_old.dart';
import '../../custom/shimmer_skelton.dart';
import '../../custom/trending_community.dart';
import '../../repository/community_repo.dart';
import '../../repository/feed_repo.dart';
import '../../repository/user_repo.dart';
import '../../repository/watchlist_repo.dart';
import '../../constants/styles.dart';
import '../profile/profile.dart';
import '../search.dart';
import 'add_company.dart';
import 'browse_by.dart';
import 'latest_updates.dart';
import 'trending.dart';
import 'watchlist_companies.dart';
import 'watchlist_feeds.dart';

class HomeOld extends StatelessWidget {
  final TextEditingController _search;
  const HomeOld({
    Key? key,
    required TextEditingController search,
  })  : _search = search,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    CommunitiesRepo controller = Get.put(CommunitiesRepo());
    UserRepo user = Get.find();
    WatchlistRepo watchlist = Get.put(WatchlistRepo());
    var feed = Get.put(FeedRepo());
    ScrollController scrollController = ScrollController(),
        controller1 = ScrollController();

    search(search) {
      Get.to(
        () => Search(
          searchText: search,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            controller.getCommunities(true);
            watchlist.getWatchlists(100, true);
            feed.getAnnouncements();
            user.getUserProfile();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Get.mediaQuery.padding.top),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // time.hour < 12
                            //     ? 'Good Morning! 😊'
                            //     : time.hour > 12 && time.hour <= 15
                            //         ? "Good Afternoon! 😊"
                            //         : time.hour > 15 && time.hour < 20
                            //             ? "Good Evening! 😊"
                            //             : "Hello!",
                            "Hello! 😊",
                            textScaleFactor: 1,
                            style: Styles.text.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user.profile.value.username ?? "",
                            textScaleFactor: 1,
                            style: Styles.text.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const Material(child: ProfileScreen()));
                        },
                        child: user.profile.value.avatarUrl == null
                            ? const CircleAvatar(
                                radius: 25,
                                foregroundColor: primaryColor,
                                backgroundColor: primaryColor,
                              )
                            : SizedBox(
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    user.profile.value.avatarUrl!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    controller: _search,
                    placeholder: 'Explore',
                    showCursor: true,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    style: Styles.small,
                    placeholderStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    onSubmitted: search,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black45,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        LineIcons.search,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Watchlists',
                        textScaleFactor: 1,
                        style: Styles.text.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => BrowseBy(
                              watchlists:
                                  watchlist.myWatchlists.value.watchlists,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: watchlist.fetchWatchList,
                    builder: (context, wf, child) => wf
                        ? ListView.builder(
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Skeleton(
                                borderRadius: 20,
                                height: 20,
                                width: 180,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                watchlist.myWatchlists.value.watchlists.length +
                                    1,
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            itemBuilder: (context, index) => (index ==
                                    watchlist
                                        .myWatchlists.value.watchlists.length)
                                ? CustomAddCardOld(
                                    onPress: () {
                                      log("add button pressed");
                                      Get.to(
                                        () => const AddWatchlistCompany(
                                          isFromWatchlist: false,
                                        ),
                                      );
                                    },
                                  )
                                : BrowseCardOld(
                                    // color: const Color(0xffC190FF),
                                    title: watchlist.myWatchlists.value
                                            .watchlists[index].name ??
                                        "",
                                    // subtitle: '23 new\nupdates',
                                    ontap: () {
                                      Get.to(
                                        () => WatchlistCompanies(
                                          id: watchlist.myWatchlists.value
                                              .watchlists[index].id!,
                                          name: watchlist.myWatchlists.value
                                              .watchlists[index].name!,
                                          companies: watchlist
                                              .myWatchlists
                                              .value
                                              .watchlists[index]
                                              .companies!,
                                        ),
                                        transition: Transition.fadeIn,
                                        duration: const Duration(seconds: 1),
                                      );
                                    },
                                    id: watchlist.myWatchlists.value
                                        .watchlists[index].id!,
                                    // isHorizontal: false,
                                    getWatchlistFeed: () {
                                      List companyTickers = [];
                                      for (var element in watchlist.myWatchlists
                                          .value.watchlists[index].companies!) {
                                        var map = {
                                          "ticker": "${element.ticker}",
                                        };
                                        companyTickers.add(map);
                                      }
                                      Get.to(
                                        () => WatchlistFeeds(
                                          watchlistName: watchlist.myWatchlists
                                              .value.watchlists[index].name!,
                                          watchlistId:  watchlist.myWatchlists
                                              .value.watchlists[index].id!,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Communities',
                        textScaleFactor: 1,
                        style: Styles.text.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => TrendingCommunities(
                              communities:
                                  controller.communities.value.communities,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 180,
                  width: double.maxFinite,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: controller.fetchCommunity,
                    builder: (context, cf, child) => cf
                        ? ListView.builder(
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            controller: controller1,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Skeleton(
                                borderRadius: 20,
                                height: 20,
                                width: 180,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                controller.communities.value.communities.length,
                            // 5,
                            scrollDirection: Axis.horizontal,
                            controller: controller1,
                            itemBuilder: (context, index) {
                              return controller
                                      .communities.value.communities.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Skeleton(
                                        borderRadius: 20,
                                        height: 20,
                                        width: 180,
                                      ),
                                    )
                                  : TrendingCommunity(
                                      community: controller
                                          .communities.value.communities[index],
                                      rightPadding: false,
                                    );
                            },
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Announcements',
                        textScaleFactor: 1,
                        style: Styles.text.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => Announcements(
                              announcements: feed,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  feed.announcements.value.table == null
                      ? 0
                      : feed.announcements.value.table!.length,
                  // : 5,
                  (index) => feed.announcements.value.table == null ||
                          feed.announcements.value.table!.isEmpty
                      ? const AnnouncementCardSkelton()
                      : AnnouncementCard(
                          feed: feed,
                          index: index,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
