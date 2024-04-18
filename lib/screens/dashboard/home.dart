import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:finobird/constants/colors.dart';
import 'package:finobird/main.dart';
import 'package:finobird/screens/chat/chat_screen.dart';
import 'package:finobird/screens/dashboard/navigation.dart';
import 'package:finobird/screens/dashboard/search_community.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom/add_card.dart';
// import '../../custom/announcement_card.dart';
import '../../custom/browse_card.dart';
import '../../custom/shimmer_skelton.dart';
import '../../custom/trending_community.dart';
import '../../models/chat/get_chat_list.dart';
import '../../repository/authentication.dart';
import '../../repository/community_repo.dart';
import '../../repository/feed_repo.dart';
import '../../repository/user_repo.dart';
import '../../repository/watchlist_repo.dart';
import '../../constants/styles.dart';
import '../chat/notification_model.dart';
import '../search.dart';
import '../watchlists/company_feed.dart';
import 'add_company.dart';
import 'browse_by.dart';
// import 'latest_updates.dart';
import 'trending.dart';
import 'watchlist_companies.dart';
import 'watchlist_feeds.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final TextEditingController _search;
  final Function() ontap;
  const Home({
    Key? key,
    required TextEditingController search,
    required this.ontap,
  })  : _search = search,
        super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('message ---> ${message.data.toString()}');
        if (message.data['chat'] != null) {
          ChatNotificationModel chatNotificationModel =
              ChatNotificationModel.fromJson(message.data);
          Navigator.push(
              navKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        notificationCommunityId:
                            chatNotificationModel.chat!.communityId.toString(),
                        title: chatNotificationModel.chat!.sender!.username
                            .toString(),
                        members: '44.7k',
                        isJoined: true,
                        chatId:
                            chatNotificationModel.chat!.communityId.toString(),
                        communityId: chatNotificationModel.chat!.id!,
                      )));

          // ChatNotificationModel chatNotificationModel = ChatNotificationModel.fromJson(message.data);
          // Navigator.push(navKey.currentContext!, MaterialPageRoute(builder: (context)=>   ChatScreen(
          //   title: chatNotificationModel.chat!.sender!.username.toString(),
          //   members: '44.7k',
          //   // community: communitiesRepo.communities.value.communities!.first,
          //   chat: Chats(
          //       avatarUrl:chatNotificationModel.chat!.sender!.avatarUrl.toString(),
          //       chatId: chatNotificationModel.chat!.communityId.toString(),
          //       companyId: chatNotificationModel.chat!.senderId,
          //       name:  chatNotificationModel.chat!.sender!.username.toString(),
          //       id: chatNotificationModel.chat!.id,
          //       description: chatNotificationModel.contentPreview.toString()), chatId: chatNotificationModel.chat!.communityId.toString(), communityId: chatNotificationModel.chat!.id!,
          //   isJoined: true,
          // ),
          // ));
        } else if (message.data['feed'] != null) {
          FeedNotificationModel feedNotificationModel =
              FeedNotificationModel.fromJson(message.data);
          if (feedNotificationModel.feed!.companyTicker != null) {
            Navigator.push(
                navKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => CompanyFeeds(
                        companyName:
                            feedNotificationModel.feed!.companyTicker)));
          } else {
            Navigator.push(navKey.currentContext!,
                MaterialPageRoute(builder: (context) => Navigation(index: 1)));
          }
          print('firebaseCloudMessagingListeners else');
        }
      }
    });
  }

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
            controller.getBannerLists(true);
          },
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.27,
                    padding:
                        const EdgeInsets.only(top: 08, left: 20, right: 20),
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(27),
                            bottomRight: Radius.circular(27))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, right: 15, left: 15, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.profile.value.firstName ?? "",
                                textScaleFactor: 1,
                                style: Styles.text.copyWith(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: widget.ontap,
                            child: user.profile.value.avatarUrl == null
                                ? const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xFF4AB5E5),
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
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        right: 20,
                        left: 20,
                        bottom: 8,
                        top: MediaQuery.of(context).size.width * 0.22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        const Icon(
                          LineIcons.search,
                          size: 22,
                        ),
                        Expanded(
                          child: TextField(
                            controller: widget._search,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            onSubmitted: search,
                            decoration: InputDecoration(
                              hintText: "Search Stocks",
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CarouselSlider(
                            // carouselController: _controller,
                            options: CarouselOptions(
                                autoPlay: true,
                                enableInfiniteScroll: true,
                                padEnds: false,
                                enlargeCenterPage: false,
                                aspectRatio: 2.75,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  controller.bannerCurrentIndex.value = index;
                                }),
                            items: controller.bannerModelList.value.states!
                                .map((item) => GestureDetector(
                                      onTap: () async {
                                        launchUrl(
                                            Uri.parse(item.link.toString()));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                          child: Image.network(
                                              item.image.toString(),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            alignment: Alignment.bottomCenter,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: controller
                                    .bannerModelList.value.states!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return GestureDetector(
                                    //  onTap: () => _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 08,
                                      height: 08.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller.bannerCurrentIndex
                                                      .value ==
                                                  entry.key
                                              ? primaryColor
                                              : Colors.grey),
                                    ),
                                  );
                                }).toList()),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 08),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Watchlists',
                                    textScaleFactor: 1,
                                    style: Styles.text.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => BrowseBy(
                                          watchlists: watchlist
                                              .myWatchlists.value.watchlists,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        'View all',
                                        textScaleFactor: 1,
                                        style: Styles.text.copyWith(
                                          fontSize: 10,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 80,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: watchlist.fetchWatchList,
                                builder: (context, wf, child) => wf
                                    ? ListView.builder(
                                        itemCount: 4,
                                        scrollDirection: Axis.horizontal,
                                        controller: scrollController,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Skeleton(
                                            borderRadius: 12,
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: watchlist.myWatchlists.value
                                                .watchlists.length +
                                            1,
                                        scrollDirection: Axis.horizontal,
                                        controller: scrollController,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) =>
                                            (index ==
                                                    watchlist.myWatchlists.value
                                                        .watchlists.length)
                                                ? CustomAddCard(
                                                    onPress: () {
                                                      Get.to(
                                                        () =>
                                                            const AddWatchlistCompany(
                                                          isFromWatchlist:
                                                              false,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : BrowseCard(
                                                    title: watchlist
                                                            .myWatchlists
                                                            .value
                                                            .watchlists[index]
                                                            .name ??
                                                        "",
                                                    watchlistId: watchlist
                                                        .myWatchlists
                                                        .value
                                                        .watchlists[index]
                                                        .id!,
                                                    ontap: () {
                                                      Get.to(
                                                        () =>
                                                            WatchlistCompanies(
                                                          id: watchlist
                                                              .myWatchlists
                                                              .value
                                                              .watchlists[index]
                                                              .id!,
                                                          name: watchlist
                                                              .myWatchlists
                                                              .value
                                                              .watchlists[index]
                                                              .name!,
                                                          companies: watchlist
                                                              .myWatchlists
                                                              .value
                                                              .watchlists[index]
                                                              .companies!,
                                                        ),
                                                        transition:
                                                            Transition.fadeIn,
                                                      );
                                                    },
                                                    getWatchlistFeed: () {
                                                      List companyTickers = [];
                                                      for (var element
                                                          in watchlist
                                                              .myWatchlists
                                                              .value
                                                              .watchlists[index]
                                                              .companies!) {
                                                        var map = {
                                                          "ticker":
                                                              "${element.ticker}",
                                                        };
                                                        companyTickers.add(map);
                                                      }
                                                      Get.to(
                                                        () => WatchlistFeeds(
                                                          watchlistName:
                                                              watchlist
                                                                  .myWatchlists
                                                                  .value
                                                                  .watchlists[
                                                                      index]
                                                                  .name!,
                                                          watchlistId: watchlist
                                                              .myWatchlists
                                                              .value
                                                              .watchlists[index]
                                                              .id!,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Trending Communities',
                                    textScaleFactor: 1,
                                    style: Styles.text.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => CommunitySearch(
                                          trendingCommunities: controller
                                              .communities.value.communities,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        'View all',
                                        textScaleFactor: 1,
                                        style: Styles.text.copyWith(
                                          fontSize: 10,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 145,
                              width: double.maxFinite,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: controller.fetchCommunity,
                                builder: (context, cf, child) => cf
                                    ? ListView.builder(
                                        itemCount: 4,
                                        scrollDirection: Axis.horizontal,
                                        controller: controller1,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Skeleton(
                                            borderRadius: 12,
                                            width: 100,
                                            height: 110,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.communities.value
                                            .communities.length,
                                        scrollDirection: Axis.horizontal,
                                        controller: controller1,
                                        itemBuilder: (context, index) {
                                          return TrendingCommunity(
                                            community: controller.communities
                                                .value.communities[index],
                                            rightPadding: index ==
                                                (controller.communities.value
                                                        .communities.length -
                                                    1),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 08),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 13),
                            Expanded(
                              child: customClickRow(
                                CupertinoIcons.person_3_fill,
                                // Icons.people_alt_rounded,
                                'Join Community',
                                () async {
                                  await launchUrl(
                                      Uri.parse(
                                          "https://chat.whatsapp.com/FR23Tfdo6CZ9TBP4awYlPc"),
                                      mode: LaunchMode.externalApplication);
                                },
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: customClickRow(
                                CupertinoIcons.book_circle_fill,
                                // Icons.book_rounded,
                                'Learn',
                                () async {
                                  await launchUrl(
                                      Uri.parse(
                                          "https://youtube.com/@finobird/playlists"),
                                      mode: LaunchMode.externalApplication);
                                },
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: customClickRow(
                                CupertinoIcons.share_solid,
                                // Icons.ios_share_rounded,
                                'Refer',
                                () async {
                                  await Share.share(
                                    "Hey!! Check out this app called FinoBird.\nYou can track your investments with ease. I am loving it! \nhttps://play.google.com/store/apps/details?id=com.finobird.app",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 13),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(8),
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 10,
                      //   ),
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 15),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               'Announcements',
                      //               textScaleFactor: 1,
                      //               style: Styles.text.copyWith(
                      //                 fontSize: 15,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //             InkWell(
                      //               onTap: () {
                      //           Get.to(
                      //             () => Announcements(
                      //               announcements: feed,
                      //             ),
                      //           );
                      //               },
                      //               child: Container(
                      //                 padding: const EdgeInsets.symmetric(
                      //                   horizontal: 12,
                      //                   vertical: 5,
                      //                 ),
                      //                 decoration: BoxDecoration(
                      //                   color: Color(0xFF4AB5E5).withOpacity(0.5),
                      //                   borderRadius: BorderRadius.circular(100),
                      //                 ),
                      //                 child: Text(
                      //                   'View all',
                      //                   textScaleFactor: 1,
                      //                   style: Styles.text.copyWith(
                      //                     fontSize: 10,
                      //                     color: Colors.black,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(height: 15),
                      //       SizedBox(
                      //         height: 180,
                      //         width: double.maxFinite,
                      //         child: ValueListenableBuilder<bool>(
                      //           valueListenable: controller.fetchCommunity,
                      //           builder: (context, cf, child) => cf
                      //               ? ListView.builder(
                      //                   itemCount: 2,
                      //                   scrollDirection: Axis.horizontal,
                      //                   controller: controller1,
                      //                   itemBuilder: (context, index) => Padding(
                      //                     padding: const EdgeInsets.only(left: 15),
                      //                     child: Skeleton(
                      //                       borderRadius: 12,
                      //                       height: 180,
                      //                       width: 160,
                      //                     ),
                      //                   ),
                      //                 )
                      //               : ListView.builder(
                      //                   padding: EdgeInsets.zero,
                      //                   itemCount: controller
                      //                       .communities.value.communities.length,
                      //                   scrollDirection: Axis.horizontal,
                      //                   controller: controller1,
                      //                   itemBuilder: (context, index) {
                      //                     return TrendingCommunity(
                      //                       community: controller
                      //                           .communities.value.communities[index],
                      //                       rightPadding: index ==
                      //                           (controller.communities.value
                      //                                   .communities.length -
                      //                               1),
                      //                     );
                      //                   },
                      //                 ),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 2),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Announcements',
                      //         textScaleFactor: 1,
                      //         style: Styles.text.copyWith(
                      //           color: Colors.black,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       IconButton(
                      //         onPressed: () {
                      //           Get.to(
                      //             () => Announcements(
                      //               announcements: feed,
                      //             ),
                      //           );
                      //         },
                      //         icon: const Icon(
                      //           Icons.arrow_forward_ios_rounded,
                      //           size: 20,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // ...List.generate(
                      //   feed.announcements.value.table == null
                      //       ? 0
                      //       : feed.announcements.value.table!.length,
                      //   // : 5,
                      //   (index) => feed.announcements.value.table == null ||
                      //           feed.announcements.value.table!.isEmpty
                      //       ? const AnnouncementCardSkelton()
                      //       : AnnouncementCard(
                      //           feed: feed,
                      //           index: index,
                      //         ),
                      // ),
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

  Widget customClickRow(IconData icons, String text, Function() ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(icons, size: 30, color: primaryColor),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Styles.text.copyWith(fontSize: 12),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
