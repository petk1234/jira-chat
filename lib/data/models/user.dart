import 'dart:convert';

List<User> usersFromJson(String jsonString) {
  return jsonDecode(jsonString)
      .map<User>((user) => User.fromJson(user))
      .toList();
}

class User {
  String userId;
  String displayName;
  String? emailAddress;
  User({required this.userId, required this.displayName, this.emailAddress});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userId: json['accountId'],
      displayName: json['displayName'],
      emailAddress: json['emailAddress']);

  User copyWith({String? userId, String? displayName, String? emailAddress}) {
    return User(
        userId: userId ?? this.userId,
        displayName: displayName ?? this.displayName,
        emailAddress: emailAddress ?? this.emailAddress);
  }
}
