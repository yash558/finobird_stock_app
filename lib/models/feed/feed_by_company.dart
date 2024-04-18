class FeedByCompany {
  String? companyName;
  String? companyTicker;
  List<Feed>? feed;
  int? nextToken;

  FeedByCompany(
      {this.companyName, this.companyTicker, this.feed, this.nextToken});

  FeedByCompany.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    companyTicker = json['companyTicker'];
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
    data['companyName'] = companyName;
    data['companyTicker'] = companyTicker;
    if (feed != null) {
      data['feed'] = feed!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}

class Feed {
  int? id;
  String? title;
  String? content;
  String? pubDate;
  String? link;
  String? source;
  String? image;
  int? companyId;
  String? guid;
  String? feedSource;
  double? regularMarketChangePercent;
  Company? company;

  Feed(
      {this.id,
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
      this.company});

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    pubDate = json['pubDate'];
    link = json['link'];
    source = json['source'];
    image = json['image'];
    companyId = json['companyId'];
    guid = json['guid'];
    feedSource = json['feedSource'];
    regularMarketChangePercent = json['regularMarketChangePercent'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
  }

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

  Company(
      {this.id,
      this.name,
      this.ticker,
      this.exchange,
      this.website,
      this.sector,
      this.country});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ticker = json['ticker'];
    exchange = json['exchange'];
    website = json['website'];
    sector = json['sector'];
    country = json['country'];
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
    return data;
  }
}
