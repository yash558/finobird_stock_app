import 'feed.dart';

class SearchFeed {
  List<Feed>? feed;
  int? nextToken;

  SearchFeed({this.feed, this.nextToken});

  SearchFeed.fromJson(Map<String, dynamic> json) {
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

class Company {
  int? id;
  String? name;
  String? ticker;
  String? exchange;
  String? website;
  String? sector;
  String? country;
  int? communityId;
  List<String>? aliasNames;
  List<String>? keywords;

  Company({
    this.id,
    this.name,
    this.ticker,
    this.exchange,
    this.website,
    this.sector,
    this.country,
    this.communityId,
    this.aliasNames,
    this.keywords,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ticker = json['ticker'];
    exchange = json['exchange'];
    website = json['website'];
    sector = json['sector'];
    country = json['country'];
    communityId = json['communityId'];
    aliasNames = json['aliasNames'].cast<String>();
    if (json['keywords'] != null) {
      keywords = <String>[];
      json['keywords'].forEach((v) {
        keywords!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ticker'] = ticker;
    data['exchange'] = exchange;
    data['website'] = website;
    data['sector'] = sector;
    data['country'] = country;
    data['communityId'] = communityId;
    data['aliasNames'] = aliasNames;
    if (keywords != null) {
      data['keywords'] = keywords!.map((v) => v).toList();
    }
    return data;
  }
}
