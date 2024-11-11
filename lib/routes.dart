import 'package:flutter/cupertino.dart';
import 'package:jira_project/controllers/jira.dart';
import 'package:jira_project/data/jira_service.dart';
import 'package:jira_project/features/chat/chat.dart';
import 'package:jira_project/features/login.dart';
import 'package:jira_project/domain/repository/jira_repository.dart';
import 'package:provider/provider.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/login': (context) {
    return Login();
  },
  '/chat': (context) {
    return ChangeNotifierProvider(
        create: (context) => JiraState(
            jiraRepository: JiraRepository(jiraService: JiraService())),
        child: Chat());
  },
};
