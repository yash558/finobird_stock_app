// // ignore_for_file: invalid_use_of_protected_member

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:line_icons/line_icons.dart';

// import '../../custom/add_card.dart';
// // import '../../custom/announcement_card.dart';
// import '../../custom/browse_card.dart';
// import '../../custom/shimmer_skelton.dart';
// import '../../custom/trending_community.dart';
// import '../../repository/community_repo.dart';
// import '../../repository/feed_repo.dart';
// import '../../repository/user_repo.dart';
// import '../../repository/watchlist_repo.dart';
// import '../../styles.dart';
// import '../profile/profile.dart';
// import '../search.dart';
// import 'add_company.dart';
// import 'browse_by.dart';
// // import 'latest_updates.dart';
// import 'trending.dart';
// import 'watchlist_companies.dart';
// import 'watchlist_feeds.dart';

// class Home extends StatelessWidget {
//   final TextEditingController _search;
//   const Home({
//     Key? key,
//     required TextEditingController search,
//   })  : _search = search,
//         super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     CommunitiesRepo controller = Get.put(CommunitiesRepo());
//     UserRepo user = Get.find();
//     WatchlistRepo watchlist = Get.put(WatchlistRepo());
//     var feed = Get.put(FeedRepo());
//     ScrollController scrollController = ScrollController(),
//         controller1 = ScrollController();

