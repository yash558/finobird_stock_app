class FeedVote {
  String? message;
  int? id;
  bool? positive;
  int? profileId;
  int? feedId;

  FeedVote({this.message, this.id, this.positive, this.profileId, this.feedId});

  FeedVote.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    positive = json['positive'];
    profileId = json['profileId'];
    feedId = json['feedId'];
  }



  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['message'] = message;
    data['id'] = id;
    data['positive'] = positive;
    data['profileId'] = profileId;
    data['feedId'] = feedId;
    return data;
  }
}
