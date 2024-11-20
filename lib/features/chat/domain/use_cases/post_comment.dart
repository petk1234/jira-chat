import 'package:jira_project/core/usecases/base_usecase.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:jira_project/features/chat/domain/repository/jira_repository.dart';

class PostComment implements BaseUseCase<ChatComment?, PostCommentParams> {
  final JiraRepository repository;

  PostComment(this.repository);

  @override
  Future<ChatComment?> call({PostCommentParams? params}){
    if(params == null){
      throw Exception('Params cannot be null');
    }
    return repository.postComment( params.commentToRespond,  params.text);
  }
}

class PostCommentParams{
  final ChatComment commentToRespond;
  final String text;

  PostCommentParams({required this.commentToRespond, required this.text});
}