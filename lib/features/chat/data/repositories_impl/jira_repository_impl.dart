import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/data/services/jira_service.dart';
import 'package:jira_project/features/chat/data/models/jira_comment.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:collection/collection.dart';
import 'package:jira_project/features/chat/domain/repository/jira_repository.dart';

class JiraRepositoryImpl extends JiraRepository{
  final JiraService jiraService;
  JiraRepositoryImpl({required this.jiraService});

  List<T> _expandList<T>(List<List<T>> nestedList) {
    return nestedList.expand((element) => element).toList();
  }

  @override
  Future<List<ChatComment>?> prepareChatComments(
      {String? email, required List<User> users}) async {
    try {
      final projects = await jiraService.getJiraProjects();
      final issues = await Future.wait(projects.map((projectInfo) {
        final projectName = projectInfo.name;
        return jiraService.getIssuesByProject(projectName);
      })).then((res) => _expandList(res));

      final comments = await Future.wait(issues.map((issue) {
        final issueId = issue.id;
        return jiraService.getCommentsByIssue(issueId);
      }).toList())
          .then((res) => _expandList(res));

      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final transformedData = comments.map((comment) {
        final issue = issues.firstWhere((issue) => issue.id == comment.issueId);
        final project =
        projects.firstWhere((project) => project.id == issue.projectId);
        JiraComment? updComment;
        if (comment.body.contains('~accountId:')) {
          final accountId =
          comment.body.split('~accountId:')[1].split(']')[0].trim();
          final user =
          users.firstWhereOrNull((user) => user.userId == accountId);
          if (user != null) {
            final updBody = comment.body.replaceAll(
                '[~accountId:$accountId]', '@{${user.displayName}}');
            updComment = comment.copyWith(body: updBody);
          }
        }
        return ChatComment(
            project: project,
            issue: issue,
            comment: updComment ?? comment,
            author: comment.author);
      }).toList();

      return transformedData;
    } catch (e) {
      throw ('Login Error: $e');
    }
  }

  @override
  Future<List<User>?> getAllUsers() async {
    try {
      final users = await jiraService.getUsers();
      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<ChatComment?> postComment(
      ChatComment commentToRespond, String text) async {
    try {
      final newComment =
      await jiraService.postCommentToIssue(commentToRespond.issue.id, text);
      final newChatComment = commentToRespond.copyWith(
          comment: newComment, author: newComment.author);
      return newChatComment;
    } catch (e) {
      throw ('Failed to send a comment. Check your connection!');
    }
  }
}
