import 'package:finobird/models/chat/communities.dart';

class SearchCommunities {
  List<Communities>? communities;
  int? nextToken;

  SearchCommunities({this.communities, this.nextToken});

  SearchCommunities.fromJson(Map<String, dynamic> json) {
    if (json['communities'] != null) {
      communities = <Communities>[];
      json['communities'].forEach((v) {
        communities!.add(Communities.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (communities != null) {
      data['communities'] = communities!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}
