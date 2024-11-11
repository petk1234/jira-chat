import 'dart:convert';

import 'package:jira_project/data/models/user.dart';

List<JiraComment> commentsFromJson(String jsonString, String issueId) {
  try{
  return jsonDecode(jsonString)['comments']
      .map<JiraComment>((comment) => JiraComment.fromJson(comment, issueId))
      .toList();
  } catch (e) {
    return [];
  }
}

class JiraComment {
  final String id;
  final User author;
  final String body;
  final String link;
  final DateTime createdAt;
  final String issueId;

  JiraComment(
      {required this.id,
      required this.author,
      required this.body,
      required this.link,
      required this.createdAt,
      required this.issueId});

  factory JiraComment.fromJson(Map<String, dynamic> json, String issueId) {
    print('Separate comment: $json');
    print('USER AUTHOR ${json['author']}');
    print(json['body']);
    print(json['self']);
    print(json['created']);
    print(issueId);
    return JiraComment(
        id: json['id'],
        author: User.fromJson(json['author']),
        body: json['body'],
        link: json['self'],
        createdAt: DateTime.parse(json['created']),
        issueId: issueId);
  }

  JiraComment copyWith(
      {String? id,
      User? author,
      String? body,
      String? link,
      DateTime? createdAt,
      String? issueId}) {
    return JiraComment(
        id: id ?? this.id,
        author: author ?? this.author.copyWith(),
        body: body ?? this.body,
        link: link ?? this.link,
        createdAt: createdAt ?? this.createdAt,
        issueId: issueId ?? this.issueId);
  }
}
