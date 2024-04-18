class GetReplies {
  Message? message;
  int? nextToken;

  GetReplies({this.message, this.nextToken});

  GetReplies.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}

class Message {
  int? id;
  List<Content>? content;
  bool? isSystemMessage;
  int? senderId;
  int? likes;
  String? date;
  bool? isDM;
  String? communityId;
  String? inReplyToId;
  String? directChatId;
  Sender? sender;
  Community? community;
  List? reactions;
  List<Replies>? replies;
  Count? cCount;

  Message(
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
      this.community,
      this.reactions,
      this.replies,
      this.cCount});

  Message.fromJson(Map<String, dynamic> json) {
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
    community = json['community'] != null
        ? Community.fromJson(json['community'])
        : null;
    if (json['reactions'] != null) {
      reactions = [];
      json['reactions'].forEach((v) {
        reactions!.add(v);
      });
    }
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
    cCount = json['_count'] != null ? Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
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
    if (community != null) {
      data['community'] = community!.toJson();
    }
    if (reactions != null) {
      data['reactions'] = reactions!.map((v) => v.toJson()).toList();
    }
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    if (cCount != null) {
      data['_count'] = cCount!.toJson();
    }
    return data;
  }
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
    Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['type'] = type;
    return data;
  }
}

class Community {
  int? id;
  String? chatId;
  String? name;
  String? description;
  String? avatarUrl;

  Community(
      {this.id, this.chatId, this.name, this.description, this.avatarUrl});

  Community.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    name = json['name'];
    description = json['description'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chatId'] = chatId;
    data['name'] = name;
    data['description'] = description;
    data['avatarUrl'] = avatarUrl;
    return data;
  }
}

class Replies {
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
  Count? cCount;

  Replies(
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
      this.cCount});

  Replies.fromJson(Map<String, dynamic> json) {
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
    cCount = json['_count'] != null ? Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
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
    if (cCount != null) {
      data['_count'] = cCount!.toJson();
    }
    return data;
  }
}

class Sender {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? username;
  String? avatarUrl;
  String? role;

  Sender(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.username,
      this.avatarUrl,
      this.role});

  Sender.fromJson(Map<String, dynamic> json) {
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
    Map<String, dynamic> data = <String, dynamic>{};
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
    Map<String, dynamic> data = <String, dynamic>{};
    data['replies'] = replies;
    data['reactions'] = reactions;
    data['MessageReport'] = messageReport;
    return data;
  }
}
