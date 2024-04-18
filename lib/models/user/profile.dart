class UserProfile {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? username;
  String? avatarUrl;
  String? role;

  UserProfile({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.username,
    this.avatarUrl,
    this.role,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
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
