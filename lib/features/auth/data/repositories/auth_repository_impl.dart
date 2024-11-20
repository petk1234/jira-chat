import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/auth/data/services/auth_service.dart';
import 'package:jira_project/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository{
  final AuthService authService;
  AuthRepositoryImpl({required this.authService});

  @override
  Future<User?> authorizeJiraUser(String email) async {
    final user = await authService.loginToJira(email);
    return user;
  }
}