import 'package:finobird/models/feed/vote.dart';

import '../company/company_model.dart';

class Feed {
  int? id;
  String? title;
  String? content;
  DateTime? pubDate;
  String? link;
  String? source;
  String? image;
  int? companyId;
  String? guid;
  String? feedSource;
  num? regularMarketChangePercent;
  Company? company;
  List<FeedVote>? votes;

  Feed({
    this.id,
    this.title,
    this.content,
    this.pubDate,
    this.link,
    this.source,
    this.image,
    this.companyId,
    this.guid,
    this.feedSource,
    this.regularMarketChangePercent,
    this.company,
    this.votes,
  });

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    pubDate = json['pubDate'] != null ? DateTime.parse(json['pubDate']) : null;
    link = json['link'];
    source = json['source'];
    image = json['image'];
    companyId = json['companyId'];
    guid = json['guid'];
    feedSource = json['feedSource'];
    regularMarketChangePercent = json['regularMarketChangePercent'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    if (json['votes'] != null) {
      votes = [];
      json['votes'].forEach((v) {
        votes!.add(FeedVote.fromJson(v));
      });
    }
  }





  set unreadCount(int unreadCount) {}

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['pubDate'] = pubDate;
    data['link'] = link;
    data['source'] = source;
    data['image'] = image;
    data['companyId'] = companyId;
    data['guid'] = guid;
    data['feedSource'] = feedSource;
    data['regularMarketChangePercent'] = regularMarketChangePercent;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (votes != null) {
      data['votes'] = votes!.map((v) => v).toList();
    }
    return data;
  }
}
