class GetCommunityMembers {
  int? id;
  String? name;
  String? description;
  String? avatarUrl;
  int? companyId;
  List<Members>? members;

  GetCommunityMembers({
    this.id,
    this.name,
    this.description,
    this.avatarUrl,
    this.companyId,
    this.members,
  });

  GetCommunityMembers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    avatarUrl = json['avatarUrl'];
    companyId = json['companyId'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['avatarUrl'] = avatarUrl;
    data['companyId'] = companyId;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? username;
  String? avatarUrl;
  String? role;

  Members({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.username,
    this.avatarUrl,
    this.role,
  });

  Members.fromJson(Map<String, dynamic> json) {
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
