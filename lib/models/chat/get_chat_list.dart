class GetChatLists {
  Communities? communities;
  DirectChats? directChats;

  GetChatLists({this.communities, this.directChats});

  GetChatLists.fromJson(Map<String, dynamic> json) {
    communities = json['communities'] != null
        ? Communities.fromJson(json['communities'])
        : null;
    directChats = json['directChats'] != null
        ? DirectChats.fromJson(json['directChats'])
        : null;
  } 

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (communities != null) {
      data['communities'] = communities!.toJson();
    }
    if (directChats != null) {
      data['directChats'] = directChats!.toJson();
    }
    return data;
  }
}

class Communities {
  List<Chats>? chats;
  int? nextToken;

  Communities({this.chats, this.nextToken});

  Communities.fromJson(Map<String, dynamic> json) {
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(Chats.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}

class Chats {
  int? id;
  String? chatId;
  String? name;
  String? description;
  String? avatarUrl;
  int? companyId;

  Chats(
      {this.id,
      this.chatId,
      this.name,
      this.description,
      this.avatarUrl,
      this.companyId});

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatId = json['chatId'];
    name = json['name'];
    description = json['description'];
    avatarUrl = json['avatarUrl'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['chatId'] = chatId;
    data['name'] = name;
    data['description'] = description;
    data['avatarUrl'] = avatarUrl;
    data['companyId'] = companyId;
    return data;
  }
}

class DirectChats {
  List<Chats>? chats;
  int? nextToken;

  DirectChats({this.chats, this.nextToken});

  DirectChats.fromJson(Map<String, dynamic> json) {
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(Chats.fromJson(v));
      });
    }
    nextToken = json['nextToken'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    data['nextToken'] = nextToken;
    return data;
  }
}
