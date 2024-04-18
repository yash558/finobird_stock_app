import 'package:finobird/models/chat/communities.dart';

class FetchCommunities {
  List<Communities> communities;
  int? nextToken;

  FetchCommunities({required this.communities, this.nextToken});

  factory FetchCommunities.fromJson(Map<String, dynamic> json) =>
      FetchCommunities(
        communities:
            (json['communities'] != null && json['communities'] is List)
                ? (json['communities'] as List)
                    .map(
                      (e) => Communities.fromJson(e),
                    )
                    .toList()
                : [],
        nextToken: json['nextToken'],
      );

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['communities'] = communities.map((v) => v.toJson()).toList();
    data['nextToken'] = nextToken;
    return data;
  }
}
