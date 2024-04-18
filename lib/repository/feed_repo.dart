// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';

import 'package:finobird/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feed/corporate_announcements.dart';
import '../models/feed/feed.dart';
import '../models/feed/search_feed.dart';
import '../models/feed/vote.dart';
import 'authentication.dart';
import 'constants.dart';

enum FilterOption {
  news,
  youtube,
  twitter,
}

class FeedRepo extends GetxController {
  var baseUrl = "${Constants.baseUrl}/api/v1/feed";
  Rx<SearchFeed> searchResults = SearchFeed().obs; // more than 2
  Rx<CorporateAnnouncements> announcements = CorporateAnnouncements().obs;

  RxString startDate = DateFormat("yyyy-MM-dd")
      .format(DateTime.now().subtract(const Duration(days: 7)))
      .obs;
  RxString endDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  int? nextToken;
  bool moreRunning = false;
  bool filtered = false;
  ValueNotifier<List<Feed>> feedList = ValueNotifier([]);
  ValueNotifier<bool> fetchingFeeds = ValueNotifier(true);
  ValueNotifier<bool> fetchingMoreFeeds = ValueNotifier(false);
  ValueNotifier<bool> feedUpdate = ValueNotifier(false);
  ValueNotifier<List<FilterOption>> filterNode = ValueNotifier([
    FilterOption.news,
    FilterOption.youtube,
    FilterOption.twitter,
  ]);

  List<String> createFeedSource() {
    List<String> feedSource = [];
    if (filterNode.value.contains(FilterOption.news)) {
      feedSource.add("NEWS");
    }
    if (filterNode.value.contains(FilterOption.youtube)) {
      feedSource.add("YOUTUBE");
    }
    if (filterNode.value.contains(FilterOption.twitter)) {
      feedSource.add("TWITTER");
    }
    return feedSource;
  }

  void resetFilter({bool apiCall = true}) {
    filterNode.value = [
      FilterOption.news,
      FilterOption.youtube,
      FilterOption.twitter,
    ];
    startDate.value = DateFormat("yyyy-MM-dd")
        .format(DateTime.now().subtract(const Duration(days: 7)));
    endDate.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
    filtered = false;
    if (apiCall) {
      filterFeeds(more: false);
    }
  }

