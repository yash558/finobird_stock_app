class SearchCompany {
  String? query;
  List<Result>? result;
  int? nextToken;

  SearchCompany({this.query, this.result, this.nextToken});

  SearchCompany.fromJson(Map<String, dynamic> json) {
    query = json['Query'];
    if (json['Result'] != null) {
      result = <Result>[];
      json['Result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['Query'] = query;
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}

class Result {
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
  Community? community;

  Result(
      {this.id,
      this.name,
      this.ticker,
      this.exchange,
      this.website,
      this.sector,
      this.country,
      this.communityId,
      this.aliasNames,
      this.keywords,
      this.community});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ticker = json['ticker'];
    exchange = json['exchange'];
    website = json['website'];
    sector = json['sector'];
    country = json['country'];
    communityId = json['communityId'];
    if (json['aliasNames'] != null) {
      aliasNames = <String>[];
      json['aliasNames'].forEach((v) {
        aliasNames!.add(v);
      });
    }
    if (json['keywords'] != null) {
      keywords = <String>[];
      json['keywords'].forEach((v) {
        keywords!.add(v);
      });
    }
    community = json['community'] != null
        ? Community.fromJson(json['community'])
        : null;
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
    if (aliasNames != null) {
      data['aliasNames'] = aliasNames!.map((v) => v).toList();
    }
    if (keywords != null) {
      data['keywords'] = keywords!.map((v) => v).toList();
    }
    if (community != null) {
      data['community'] = community!.toJson();
    }
    return data;
  }
}

class Community {
  int? id;
  String? chatId;
  String? name;
  String? description;
  String? avatarUrl;

  Community({
    this.id,
    this.chatId,
    this.name,
    this.description,
    this.avatarUrl,
  });

  Community.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    name = json['name'];
    description = json['description'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['chatId'] = chatId;
    data['name'] = name;
    data['description'] = description;
    data['avatarUrl'] = avatarUrl;
    return data;
  }
}
