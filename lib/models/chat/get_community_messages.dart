class GetCommunityMessages {
  List<Messages>? messages;
  String? chatId;
  int? nextToken;

  GetCommunityMessages({this.messages, this.chatId, this.nextToken});

  GetCommunityMessages.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    chatId = json['chatId'];
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['chatId'] = chatId;
    data['nextToken'] = nextToken;
    return data;
  }
}

class Messages {
  int? id;
  List<Content>? content;
  bool? isSystemMessage;
  int? senderId;
  int? likes;
  String? date;
  bool? isDM;
  String? communityId;
  int? inReplyToId;
  String? directChatId;
  Sender? sender;
  InReplyTo? inReplyTo;
  List<ReactionModel>? reactions;
  Count? cCount;
  bool isReaction = false;

  Messages(
      {this.id,
      this.content,
      this.isSystemMessage,
      this.senderId,
      this.likes,
      this.date,
      this.isDM,
      this.communityId,
      this.inReplyToId,
      this.directChatId,
      this.sender,
      this.inReplyTo,
      this.reactions,
      this.cCount,this.isReaction=false});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
    isSystemMessage = json['isSystemMessage'];
    senderId = json['senderId'];
    likes = json['likes'];
    date = json['date'];
    isDM = json['isDM'];
    communityId = json['communityId'];
    inReplyToId = json['inReplyToId'];
    directChatId = json['directChatId'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    inReplyTo = json['inReplyTo'] != null
        ? InReplyTo.fromJson(json['inReplyTo'])
        : null;
    if (json['reactions'] != null) {
      reactions = <ReactionModel>[];
      json['reactions'].forEach((v) {
        reactions!.add(ReactionModel.fromJson(v));
      });
    }

    cCount = json['_count'] != null ? Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['isSystemMessage'] = isSystemMessage;
    data['senderId'] = senderId;
    data['likes'] = likes;
    data['date'] = date;
    data['isDM'] = isDM;
    data['communityId'] = communityId;
    data['inReplyToId'] = inReplyToId;
    data['directChatId'] = directChatId;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (inReplyTo != null) {
      data['inReplyTo'] = inReplyTo!.toJson();
    }
    if (reactions != null) {
      data['reactions'] = reactions!.map((v) => v.toJson()).toList();
    }
    if (cCount != null) {
      data['_count'] = cCount!.toJson();
    }
    return data;
  }
}


class ReactionModel {
  int? id;
  String? emoji;
  int? profileId;
  int? messageId;

  ReactionModel({
    this.id,
    this.emoji,
    this.profileId,
    this.messageId,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) => ReactionModel(
    id: json["id"],
    emoji: json["emoji"],
    profileId: json["profileId"],
    messageId: json["messageId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "emoji": emoji,
    "profileId": profileId,
    "messageId": messageId,
  };
}


class Content {
  String? text;
  String? type;

  Content({this.text, this.type});

  Content.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['text'] = text;
    data['type'] = type;
    return data;
  }
}

class Sender {
  String? firstName;
  String? lastName;
  String? username;
  String? avatarUrl;

  Sender({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.avatarUrl,
  });

  Sender.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'] ?? "";
    lastName = json['lastName'] ?? "";
    username = json['username'] ?? "";
    avatarUrl = json['avatarUrl'] ?? "";
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['username'] = username;
    data['avatarUrl'] = avatarUrl;
    return data;
  }
}

class InReplyTo {
  int? id;
  List<Content>? content;
  bool? isSystemMessage;
  int? senderId;
  int? likes;
  String? date;
  bool? isDM;
  String? communityId;
  int? inReplyToId;
  String? directChatId;

  InReplyTo({
    this.id,
    this.content,
    this.isSystemMessage,
    this.senderId,
    this.likes,
    this.date,
    this.isDM,
    this.communityId,
    this.inReplyToId,
    this.directChatId,
  });

  InReplyTo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
    isSystemMessage = json['isSystemMessage'];
    senderId = json['senderId'];
    likes = json['likes'];
    date = json['date'];
    isDM = json['isDM'];
    communityId = json['communityId'];
    inReplyToId = json['inReplyToId'];
    directChatId = json['directChatId'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    data['isSystemMessage'] = isSystemMessage;
    data['senderId'] = senderId;
    data['likes'] = likes;
    data['date'] = date;
    data['isDM'] = isDM;
    data['communityId'] = communityId;
    data['inReplyToId'] = inReplyToId;
    data['directChatId'] = directChatId;
    return data;
  }
}

class Count {
  int? replies;
  int? reactions;
  int? messageReport;

  Count({this.replies, this.reactions, this.messageReport});

  Count.fromJson(Map<String, dynamic> json) {
    replies = json['replies'];
    reactions = json['reactions'];
    messageReport = json['MessageReport'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['replies'] = replies;
    data['reactions'] = reactions;
    data['MessageReport'] = messageReport;
    return data;
  }
}
