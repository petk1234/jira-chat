import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';

abstract class JiraRepository{
  Future<List<ChatComment>?> prepareChatComments(
      {String? email, required List<User> users});

  Future<List<User>?> getAllUsers();

  Future<ChatComment?> postComment(
      ChatComment commentToRespond, String text);
}