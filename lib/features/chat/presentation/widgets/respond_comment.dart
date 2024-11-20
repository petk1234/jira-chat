import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/features/chat/domain/entities/chat_comment.dart';
import 'package:jira_project/features/chat/presentation/controllers/jira.dart';
import 'package:jira_project/features/chat/presentation/widgets/comment.dart';
import 'package:provider/provider.dart';

class RespondComment extends StatelessWidget{
  final ChatComment comment;
  const RespondComment({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<JiraState>(context);

    return Dismissible(
      key: ValueKey<int>(int.parse(comment.comment.id)),
      onDismissed: null,
      background: _buildResponseBg(),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        state.setSelectedComment(comment);
        state.openKeyboard(context);
        return false;
      },
      child: Comment(comment: comment),
    );
  }

  Widget _buildResponseBg() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.reply, color: Colors.white),
          SizedBox(width: 8),
          Text('Reply', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}