import 'package:flutter/cupertino.dart';
import 'package:jira_project/features/chat/data/repositories_impl/jira_repository_impl.dart';
import 'package:jira_project/features/chat/data/services/jira_service_impl.dart';
import 'package:jira_project/features/chat/domain/use_cases/get_all_users.dart';
import 'package:jira_project/features/chat/domain/use_cases/get_chat_comments.dart';
import 'package:jira_project/features/chat/domain/use_cases/post_comment.dart';
import 'package:jira_project/features/chat/presentation/chat.dart';
import 'package:jira_project/features/auth/presentation/login.dart';
import 'package:jira_project/features/chat/presentation/controllers/jira.dart';
import 'package:provider/provider.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/login': (context) {
    return Login();
  },
  '/chat': (context) {
    return ChangeNotifierProvider(
        create: (context) => JiraState(
            getAllUsersUseCase: GetAllUsers(
                JiraRepositoryImpl(
                    jiraService: JiraServiceImpl()
                )
            ),
            getChatCommentsUseCase: GetChatComments(
                JiraRepositoryImpl(
                    jiraService: JiraServiceImpl()
                )
            ),
            postCommentUseCase: PostComment(
                JiraRepositoryImpl(
                    jiraService: JiraServiceImpl()
                )
            ),
        ),
        child: Chat());
  },
};
