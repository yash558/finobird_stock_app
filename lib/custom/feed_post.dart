import 'dart:developer';

import 'package:finobird/custom/shimmer_skelton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/feed/feed.dart';

import '../repository/feed_repo.dart';
import '../repository/user_repo.dart';
import '../repository/watchlist_repo.dart';
import '../screens/dashboard/add_to_watchlist.dart';
import '../screens/dashboard/browse_by.dart';
import '../screens/feeds/company.dart';
import '../constants/styles.dart';

class FeedPost extends StatelessWidget {
  final Feed feed;
  final int index;

  const FeedPost({
    super.key,
    required this.feed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    FeedRepo controller = Get.find();
    UserRepo user = Get.find();
    WatchlistRepo watchlist = Get.put(WatchlistRepo());

    return InkWell(
      onTap: () async {
        await launchUrl(
          Uri.parse(
            feed.link!,
          ),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              onTap: () {
                if (feed.company != null && feed.company!.ticker != null) {
                  Get.to(
                    () => CompanyDetails(
                      ticker: feed.company!.ticker!,
                      companyDetails: feed.company!,
                    ),
                  );
                } else {
                  if (feed.company == null) {
                    log("======>  Company Null");
                  }
                  if (feed.company!.ticker == null) {
                    log("======>  Ticker Null");
                  }
                }
              },
              title: Text(
                feed.company!.name ?? "",
                style: Styles.semiBold.copyWith(
                  fontSize: 16,
                ),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    List companies = [];
                    int selectedWatchListsId = 0;
                    String selectedWatchListsName = '';

                    if (watchlist.myWatchlists.value.watchlists.any((element) =>
                        element.companies!.any(
                            (element) => element.id == feed.company!.id))) {
                      print('unFav');
                      if (watchlist.myWatchlists.value.watchlists.isNotEmpty) {
                        for (int i = 0;
                            i < watchlist.myWatchlists.value.watchlists.length;
                            i++) {
                          for (int j = 0;
                              j <
                                  watchlist.myWatchlists.value.watchlists[i]
                                      .companies!.length;
                              j++) {
                            if (watchlist.myWatchlists.value.watchlists[i]
                                    .companies![j].id ==
                                feed.company!.id) {
                              selectedWatchListsId = watchlist
                                  .myWatchlists.value.watchlists[i].id!;
                              selectedWatchListsName = watchlist
                                  .myWatchlists.value.watchlists[i].name
                                  .toString();
                            }
                          }
                        }

                        for (int i = 0;
                            i < watchlist.myWatchlists.value.watchlists.length;
                            i++) {
                          if (watchlist.myWatchlists.value.watchlists[i].id ==
                              selectedWatchListsId) {
                            for (int j = 0; j < watchlist.myWatchlists.value.watchlists[i].companies!.length; j++) {
                              companies.add(watchlist.myWatchlists.value
                                  .watchlists[i].companies![j].id);
                            }
                          }
                        }

                        companies.remove(feed.company!.id);
                        print('watchListsId  $selectedWatchListsId');
                        print('watchListsName  $selectedWatchListsName');
                        print('companies -- ${companies.toString()}');
                        if(companies.isNotEmpty){
                          watchlist.updateWatchlist(
                            companies,
                            selectedWatchListsId,
                            selectedWatchListsName,
                          );
                        }else{
                          WatchlistRepo().deleteWatchlist(selectedWatchListsId);
                        }

                      }
                    } else {
                      print('Fav');
                      List companies = [];
                      Get.to(
                        () => AddToWatchlist(
                          companies: companies,
                          isFoods: true,
                          companyId: feed.company!.id!,
                        ),
                      );
                    }

                    // Get.to(
                    //   () => BrowseBy(
                    //     watchlists: watchlist.myWatchlists.value.watchlists,
                    //   ),
                    // );
                  },
                  child: watchlist.myWatchlists.value.watchlists.any(
                          (element) => element.companies!
                              .any((element) => element.id == feed.company!.id))
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border_rounded)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinkPreviewGenerator(
                      link: feed.link!,
                      linkPreviewStyle: LinkPreviewStyle.large,
                      removeElevation: true,
                      showDomain: false,
                      showBody: false,
                      showTitle: false,
                      // bodyMaxLines: 3,
                      // bodyTextOverflow: TextOverflow.ellipsis,
                      // bodyStyle: Styles.text.copyWith(
                      //   color: Colors.black.withOpacity(0.8),
                      //   fontSize: 13,
                      // ),
                      // backgroundColor: Color(0xFF4AB5E5).withOpacity(0.5)!,
                      placeholderWidget: Skeleton(
                        borderRadius: 12,
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    feed.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.semiBold.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: Styles.text.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: feed.source ?? "",
                          style: const TextStyle(color: Colors.brown),
                        ),
                        TextSpan(
                          text: feed.pubDate != null
                              ? ", ${DateFormat("dd MMM, yyyy  hh:mm").format(feed.pubDate!)}"
                              : "",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ValueListenableBuilder<List<Feed>>(
                    valueListenable: controller.feedList,
                    builder: (context, up, child) => Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.upDownvoteFeed(
                              true,
                              feed.id!,
                              index,
                              user,
                            );
                          },
                          icon: Icon(
                            feed.votes!.any((element) =>
                                    element.profileId ==
                                        user.profile.value.id &&
                                    element.positive!)
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color: feed.votes!.any((element) =>
                                    element.profileId ==
                                        user.profile.value.id &&
                                    element.positive!)
                                ? const Color(0xFF4AB5E5)
                                : Colors.black.withOpacity(0.6),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.upDownvoteFeed(
                              false,
                              feed.id!,
                              index,
                              user,
                            );
                          },
                          icon: Icon(
                            feed.votes!.any((element) =>
                                    element.profileId ==
                                        user.profile.value.id &&
                                    !element.positive!)
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            fill: 1.0,
                            color: feed.votes!.any((element) =>
                                    element.profileId ==
                                        user.profile.value.id &&
                                    !element.positive!)
                                ? Colors.red
                                : Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Share.share(
                        "${feed.title}\n${feed.link}\n\nGet latest news and trends about your favourite companies using the Finobird app.",
                      );
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
