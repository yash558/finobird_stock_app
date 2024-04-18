// ignore_for_file: void_checks

class GetWatchlistById {
  int? id;
  String? name;
  int? userProfileId;
  List<Companies>? companies;
  UserProfile? userProfile;

  GetWatchlistById(
      {this.id,
      this.name,
      this.userProfileId,
      this.companies,
      this.userProfile});

  GetWatchlistById.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userProfileId = json['userProfileId'];
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(Companies.fromJson(v));
      });
    }
    userProfile = json['userProfile'] != null
        ? UserProfile.fromJson(json['userProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userProfileId'] = userProfileId;
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    if (userProfile != null) {
      data['userProfile'] = userProfile!.toJson();
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

class UserProfile {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? username;
  String? avatarUrl;
  String? role;

  UserProfile(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.username,
      this.avatarUrl,
      this.role});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    username = json['username'];
    avatarUrl = json['avatarUrl'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['username'] = username;
    data['avatarUrl'] = avatarUrl;
    data['role'] = role;
    return data;
  }
}
