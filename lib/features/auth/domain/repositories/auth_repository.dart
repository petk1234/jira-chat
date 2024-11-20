import 'package:jira_project/features/auth/data/models/user.dart';

abstract class AuthRepository{
  Future<User?> authorizeJiraUser(String email);
}