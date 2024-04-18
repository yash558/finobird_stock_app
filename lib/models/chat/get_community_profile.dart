import '../company/company_model.dart';

class GetCommunityProfile {
  int? id;
  String? chatId;
  String? name;
  String? description;
  String? avatarUrl;
  Company? company;

  GetCommunityProfile(
      {this.id,
      this.chatId,
      this.name,
      this.description,
      this.avatarUrl,
      this.company});

  GetCommunityProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    name = json['name'];
    description = json['description'];
    avatarUrl = json['avatarUrl'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['chatId'] = chatId;
    data['name'] = name;
    data['description'] = description;
    data['avatarUrl'] = avatarUrl;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    return data;
  }
}
