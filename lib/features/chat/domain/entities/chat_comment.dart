

import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/data/models/jira_comment.dart';
import 'package:jira_project/features/chat/data/models/jira_issue.dart';
import 'package:jira_project/features/chat/data/models/jira_project.dart';

class ChatComment {
  final JiraProject project;
  final JiraIssue issue;
  final JiraComment comment;
  final User author;
  ChatComment({
    required this.project,
    required this.issue,
    required this.comment,
    required this.author,
  });

  ChatComment copyWith(
      {JiraProject? project,
      JiraIssue? issue,
      JiraComment? comment,
      User? author}) {
    return ChatComment(
      project: project ?? this.project.copyWith(),
      issue: issue ?? this.issue.copyWith(),
      comment: comment ?? this.comment.copyWith(),
      author: author ?? this.author.copyWith(),
    );
  }
}