//     search(search) {
//       Get.to(
//         () => Search(
//           searchText: search,
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Obx(
//         () => RefreshIndicator(
//           onRefresh: () async {
//             controller.getCommunities(true);
//             watchlist.getWatchlists(100, true);
//             feed.getAnnouncements();
//             user.getUserProfile();
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: Get.mediaQuery.padding.top),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             // time.hour < 12
//                             //     ? 'Good Morning! 😊'
//                             //     : time.hour > 12 && time.hour <= 15
//                             //         ? "Good Afternoon! 😊"
//                             //         : time.hour > 15 && time.hour < 20
//                             //             ? "Good Evening! 😊"
//                             //             : "Hello!",
//                             "Hello! 😊",
//                             textScaleFactor: 1,
//                             style: Styles.text.copyWith(
//                               fontSize: 14,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             user.profile.value.username ?? "",
//                             textScaleFactor: 1,
//                             style: Styles.text.copyWith(
//                               fontSize: 16,
//                               color: Colors.black.withOpacity(0.6),
//                             ),
//                           ),
//                         ],
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Get.to(() => Material(child: ProfileScreen()));
//                         },
//                         child: user.profile.value.avatarUrl == null
//                             ? const CircleAvatar(
//                                 radius: 25,
//                                 backgroundColor: Color(0xFF4AB5E5),
//                               )
//                             : SizedBox(
//                                 height: 40,
//                                 width: 40,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(25),
//                                   child: Image.network(
//                                     user.profile.value.avatarUrl!,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 15),
//                       const Icon(
//                         LineIcons.search,
//                         size: 22,
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: _search,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w400,
//                           ),
//                           onSubmitted: search,
//                           decoration: InputDecoration(
//                             hintText: "Search Stocks",
//                             hintStyle: TextStyle(
//                               fontSize: 15,
//                               color: Colors.black.withOpacity(0.6),
//                               fontWeight: FontWeight.w400,
//                             ),
//                             border: InputBorder.none,
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 15,
//                               vertical: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(8),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10,
//                   ),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Watchlists',
//                               textScaleFactor: 1,
//                               style: Styles.text.copyWith(
//                                 fontSize: 12,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Get.to(
//                                   () => BrowseBy(
//                                     watchlists:
//                                         watchlist.myWatchlists.value.watchlists,
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFF4AB5E5).withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(100),
//                                 ),
//                                 child: Text(
//                                   'View all',
//                                   textScaleFactor: 1,
//                                   style: Styles.text.copyWith(
//                                     fontSize: 8,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       SizedBox(
//                         height: 100,
//                         child: ValueListenableBuilder<bool>(
//                           valueListenable: watchlist.fetchWatchList,
//                           builder: (context, wf, child) => wf
//                               ? ListView.builder(
//                                   itemCount: 4,
//                                   scrollDirection: Axis.horizontal,
//                                   controller: scrollController,
//                                   itemBuilder: (context, index) => Padding(
//                                     padding: const EdgeInsets.only(left: 15),
//                                     child: Skeleton(
//                                       borderRadius: 12,
//                                       height: 100,
//                                       width: 100,
//                                     ),
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   itemCount: watchlist.myWatchlists.value
//                                           .watchlists.length +
//                                       1,
//                                   scrollDirection: Axis.horizontal,
//                                   controller: scrollController,
//                                   padding: EdgeInsets.zero,
//                                   itemBuilder: (context, index) => (index ==
//                                           watchlist.myWatchlists.value
//                                               .watchlists.length)
//                                       ? CustomAddCard(
//                                           onPress: () {
//                                             log("add button pressed");
//                                             Get.to(
//                                               () => const AddWatchlistCompany(
//                                                 isFromWatchlist: false,
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       : BrowseCard(
//                                           color: const Color(0xffC190FF),
//                                           title: watchlist.myWatchlists.value
//                                                   .watchlists[index].name ??
//                                               "",
//                                           subtitle: '23 new\nupdates',
//                                           ontap: () {
//                                             Get.to(
//                                               () => WatchlistCompanies(
//                                                 id: watchlist.myWatchlists.value
//                                                     .watchlists[index].id!,
//                                                 name: watchlist
//                                                     .myWatchlists
//                                                     .value
//                                                     .watchlists[index]
//                                                     .name!,
//                                                 companies: watchlist
//                                                     .myWatchlists
//                                                     .value
//                                                     .watchlists[index]
//                                                     .companies!,
//                                               ),
//                                               transition: Transition.fadeIn,
//                                               duration:
//                                                   const Duration(seconds: 1),
//                                             );
//                                           },
//                                           id: watchlist.myWatchlists.value
//                                               .watchlists[index].id!,
//                                           isHorizontal: false,
//                                           getWatchlistFeed: () {
//                                             List companyTickers = [];
//                                             for (var element in watchlist
//                                                 .myWatchlists
//                                                 .value
//                                                 .watchlists[index]
//                                                 .companies!) {
//                                               var map = {
//                                                 "ticker": "${element.ticker}",
//                                               };
//                                               companyTickers.add(map);
//                                             }
//                                             Get.to(
//                                               () => WatchlistFeeds(
//                                                 watchlistName: watchlist
//                                                     .myWatchlists
//                                                     .value
//                                                     .watchlists[index]
//                                                     .name!,
//                                                 tickers: companyTickers,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(8),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 10,
//                   ),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Trending Communities',
//                               textScaleFactor: 1,
//                               style: Styles.text.copyWith(
//                                 fontSize: 12,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Get.to(
//                                   () => TrendingCommunities(
//                                     communities: controller
//                                         .communities.value.communities,
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xFF4AB5E5).withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(100),
//                                 ),
//                                 child: Text(
//                                   'View all',
//                                   textScaleFactor: 1,
//                                   style: Styles.text.copyWith(
//                                     fontSize: 8,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       SizedBox(
//                         height: 125,
//                         width: double.maxFinite,
//                         child: ValueListenableBuilder<bool>(
//                           valueListenable: controller.fetchCommunity,
//                           builder: (context, cf, child) => cf
//                               ? ListView.builder(
//                                   itemCount: 4,
//                                   scrollDirection: Axis.horizontal,
//                                   controller: controller1,
//                                   itemBuilder: (context, index) => Padding(
//                                     padding: const EdgeInsets.only(left: 15),
//                                     child: Skeleton(
//                                       borderRadius: 12,
//                                       height: 125,
//                                       width: 110,
//                                     ),
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   itemCount: controller
//                                       .communities.value.communities.length,
//                                   scrollDirection: Axis.horizontal,
//                                   controller: controller1,
//                                   itemBuilder: (context, index) {
//                                     return TrendingCommunity(
//                                       community: controller
//                                           .communities.value.communities[index],
//                                       rightPadding: index ==
//                                           (controller.communities.value
//                                                   .communities.length -
//                                               1),
//                                     );
//                                   },
//                                 ),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                     ],
//                   ),
//                 ),
//                 // Container(
//                 //   margin: const EdgeInsets.all(8),
//                 //   padding: const EdgeInsets.symmetric(
//                 //     vertical: 10,
//                 //   ),
//                 //   width: double.infinity,
//                 //   decoration: BoxDecoration(
//                 //     color: Colors.white,
//                 //     borderRadius: BorderRadius.circular(12),
//                 //   ),
//                 //   child: Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       Padding(
//                 //         padding: const EdgeInsets.symmetric(horizontal: 15),
//                 //         child: Row(
//                 //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //           children: [
//                 //             Text(
//                 //               'Announcements',
//                 //               textScaleFactor: 1,
//                 //               style: Styles.text.copyWith(
//                 //                 fontSize: 15,
//                 //                 color: Colors.black,
//                 //               ),
//                 //             ),
//                 //             InkWell(
//                 //               onTap: () {
//                 //           Get.to(
//                 //             () => Announcements(
//                 //               announcements: feed,
//                 //             ),
//                 //           );
//                 //               },
//                 //               child: Container(
//                 //                 padding: const EdgeInsets.symmetric(
//                 //                   horizontal: 12,
//                 //                   vertical: 5,
//                 //                 ),
//                 //                 decoration: BoxDecoration(
//                 //                   color: Color(0xFF4AB5E5).withOpacity(0.5),
//                 //                   borderRadius: BorderRadius.circular(100),
//                 //                 ),
//                 //                 child: Text(
//                 //                   'View all',
//                 //                   textScaleFactor: 1,
//                 //                   style: Styles.text.copyWith(
//                 //                     fontSize: 10,
//                 //                     color: Colors.black,
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //       const SizedBox(height: 15),
//                 //       SizedBox(
//                 //         height: 180,
//                 //         width: double.maxFinite,
//                 //         child: ValueListenableBuilder<bool>(
//                 //           valueListenable: controller.fetchCommunity,
//                 //           builder: (context, cf, child) => cf
//                 //               ? ListView.builder(
//                 //                   itemCount: 2,
//                 //                   scrollDirection: Axis.horizontal,
//                 //                   controller: controller1,
//                 //                   itemBuilder: (context, index) => Padding(
//                 //                     padding: const EdgeInsets.only(left: 15),
//                 //                     child: Skeleton(
//                 //                       borderRadius: 12,
//                 //                       height: 180,
//                 //                       width: 160,
//                 //                     ),
//                 //                   ),
//                 //                 )
//                 //               : ListView.builder(
//                 //                   padding: EdgeInsets.zero,
//                 //                   itemCount: controller
//                 //                       .communities.value.communities.length,
//                 //                   scrollDirection: Axis.horizontal,
//                 //                   controller: controller1,
//                 //                   itemBuilder: (context, index) {
//                 //                     return TrendingCommunity(
//                 //                       community: controller
//                 //                           .communities.value.communities[index],
//                 //                       rightPadding: index ==
//                 //                           (controller.communities.value
//                 //                                   .communities.length -
//                 //                               1),
//                 //                     );
//                 //                   },
//                 //                 ),
//                 //         ),
//                 //       ),
//                 //       const SizedBox(height: 2),
//                 //     ],
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Text(
//                 //         'Announcements',
//                 //         textScaleFactor: 1,
//                 //         style: Styles.text.copyWith(
//                 //           color: Colors.black,
//                 //           fontSize: 16,
//                 //           fontWeight: FontWeight.bold,
//                 //         ),
//                 //       ),
//                 //       IconButton(
//                 //         onPressed: () {
//                 //           Get.to(
//                 //             () => Announcements(
//                 //               announcements: feed,
//                 //             ),
//                 //           );
//                 //         },
//                 //         icon: const Icon(
//                 //           Icons.arrow_forward_ios_rounded,
//                 //           size: 20,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 // ...List.generate(
//                 //   feed.announcements.value.table == null
//                 //       ? 0
//                 //       : feed.announcements.value.table!.length,
//                 //   // : 5,
//                 //   (index) => feed.announcements.value.table == null ||
//                 //           feed.announcements.value.table!.isEmpty
//                 //       ? const AnnouncementCardSkelton()
//                 //       : AnnouncementCard(
//                 //           feed: feed,
//                 //           index: index,
//                 //         ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
