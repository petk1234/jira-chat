import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/data/models/jira_comment.dart';
import 'package:jira_project/features/chat/data/models/jira_issue.dart';
import 'package:jira_project/features/chat/data/models/jira_project.dart';

abstract class JiraService{
  Future<List<JiraProject>> getJiraProjects();
  Future<List<JiraIssue>> getIssuesByProject(String projectId);
  Future<List<JiraComment>> getCommentsByIssue(String issueId);
  Future<JiraComment> postCommentToIssue(String issueId, String text);
  Future<List<User>> getUsers();
}