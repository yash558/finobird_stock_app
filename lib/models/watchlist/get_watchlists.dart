class GetWatchlists {
  List<Watchlists> watchlists;
  int? nextToken;

  GetWatchlists({required this.watchlists, this.nextToken});

  factory GetWatchlists.fromJson(Map<String, dynamic> json) => GetWatchlists(
        watchlists: (json['watchlists'] != null && json['watchlists'] is List)
            ? (json['watchlists'] as List)
                .map(
                  (e) => Watchlists.fromJson(e),
                )
                .toList()
            : [],
        nextToken: json['nextToken'],
      );

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['watchlists'] = watchlists.map((v) => v.toJson()).toList();
    data['nextToken'] = nextToken;
    return data;
  }
}

class Watchlists {
  int? id;
  String? name;
  int? userProfileId;
  List<Companies>? companies;

  Watchlists({this.id, this.name, this.userProfileId, this.companies});

  Watchlists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userProfileId = json['userProfileId'];
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(Companies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userProfileId'] = userProfileId;
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Companies {
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

  Companies(
      {this.id,
      this.name,
      this.ticker,
      this.exchange,
      this.website,
      this.sector,
      this.country,
      this.communityId,
      this.aliasNames,
      this.keywords});

  Companies.fromJson(Map<String, dynamic> json) {
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
