import 'feed.dart';

class FetchFeed {
  List<Feed>? feed;
  int? nextToken;

  FetchFeed({this.feed, this.nextToken});

  FetchFeed.fromJson(Map<String, dynamic> json) {
    if (json['feed'] != null) {
      feed = <Feed>[];
      json['feed'].forEach((v) {
        feed!.add(Feed.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (feed != null) {
      data['feed'] = feed!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}
