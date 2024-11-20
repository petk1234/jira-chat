import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/features/auth/presentation/controllers/auth.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:jira_project/features/chat/presentation/controllers/jira.dart';
import 'package:jira_project/features/chat/presentation/widgets/comment.dart';
import 'package:jira_project/features/chat/presentation/widgets/respond_comment.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<JiraState>(context).chatComments;
    return Flexible(
        child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      reverse: true,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];

        return _buildComment(comment, context);
      },
    ));
  }

  Widget _buildComment(ChatComment comment, BuildContext context) {
    final isAuthorizedComment = comment.author.emailAddress ==
        Provider.of<AuthState>(context).user!.emailAddress;

    return Row(
        mainAxisAlignment: isAuthorizedComment
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          isAuthorizedComment
              ? Comment(comment: comment)
              : RespondComment(comment: comment)
        ]);
  }
}
