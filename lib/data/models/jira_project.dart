import 'dart:convert';

List<JiraProject> projectsFromJson(String jsonStr) {
  try{
    return jsonDecode(jsonStr)
        .map<JiraProject>((jsonProject) => JiraProject.fromJson(jsonProject))
        .toList();
  } catch (e) {
    return [];
  }
}

class JiraProject {
  final String id;
  final String name;
  final String key;

  JiraProject({required this.id, required this.name, required this.key});

  factory JiraProject.fromJson(Map<String, dynamic> json) {
    return JiraProject(id: json['id'], name: json['name'], key: json['key']);
  }

  JiraProject copyWith({String? id, String? name, String? key}) {
    return JiraProject(
        id: id ?? this.id, name: name ?? this.name, key: key ?? this.key);
  }
}
