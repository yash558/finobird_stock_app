class Count {
  int? members;

  Count({this.members});

  Count.fromJson(Map<String, dynamic> json) {
    members = json['members'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['members'] = members;
    return data;
  }
}

class Communities {
  int? id;
  String? chatId;
  String? name;
  String? description;
  String? avatarUrl;
  Count? cCount;
  double? regularmarketchangepercent;

  Communities({
    this.id,
    this.chatId,
    this.name,
    this.description,
    this.avatarUrl,
    this.cCount,
    this.regularmarketchangepercent,
  });

  Communities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    name = json['name'];
    description = json['description'];
    regularmarketchangepercent =
        json['company'] != null ? json['company']["regularMarketChangePercent"] : null;
    avatarUrl = json['avatarUrl'];
    cCount = json['_count'] != null ? Count.fromJson(json['_count']) : null;
  }

  get company => null;

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['chatId'] = chatId;
    data['name'] = name;
    data['description'] = description;
    data['avatarUrl'] = avatarUrl;
    if (cCount != null) {
      data['_count'] = cCount!.toJson();
    }
    return data;
  }
}
