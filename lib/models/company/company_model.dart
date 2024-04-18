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

  Company(
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

  Company.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
