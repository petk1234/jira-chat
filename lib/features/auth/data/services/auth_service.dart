import 'package:jira_project/features/auth/data/models/user.dart';

abstract class AuthService{
  Future<User?> loginToJira(String email);
}