import 'package:jira_project/core/usecases/base_usecase.dart';
import 'package:jira_project/features/auth/data/models/user.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:jira_project/features/chat/domain/repository/jira_repository.dart';

class GetChatComments implements BaseUseCase<List<ChatComment>?, GetChatCommentsParams> {
  final JiraRepository repository;

  GetChatComments(this.repository);

  @override
  Future<List<ChatComment>?> call({GetChatCommentsParams? params}){
    if(params == null){
      throw Exception('Params cannot be null');
    }
    return repository.prepareChatComments(email: params.email, users: params.users);
  }
}

class GetChatCommentsParams{
  final String? email;
  final List<User> users;

  GetChatCommentsParams({required this.users, this.email});
}