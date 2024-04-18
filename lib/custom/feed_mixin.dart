import 'dart:developer';

import 'package:get/get.dart';

import '../repository/feed_repo.dart';
import '../repository/user_repo.dart';

mixin FeedMixin {
  var feedController = Get.put(FeedRepo());
  var user = Get.put(UserRepo());
  RxBool isUpvote = false.obs, voteAvailable = false.obs;
  String? shareText;

  getFeedData(feed) {
    user.getUserProfile();
    shareText =
        "${feed.title}\n${feed.link}\n\nGet latest news and trends about your favourite companies using the Finobird app.";

    var votes = feed.votes;
    for (var vote in votes!) {
      if (vote.profileId == user.profile.value.id) {
        log("got id");
        isUpvote.value = vote.positive ?? false;
        voteAvailable.value = true;
      }
    }

    log(isUpvote.value.toString());
    log(voteAvailable.value.toString());
  }
}
