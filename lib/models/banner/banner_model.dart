
import 'dart:convert';

List<BannerModel> bannerModelFromJson(String str) => List<BannerModel>.from(json.decode(str).map((x) => BannerModel.fromJson(x)));

String bannerModelToJson(List<BannerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class BannerModelList {
  final List<BannerModel>? states;

  BannerModelList({
    this.states,
  });

  factory BannerModelList.fromJson(List<dynamic> parsedJson) {
    List<BannerModel> states = [];
    states = parsedJson
        .map((i) => BannerModel.fromJson(i))
        .toList();
    return BannerModelList(
      states: states,
    );
  }
}


class BannerModel {
  int? id;
  String? image;
  String? link;
  String? description;
  DateTime? createdAt;
  dynamic expireAt;

  BannerModel({
    this.id,
    this.image,
    this.link,
    this.description,
    this.createdAt,
    this.expireAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    image: json["image"],
    link: json["link"],
    description: json["description"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    expireAt: json["expireAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "link": link,
    "description": description,
    "createdAt": createdAt?.toIso8601String(),
    "expireAt": expireAt,
  };
}
