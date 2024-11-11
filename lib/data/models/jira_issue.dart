import 'dart:convert';

List<JiraIssue> issuesFromJson(String jsonString) {
  try {
    return jsonDecode(jsonString)['issues']
        .map<JiraIssue>((issue) => JiraIssue.fromJson(issue))
        .toList();
  } catch (e) {
    return [];
  }
}

class JiraIssue {
  final String id;
  final String key;
  final String? description;
  final String summary;
  final String projectId;

  JiraIssue(
      {required this.id,
      required this.key,
      this.description = '',
      required this.summary,
      required this.projectId});

  factory JiraIssue.fromJson(Map<String, dynamic> json) {
    return JiraIssue(
        id: json['id'],
        key: json['key'],
        description: json['fields']['description'],
        summary: json['fields']['summary'],
        projectId: json['fields']['project']['id']);
  }

  JiraIssue copyWith(
      {String? id,
      String? key,
      String? description,
      String? summary,
      String? projectId}) {
    return JiraIssue(
        id: id ?? this.id,
        key: key ?? this.key,
        description: description ?? this.description,
        summary: summary ?? this.summary,
        projectId: projectId ?? this.projectId);
  }
}
