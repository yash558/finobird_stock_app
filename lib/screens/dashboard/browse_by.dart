import 'dart:developer';

import 'package:finobird/screens/dashboard/watchlist_companies.dart';
import 'package:finobird/constants/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../custom/browse_card_old.dart';
import '../../models/watchlist/get_watchlists.dart';
import 'add_company.dart';
import 'watchlist_feeds.dart';

class BrowseBy extends StatelessWidget {
  const BrowseBy({super.key, required this.watchlists});

  final List<Watchlists> watchlists;

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    // RxList<Watchlists> myWatchlists = [...watchlists].obs;
    RxList<Watchlists> searchResults = [...watchlists].obs;

    controller.addListener(() {
      searchResults.clear();
      for (var element in watchlists) {
        if (element.name!
            .toLowerCase()
            .contains(controller.text.toLowerCase())) {
          searchResults.add(element);
        }
      }
    });

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF4AB5E5),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Browse By',
            textScaleFactor: 1,
            style: Styles.text.copyWith(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                searchResults.sort((a, b) => a.name!.compareTo(b.name!));
                for (var element in searchResults) {
                  log(element.name!);
                }
              },
              icon: const Icon(LineIcons.sortAlphabeticalDown),
            ),
            IconButton(
              onPressed: () {
                searchResults.sort((a, b) => b.name!.compareTo(a.name!));
                for (var element in searchResults) {
                  log(element.name!);
                }
              },
              icon: const Icon(LineIcons.sortAlphabeticalUp),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                placeholder: "Search",
                style: Styles.text,
                controller: controller,
              ),
            ),
            searchResults.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BrowseCardOld(
                          title: searchResults[index].name ?? "",
                          ontap: () {
                            Get.to(
                              () => WatchlistCompanies(
                                id: searchResults[index].id!,
                                name: searchResults[index].name!,
                                companies: searchResults[index].companies!,
                              ),
                              transition: Transition.fadeIn,
                            );
                          },
                          id: watchlists[index].id!,
                          getWatchlistFeed: () {
                            List companyTickers = [];
                            for (var element
                                in searchResults[index].companies!) {
                              var map = {
                                "ticker": "${element.ticker}",
                              };
                              companyTickers.add(map);
                            }
                            Get.to(
                              () => WatchlistFeeds(
                                watchlistName: searchResults[index].name!,
                                watchlistId: searchResults[index].id!,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "No Watchlist Found",
                      style: Styles.text,
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF4AB5E5),
          onPressed: () {
            log("add button pressed");
            Get.to(() => const AddWatchlistCompany(
                  isFromWatchlist: false,
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
