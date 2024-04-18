// To parse this JSON data, do
//
//     final chatNotificationModel = chatNotificationModelFromJson(jsonString);

import 'dart:convert';

ChatNotificationModel chatNotificationModelFromJson(String str) => ChatNotificationModel.fromJson(json.decode(str));

String chatNotificationModelToJson(ChatNotificationModel data) => json.encode(data.toJson());

class ChatNotificationModel {
  Chat? chat;
  String? contentPreview;
  String? type;

  ChatNotificationModel({
    this.chat,
    this.contentPreview,
    this.type,
  });

  factory ChatNotificationModel.fromJson(Map<String, dynamic> json) => ChatNotificationModel(
    chat: json["chat"] == null ? null : Chat.fromJson(jsonDecode(json["chat"])),
    contentPreview: json["contentPreview"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "chat": chat?.toJson(),
    "contentPreview": contentPreview,
    "type": type,
  };
}

class Chat {
  String? date;
  int? senderId;
  bool? isDm;
  dynamic directChatId;
  Sender? sender;
  bool? isSystemMessage;
  int? id;
  String? communityId;
  List<Content>? content;
  int? likes;
  int? inReplyToId;

  Chat({
    this.date,
    this.senderId,
    this.isDm,
    this.directChatId,
    this.sender,
    this.isSystemMessage,
    this.id,
    this.communityId,
    this.content,
    this.likes,
    this.inReplyToId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    date: json["date"],
    senderId: json["senderId"],
    isDm: json["isDM"],
    directChatId: json["directChatId"],
    sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
    isSystemMessage: json["isSystemMessage"],
    id: json["id"],
    communityId: json["communityId"],
    content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
    likes: json["likes"],
    inReplyToId: json["inReplyToId"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "senderId": senderId,
    "isDM": isDm,
    "directChatId": directChatId,
    "sender": sender?.toJson(),
    "isSystemMessage": isSystemMessage,
    "id": id,
    "communityId": communityId,
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
    "likes": likes,
    "inReplyToId": inReplyToId,
  };
}

class Content {
  String? text;
  String? type;

  Content({
    this.text,
    this.type,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    text: json["text"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "type": type,
  };
}

class Sender {
  String? firstName;
  String? lastName;
  String? avatarUrl;
  String? username;

  Sender({
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.username,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    firstName: json["firstName"],
    lastName: json["lastName"],
    avatarUrl: json["avatarUrl"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "avatarUrl": avatarUrl,
    "username": username,
  };
}


//========================================Feed notification


FeedNotificationModel feedNotificationModelFromJson(String str) => FeedNotificationModel.fromJson(json.decode(str));

String feedNotificationModelToJson(FeedNotificationModel data) => json.encode(data.toJson());

class FeedNotificationModel {
  Feed? feed;
  String? contentPreview;
  String? type;

  FeedNotificationModel({
    this.feed,
    this.contentPreview,
    this.type,
  });

  factory FeedNotificationModel.fromJson(Map<String, dynamic> json) => FeedNotificationModel(
    feed: json["feed"] == null ? null : Feed.fromJson(jsonDecode(json["feed"])),
    contentPreview: json["contentPreview"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "feed": feed?.toJson(),
    "contentPreview": contentPreview,
    "type": type,
  };
}

class Feed {
  dynamic companyTicker;
  int? updatesCount;
  int? feedStartToken;

  Feed({
    this.companyTicker,
    this.updatesCount,
    this.feedStartToken,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    companyTicker: json["companyTicker"],
    updatesCount: json["updatesCount"],
    feedStartToken: json["feedStartToken"],
  );

  Map<String, dynamic> toJson() => {
    "companyTicker": companyTicker,
    "updatesCount": updatesCount,
    "feedStartToken": feedStartToken,
  };
}
