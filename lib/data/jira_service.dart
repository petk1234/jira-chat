import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jira_project/data/models/jira_comment.dart';
import 'package:jira_project/data/models/jira_issue.dart';
import 'package:jira_project/data/models/jira_project.dart';
import 'package:jira_project/data/models/user.dart';

class JiraService {
  final String API_KEY = dotenv.env['API_KEY']!;
  final String BASE_URL = "https://petkun8034.atlassian.net/rest/api/2";
  String? _email;

  Future<User?> loginToJira(String email) async {
    try {
      final String url = "$BASE_URL/user/search?query=$email";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        _email = email;
        final User user = User.fromJson(jsonDecode(response.body)[0]);
        return user;
      } else {
        throw ('User not found');
      }
    } catch (err) {
      throw ('Login Error: $err');
    }
  }

  Future<List<JiraProject>> getJiraProjects({String? email}) async {
    try {
      final String url = "$BASE_URL/project";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('${email ?? _email}:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      _email = _email ?? email;
      return projectsFromJson(response.body);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  Future<List<JiraIssue>> getIssuesByProject(String projectId) async {
    try {
      final String url =
          "$BASE_URL/search?jql=project=$projectId&maxResults=100";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$_email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return issuesFromJson(response.body);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  Future<List<JiraComment>> getCommentsByIssue(String issueId) async {
    try {
      final String url = "$BASE_URL/issue/$issueId/comment";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$_email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return commentsFromJson(response.body, issueId);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  Future<JiraComment> postCommentToIssue(String issueId, String text) async {
    try {
      final String url = "$BASE_URL/issue/$issueId/comment";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$_email:$API_KEY'))}'
      };
      final response = await http.post(URIData,
          headers: requestHeaders, body: jsonEncode({'body': text}));
      return JiraComment.fromJson(jsonDecode(response.body), issueId);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final String url = "$BASE_URL/users/search";
      final URIData = Uri.parse(url);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$_email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return usersFromJson(response.body);
    } catch (err) {
      throw ('Error: $err');
    }
  }
}
