import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/data/models/user.dart';
import 'package:jira_project/domain/repository/jira_repository.dart';

class AuthState extends ChangeNotifier {
  User? user;
  AuthenticationStatus authStatus = AuthenticationStatus.unauthenticated;
  final JiraRepository jiraRepository;
  AuthState({required this.jiraRepository});

  authorizeUser(String email, BuildContext context) async {
    try {
      authStatus = AuthenticationStatus.inProgress;
      notifyListeners();
      final authorizedUser = await jiraRepository.authorizeJiraUser(email);
      if (authorizedUser != null && context.mounted) {
        user = authorizedUser;
        authStatus = AuthenticationStatus.authenticated;
        Navigator.pushNamedAndRemoveUntil(
            context, '/chat', (Route<dynamic> route) => false);
        notifyListeners();
      } else {
        authStatus = AuthenticationStatus.unauthenticated;
        notifyListeners();
      }
    } catch (e) {
      authStatus = AuthenticationStatus.unauthenticated;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.55),
          content: Text('Credentials are wrong')));
    }
  }
}

enum AuthenticationStatus { authenticated, unauthenticated, inProgress }
