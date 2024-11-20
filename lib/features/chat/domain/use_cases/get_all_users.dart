import 'package:jira_project/core/usecases/base_usecase.dart';
import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/domain/repository/jira_repository.dart';

class GetAllUsers extends BaseUseCase<List<User>?, NoParams>{
  final JiraRepository repository;

  GetAllUsers(this.repository);

  @override
  Future<List<User>?> call({NoParams? params}) {
    return repository.getAllUsers();
  }
}