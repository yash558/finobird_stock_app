class CreateWatchlist {
  int? id;
  String? name;
  int? userProfileId;
  List<Companies>? companies;

  CreateWatchlist({this.id, this.name, this.userProfileId, this.companies});

  CreateWatchlist.fromJson(Map<String, dynamic> json) {
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

  Companies({this.id, this.name, this.ticker, this.exchange, this.website});

  Companies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ticker = json['ticker'];
    exchange = json['exchange'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ticker'] = ticker;
    data['exchange'] = exchange;
    data['website'] = website;
    return data;
  }
}
