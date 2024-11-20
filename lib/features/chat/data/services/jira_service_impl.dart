import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/data/models/jira_comment.dart';
import 'package:jira_project/features/chat/data/models/jira_issue.dart';
import 'package:jira_project/features/chat/data/models/jira_project.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jira_project/features/chat/data/services/jira_service.dart';

class JiraServiceImpl implements JiraService {
  final String API_KEY = dotenv.env['API_KEY']!;
  final String BASE_URL = dotenv.env['BASE_URL']!;
  final _storage = const FlutterSecureStorage();

  @override
  Future<List<JiraProject>> getJiraProjects() async {
    try {
      final String url = "$BASE_URL/project";
      final URIData = Uri.parse(url);
      final email = await _storage.read(key: 'email');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('${email}:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return projectsFromJson(response.body);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  @override
  Future<List<JiraIssue>> getIssuesByProject(String projectId) async {
    try {
      final String url =
          "$BASE_URL/search?jql=project=$projectId&maxResults=100";
      final URIData = Uri.parse(url);
      final email = await _storage.read(key: 'email');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return issuesFromJson(response.body);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  @override
  Future<List<JiraComment>> getCommentsByIssue(String issueId) async {
    try {
      final String url = "$BASE_URL/issue/$issueId/comment";
      final URIData = Uri.parse(url);
      final email = await _storage.read(key: 'email');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return commentsFromJson(response.body, issueId);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  @override
  Future<JiraComment> postCommentToIssue(String issueId, String text) async {
    try {
      final String url = "$BASE_URL/issue/$issueId/comment";
      final URIData = Uri.parse(url);
      final email = await _storage.read(key: 'email');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$email:$API_KEY'))}'
      };
      final response = await http.post(URIData,
          headers: requestHeaders, body: jsonEncode({'body': text}));
      return JiraComment.fromJson(jsonDecode(response.body), issueId);
    } catch (err) {
      throw ('Error: $err');
    }
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      final String url = "$BASE_URL/users/search";
      final URIData = Uri.parse(url);
      final email = await _storage.read(key: 'email');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$email:$API_KEY'))}'
      };
      final response = await http.get(URIData, headers: requestHeaders);
      return usersFromJson(response.body);
    } catch (err) {
      throw ('Error: $err');
    }
  }
}