  Future<void> filterFeeds({required bool more}) async {
    if (filterNode.value.length == 3 &&
        startDate.value == "" &&
        endDate.value == "") {
      resetFilter();
    } else {
      filtered = true;
      if (more && fetchingMoreFeeds.value) {
        return;
      }
      if (more && nextToken == null) {
        return;
      }
      if (more) {
        fetchingMoreFeeds.value = true;
      } else {
        fetchingFeeds.value = true;
      }
      var request = http.Request('GET', Uri.parse("$baseUrl/search"));
      request.body = jsonEncode({
        "query": "",
        "limit": 20,
        "filters": {
          "feedSource": createFeedSource(),
          if (startDate.value != "") "minDateTime": startDate.value,
          if (endDate.value != "") "maxDateTime": endDate.value,
        },
        if (more) "startToken": nextToken,
      });
      log("request body: ${request.body}");
      request.headers.addAll({
        "Authorization": "Bearer ${accessToken.value}",
        "Content-Type": "application/json",
      });
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        log(data);
        var finalData = jsonDecode(data);
        if (finalData["feed"] != null) {
          List<Feed> childList =
              (finalData["feed"] as List).map((e) => Feed.fromJson(e)).toList();
          if (childList.isNotEmpty) {
            childList.sort((a, b) => b.pubDate!.compareTo(a.pubDate!));
          }
          if (more) {
            feedList.value.addAll(childList);
            feedUpdate.value = !feedUpdate.value;
          } else {
            feedList.value = childList;
            feedUpdate.value = !feedUpdate.value;
          }
        }
        nextToken = finalData["nextToken"];
      } else {
        log("Status Code :::: ${response.statusCode}  ::::: ${response.reasonPhrase.toString()}");
      }
      if (more) {
        fetchingMoreFeeds.value = false;
      } else {
        fetchingFeeds.value = false;
      }
    }
  }

  Future<List<Feed>> fetchWatchlistFeed(int watchlistId, int limit) async {
    try {
      var request = http.Request('GET', Uri.parse("$baseUrl/search"));
      request.body = jsonEncode({
        "query": "",
        "limit": limit,
        "filters": {
          "watchlists": [watchlistId]
        }
      });
      request.headers.addAll({
        "Authorization": "Bearer ${accessToken.value}",
        "Content-Type": "application/json"
      });
      print(
          "=====>  REQUEST :::::\nURL:==> ${request.url}\nBody:==> ${request.body}");
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        log(data);
        var finalData = jsonDecode(data);
        // if (changeStartPage != null) {
        //   changeStartPage(finalData["nextToken"]);
        // }
        if (finalData.isNotEmpty) {
          print(finalData);
          if (finalData["feed"] != null) {
            var childList = (finalData["feed"] as List)
                .map((e) => Feed.fromJson(e))
                .toList();

            if (childList.isNotEmpty) {
              childList.sort((a, b) => b.pubDate!.compareTo(a.pubDate!));

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('watch_${watchlistId}_lastfeedid',
                  childList[childList.length - 1].id ?? -1);
            }
            
            return childList;
          } else {
            return [];
          }
        } else {
          return [];
        }
      } else {
        log("Status Code :::: ${response.statusCode}  ::::: ${response.reasonPhrase.toString()}");
        return [];
      }
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Feed>> feedSearch({
    required String query,
    required int limit,
    required Map filtersMap,
    int? startPage,
    Function? changeStartPage,
  }) async {
    var request = http.Request('GET', Uri.parse("$baseUrl/search"));
    request.body = jsonEncode({
      "query": query,
      "limit": limit,
      "filters": filtersMap,
      if (startPage != null) "startToken": startPage,
    });
    log("request body: ${request.body}");
    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      "Content-Type": "application/json",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      var finalData = jsonDecode(data);
      if (changeStartPage != null) {
        changeStartPage(finalData["nextToken"]);
      }
      if (finalData["feed"] != null) {
        var childList =
            (finalData["feed"] as List).map((e) => Feed.fromJson(e)).toList();
        if (childList.isNotEmpty) {
          childList.sort((a, b) => b.pubDate!.compareTo(a.pubDate!));
        }
        return childList;
      } else {
        return [];
      }
    } else {
      log("Status Code :::: ${response.statusCode}  ::::: ${response.reasonPhrase.toString()}");
      return [];
    }
  }

  Future<void> getAnnouncements() async {
    var request =
        http.Request('GET', Uri.parse("$baseUrl/corporate-announcements"));
    request.body = jsonEncode({
      "startDate": "2023-04-24",
      "endDate": "2023-04-25",
      "segment": "C",
      "category": "Company Update"
    });

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      "Content-Type": "application/json",
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      log(data);
      var finalData = jsonDecode(data);
      announcements.value = CorporateAnnouncements.fromJson(
        finalData,
      );
      log(searchResults.value.feed!.length.toString());
      update();
      notifyChildrens();
    } else {
      log("=======>   ${response.statusCode}");
      log(response.reasonPhrase.toString());
    }
  }

  upvoteDownvoteFeed(
    bool isUpvote,
    int feedId,
    Function feedVoteChange,
    Function refresh,
  ) async {
    var request = http.Request('POST', Uri.parse("$baseUrl/$feedId/vote"));
    log("request $request");
    request.body = jsonEncode({"positive": isUpvote});
    log("object isUpvote $isUpvote");
    log("object isUpvote ${request.body}");

    request.headers.addAll({
      "Authorization": "Bearer ${accessToken.value}",
      "Content-Type": "application/json",
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      // log(data);
      var finalData = jsonDecode(data);
      FeedVote feedVote = FeedVote.fromJson(
        finalData,
      );
      feedVoteChange(feedVote, isUpvote, refresh);
    } else {
      log(response.reasonPhrase.toString());
    }
  }

  upDownvoteFeed(
    bool isUpvote,
    int feedId,
    int index,
    UserRepo user,
  ) async {
    try {
      var request = http.Request('POST', Uri.parse("$baseUrl/$feedId/vote"));
      request.body = jsonEncode({"positive": isUpvote});
      request.headers.addAll({
        "Authorization": "Bearer ${accessToken.value}",
        "Content-Type": "application/json",
      });
      log("===>  Body ::::  ${request.body}");
      http.StreamedResponse response = await request.send();
      log("===>  Response ::::  ${response.statusCode}");
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        // log(data);
        var finalData = jsonDecode(data);
        FeedVote feedVote = FeedVote.fromJson(
          finalData,
        );
        if (feedVote.profileId != null) {
          int voteIndex = feedList.value[index].votes!.indexWhere(
            (element) => element.profileId == feedVote.profileId,
          );
          if (voteIndex != -1) {
            feedList.value[index].votes!.removeAt(voteIndex);
            feedList.value[index].votes!.add(feedVote);
          } else {
            feedList.value[index].votes!.add(feedVote);
          }
        } else {
          int anotherIndex = feedList.value[index].votes!.indexWhere(
            (element) => element.profileId == user.profile.value.id,
          );
          if (anotherIndex != -1) {
            feedList.value[index].votes!.removeAt(anotherIndex);
          }
        }
        feedList.notifyListeners();
      } else {
        log(response.reasonPhrase.toString());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}

  // Future<void> fetchFeeds(bool more) async {
  //   if (more && fetchingMoreFeeds.value) {
  //     return;
  //   }
  //   if (more && nextToken == null) {
  //     return;
  //   }
  //   if (more) {
  //     fetchingMoreFeeds.value = true;
  //   } else {
  //     fetchingFeeds.value = true;
  //   }
  //   try {
  //     log("Start");
  //     var request = http.Request('GET', Uri.parse(baseUrl));
  //     request.headers.addAll({
  //       "Authorization": "Bearer ${accessToken.value}",
  //       'Content-Type': 'application/json',
  //     });
  //     request.body = jsonEncode({
  //       "limit": 20,
  //       if (more) "startToken": nextToken,
  //     });
  //     log("Body :: ${request.body}");
  //     http.StreamedResponse response = await request.send();
  //     log("End ::::  ${response.statusCode}");
  //     if (response.statusCode == 200) {
  //       var data = await response.stream.bytesToString();
  //       // log(data);
  //       var finalData = jsonDecode(data)[0];
  //       if (finalData["feed"] != null) {
  //         List<Feed> childList =
  //             (finalData["feed"] as List).map((e) => Feed.fromJson(e)).toList();
  //         if (more) {
  //           feedList.value.addAll(childList);
  //           feedUpdate.value = !feedUpdate.value;
  //         } else {
  //           feedList.value = childList;
  //           feedUpdate.value = !feedUpdate.value;
  //         }
  //       }
  //       nextToken = finalData["nextToken"];
  //     } else {
  //       log(response.reasonPhrase.toString());
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  //   if (more) {
  //     fetchingMoreFeeds.value = false;
  //   } else {
  //     fetchingFeeds.value = false;
  //   }
  // }
